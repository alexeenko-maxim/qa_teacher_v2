import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white, // Для иконок и текста на AppBar
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.blueAccent, // Акцентный цвет теперь определяется здесь
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue, // Цвет текста кнопок
        ),
      ),
    );
  }
}
