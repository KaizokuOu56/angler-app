import '../utils/morse.dart';

class DecoderService {
  bool _isLightOn = false;
  DateTime? _lastChange;

  String _currentSymbol = '';

  String decodedText = '';
  String liveMorse = '';   // 👈 THIS IS NEW

  final int threshold;
  final Duration unit;

  DecoderService({
    this.threshold = 100, // Lowered for iPad safety
    this.unit = const Duration(milliseconds: 400),
  });

  void processBrightness(double brightness) {
    bool currentState = brightness > threshold;

    if (currentState != _isLightOn) {
      final now = DateTime.now();

      if (_lastChange != null) {
        final duration = now.difference(_lastChange!);
        _interpret(duration, _isLightOn);
      }

      _lastChange = now;
      _isLightOn = currentState;
    }
  }

  void _interpret(Duration duration, bool wasLightOn) {
    final ms = duration.inMilliseconds;

    if (wasLightOn) {
      // DOT or DASH
      if (ms < unit.inMilliseconds * 2.5) {
        _currentSymbol += '.';
        liveMorse += '.';
      } else {
        _currentSymbol += '-';
        liveMorse += '-';
      }
    } else {
      // Letter gap
      if (ms > unit.inMilliseconds * 2.5) {
        _finalizeLetter();
        liveMorse += ' '; // show letter break
      }

      // Word gap
      if (ms > unit.inMilliseconds * 6) {
        decodedText += ' ';
        liveMorse += ' ';
      }
    }
  }

  void _finalizeLetter() {
    if (_currentSymbol.isEmpty) return;

    final letter = _decodeMorse(_currentSymbol);
    if (letter != null) {
      decodedText += letter;
    }

    _currentSymbol = '';
  }

  void finalizeMessage() {
    if (_lastChange != null) {
      final now = DateTime.now();
      final duration = now.difference(_lastChange!);
      _interpret(duration, _isLightOn);
    }

    _finalizeLetter();
  }

  void reset() {
    _isLightOn = false;
    _lastChange = null;
    _currentSymbol = '';
    decodedText = '';
    liveMorse = '';
  }

  String? _decodeMorse(String symbol) {
    for (var entry in morseMap.entries) {
      if (entry.value == symbol) {
        return entry.key;
      }
    }
    return null;
  }
}
