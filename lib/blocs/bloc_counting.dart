import 'package:flutter/foundation.dart';

class BlocCounting extends ChangeNotifier {
  int number = 0;

  void increment() {
    number = number + 1;
    notifyListeners();
  }

  void decrement() {
    if (number != 0) {
      number = number - 1;
    } else {
      print('number is zero');
    }

    notifyListeners();
  }
}
