import 'package:torch_light/torch_light.dart';
import '../utils/morse.dart';

class FlashService {
  static const unit = Duration(milliseconds: 200); // 5Hz

  static Future<void> flashMessage(String text) async {
    for (var char in text.toUpperCase().split('')) {
      final morse = morseMap[char];
      if (morse == null) continue;

      for (var symbol in morse.split('')) {
        if (symbol == '.') {
          await TorchLight.enableTorch();
          await Future.delayed(unit);
          await TorchLight.disableTorch();
        } else {
          await TorchLight.enableTorch();
          await Future.delayed(unit * 3);
          await TorchLight.disableTorch();
        }
        await Future.delayed(unit);
      }
      await Future.delayed(unit * 2);
    }
  }
}
