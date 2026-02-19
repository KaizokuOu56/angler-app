import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;
  bool _isStreaming = false;

  Future<void> initialize() async {
    final cameras = await availableCameras();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  Future<void> startListening(Function(double) onBrightness) async {
    if (_controller == null || _isStreaming) return;

    _isStreaming = true;

    await _controller!.startImageStream((image) {
      final bytes = image.planes[0].bytes;

      double sum = 0;
      for (int i = 0; i < bytes.length; i += 10) {
        sum += bytes[i];
      }

      double avgBrightness = sum / (bytes.length / 10);

      onBrightness(avgBrightness);
    });
  }

  Future<void> stopListening() async {
    if (_controller != null && _isStreaming) {
      await _controller!.stopImageStream();
      _isStreaming = false;
    }
  }

  CameraController? get controller => _controller;

  Future<void> dispose() async {
    await stopListening();
    await _controller?.dispose();
  }
}
