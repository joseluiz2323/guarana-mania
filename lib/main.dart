import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_widget.dart';
import 'database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Database.init();
  runApp(const MyApp());
}
