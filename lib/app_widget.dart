import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'global/color_global.dart';
import 'src/login/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guarana Mania',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: ColorGlobal.colorsbackground,
        primarySwatch: Colors.purple,
      ),
      home: const LoginPage(),
    );
  }
}
