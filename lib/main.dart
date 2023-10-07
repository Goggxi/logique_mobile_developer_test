import 'package:flutter/material.dart';

import 'app.dart';
import 'di/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([configureDependencies()]);

  runApp(const MainApp());
}
