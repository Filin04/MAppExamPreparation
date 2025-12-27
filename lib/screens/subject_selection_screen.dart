import 'package:flutter/material.dart';
import 'package:app/app_theme.dart';
import 'package:app/sound_manager.dart';
import 'math_screen.dart';
import 'informatics_screen.dart';
import 'biology_screen.dart';
import 'obshchestvo_screen.dart';
import 'statistics_screen.dart';

class SubjectSelectionScreen extends StatelessWidget {
  const SubjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Выберите предмет',
          style: TextStyle(
            fontFamily: 'Klyakson',
            fontSize: 24,
            color: Color.fromARGB(255, 75, 79, 163),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 75, 79, 163)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            color: const Color.fromARGB(255, 75, 79, 163),
            onPressed: () {
              SoundManager.playPenClick();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
            tooltip: 'Статистика',
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: AppTheme.paperBackground,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSubjectButton(
                    text: 'Математика',
                    icon: Icons.calculate,
                    onPressed: () => _navigateTo(context, const MathScreen()),
                  ),
                  const SizedBox(height: 20),
                  _buildSubjectButton(
                    text: 'Информатика',
                    icon: Icons.computer,
                    onPressed: () => _navigateTo(context, const InformaticsScreen()),
                  ),
                  const SizedBox(height: 20),
                  _buildSubjectButton(
                    text: 'Биология',
                    icon: Icons.eco,
                    onPressed: () => _navigateTo(context, const BiologyScreen()),
                  ),
                  const SizedBox(height: 20),
                  _buildSubjectButton(
                    text: 'Обществознание',
                    icon: Icons.people,
                    onPressed: () => _navigateTo(context, const ObshchestvoScreen()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    SoundManager.playPenClick();
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget _buildSubjectButton({
  required String text,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 40),
    height: 70, // Увеличена высота кнопки
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/handwritten_button.png'),
        fit: BoxFit.fill,
      ),
    ),
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 75, 79, 163),
        padding: const EdgeInsets.symmetric(vertical: 20), // Увеличен padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28), // Увеличен размер иконки
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 22, // Увеличен размер текста
              fontWeight: FontWeight.bold,
              fontFamily: 'Klyakson',
            ),
          ),
        ],
      ),
    ),
  );
}
}