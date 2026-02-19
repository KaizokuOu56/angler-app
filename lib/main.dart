import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isStrobing = false;
  double frequency = 5; // default 5 Hz
  Timer? _timer;

  void startStrobe() {
    final int halfPeriodMs = (1000 / (frequency * 2)).round();

    _timer = Timer.periodic(Duration(milliseconds: halfPeriodMs), (
      timer,
    ) async {
      try {
        await TorchLight.enableTorch();
        await Future.delayed(Duration(milliseconds: halfPeriodMs));
        await TorchLight.disableTorch();
      } catch (e) {
        debugPrint("Torch error: $e");
      }
    });

    setState(() {
      isStrobing = true;
    });
  }

  void stopStrobe() async {
    _timer?.cancel();
    await TorchLight.disableTorch();

    setState(() {
      isStrobing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: isStrobing ? Colors.black : Colors.white,
        appBar: AppBar(title: const Text("Strobe App")),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${frequency.toStringAsFixed(1)} Hz",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),

              Slider(
                value: frequency,
                min: 1,
                max: 10,
                divisions: 9,
                label: frequency.toStringAsFixed(1),
                onChanged: isStrobing
                    ? null
                    : (value) {
                        setState(() {
                          frequency = value;
                        });
                      },
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: isStrobing ? stopStrobe : startStrobe,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                ),
                child: Text(
                  isStrobing ? "Stop Strobe" : "Start Strobe",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
