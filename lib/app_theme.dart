import 'package:flutter/material.dart';

class AppTheme {
  static const String klyaksonFont = 'Klyakson';
  
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: klyaksonFont,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static BoxDecoration get paperBackground {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/paper.png'),
        fit: BoxFit.cover,
        opacity: 0.9,
      ),
    );
  }

  static Widget getHandwrittenButton({
    required VoidCallback onPressed,
    required String text,
    Color? color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue[100],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Stack(
        children: [
          Image.asset('assets/images/handwritten_button.png'),
          Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Добавьте этот метод в ваш класс AppTheme
static Widget handwrittenButtonWithImage({
  required String text,
  required VoidCallback onPressed,
  Color textColor = const Color.fromARGB(255, 75, 79, 163), // Цвет текста как у обводки
}) {
  return SizedBox(
    width: double.infinity, // На всю ширину
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/handwritten_button.png'),
          fit: BoxFit.fill, // Растягиваем изображение на всю кнопку
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          minimumSize: const Size(double.infinity, 50), // Высота кнопки
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Klyakson',
            ),
          ),
        ),
      ),
    ),
  );
}
}