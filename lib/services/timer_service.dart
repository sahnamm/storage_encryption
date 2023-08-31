import 'package:flutter/material.dart';

class TimerService {
  TimerService._();
  static final TimerService _instance = TimerService._();
  factory TimerService() => _instance;

  Duration option0 = const Duration(microseconds: 0);
  Duration option1 = const Duration(microseconds: 0);
  Duration option2 = const Duration(microseconds: 0);
  Duration option3 = const Duration(microseconds: 0);
  Duration option4 = const Duration(microseconds: 0);

  captureNormal(Function() func) {
    final stopwatch = Stopwatch()..start();
    func();
    stopwatch.stop();
    option0 = stopwatch.elapsed;
    debugPrint('captureNormal executed in ${stopwatch.elapsed}');
  }

  captureOption1(Function() func) {
    final stopwatch = Stopwatch()..start();
    func();
    stopwatch.stop();
    option1 = stopwatch.elapsed;
    debugPrint('captureOption1 executed in ${stopwatch.elapsed}');
  }

  captureOption2(Function() func) {
    final stopwatch = Stopwatch()..start();
    func();
    stopwatch.stop();
    option2 = stopwatch.elapsed;
    debugPrint('captureOption2 executed in ${stopwatch.elapsed}');
  }

  captureOption3(Function() func) {
    final stopwatch = Stopwatch()..start();
    func();
    stopwatch.stop();
    option3 = stopwatch.elapsed;
    debugPrint('captureOption3 executed in ${stopwatch.elapsed}');
  }

  captureOption4(Function() func) async {
    final stopwatch = Stopwatch()..start();
    func();
    stopwatch.stop();
    option4 = stopwatch.elapsed;
    debugPrint('captureOption4 executed in ${stopwatch.elapsed}');
  }
}
