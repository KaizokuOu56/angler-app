import 'package:flutter/material.dart';
import '../services/flash_service.dart';

class SenderScreen extends StatefulWidget {
  const SenderScreen({super.key});

  @override
  State<SenderScreen> createState() => _SenderScreenState();
}

class _SenderScreenState extends State<SenderScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sender")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter text (no spaces)",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Send"),
              onPressed: () async {
                await FlashService.flashMessage(controller.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
