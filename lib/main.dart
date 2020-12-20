import 'screens/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  cardColor: Colors.white70,
  accentColor: Colors.black,
  cursorColor: Colors.black,
  dialogBackgroundColor: Colors.white,
  primaryColor: Colors.white,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WallpaperWorld',
      theme: _lightTheme,
      home: Home(),
    );
  }
}
