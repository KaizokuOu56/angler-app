import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../services/decoder_service.dart';

class ReceiverScreen extends StatefulWidget {
  const ReceiverScreen({super.key});

  @override
  State<ReceiverScreen> createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  final CameraService cameraService = CameraService();
  final DecoderService decoderService = DecoderService();

  bool isListening = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await cameraService.initialize();
    setState(() {
      isInitialized = true;
    });
  }

  @override
  void dispose() {
    cameraService.dispose();
    super.dispose();
  }

  Future<void> startListening() async {
    await cameraService.startListening((brightness) {
      decoderService.processBrightness(brightness);
      setState(() {});
    });

    setState(() {
      isListening = true;
    });
  }

  Future<void> stopListening() async {
    await cameraService.stopListening();
    decoderService.finalizeMessage();

    setState(() {
      isListening = false;
    });
  }

  void clearText() {
    decoderService.reset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized ||
        cameraService.controller == null ||
        !cameraService.controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Receiver")),
      body: Column(
        children: [
          Expanded(child: CameraPreview(cameraService.controller!)),

          // Decoded text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              decoderService.decodedText,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),

          // 🔥 LIVE MORSE BAR
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                decoderService.liveMorse,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isListening ? null : startListening,
                child: const Text("Start"),
              ),
              ElevatedButton(
                onPressed: isListening ? stopListening : null,
                child: const Text("Stop"),
              ),
              ElevatedButton(onPressed: clearText, child: const Text("Clear")),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
