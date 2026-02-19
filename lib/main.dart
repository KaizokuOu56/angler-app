import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOn = false;

  Future<void> toggleFlashlight() async {
    try {
      if (isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }

      setState(() {
        isOn = !isOn;
      });
    } catch (e) {
      debugPrint("Flashlight error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: isOn ? Colors.black : Colors.white,
        appBar: AppBar(title: const Text("Flashlight App")),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            onPressed: toggleFlashlight,
            child: Text(
              isOn ? "Turn Off 🔦" : "Turn On 🔦",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
