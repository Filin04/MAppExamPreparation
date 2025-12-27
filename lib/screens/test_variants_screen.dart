import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../sound_manager.dart';
import '../models/math_data.dart' as math;
import '../models/informatics_data.dart' as informatics;
import '../models/biology_data.dart' as biology;
import '../models/obshchestvo_data.dart' as obshchestvo;
import 'test_screen.dart';

class TestVariantsScreen extends StatelessWidget {
  final String subject;

  const TestVariantsScreen({super.key, required this.subject});

  List<dynamic> _getRandomTasks(List<dynamic> allTasks, int count) {
    final shuffled = List.of(allTasks)..shuffle();
    return shuffled.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = subject == 'Математика'
        ? math.mathTasks
        : subject == 'Информатика'
            ? informatics.informaticsTasks
            : subject == 'Биология'
                ? biology.biologyTasks
                : subject == 'Обществознание'
                    ? obshchestvo.obshchestvoTasks
                    : [];
    final halfLength = (allTasks.length / 2).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Варианты тестов - $subject',
          style: const TextStyle(
            fontFamily: 'Klyakson',
            fontSize: 24,
            color: Color.fromARGB(255, 75, 79, 163),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 75, 79, 163)),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: AppTheme.paperBackground,
        padding: const EdgeInsets.only(top: 80),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildVariantCard(
                context,
                'Вариант 1',
                allTasks.sublist(0, halfLength),
              ),
              const SizedBox(height: 20),
              _buildVariantCard(
                context,
                'Вариант 2',
                allTasks.sublist(halfLength),
              ),
              const SizedBox(height: 20),
              _buildRandomTestCard(context, allTasks),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariantCard(BuildContext context, String title, List<dynamic> tasks) {
    return Card(
      elevation: 2,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Klyakson',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 75, 79, 163),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Количество заданий: ${tasks.length}',
              style: const TextStyle(
                fontFamily: 'Klyakson',
                fontSize: 16,
                color: Color.fromARGB(255, 75, 79, 163),
              ),
            ),
            const SizedBox(height: 15),
            _buildStartButton(
              context,
              'Начать тест',
              () {
                SoundManager.playPenClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestScreen(
                      subject: subject,
                      tasks: tasks,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomTestCard(BuildContext context, List<dynamic> allTasks) {
    return Card(
      elevation: 2,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Случайный тест',
              style: const TextStyle(
                fontFamily: 'Klyakson',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 75, 79, 163),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '7 случайных вопросов',
              style: const TextStyle(
                fontFamily: 'Klyakson',
                fontSize: 16,
                color: Color.fromARGB(255, 75, 79, 163),
              ),
            ),
            const SizedBox(height: 15),
            _buildStartButton(
              context,
              'Начать случайный тест',
              () {
                SoundManager.playPenClick();
                final randomTasks = _getRandomTasks(allTasks, 7);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestScreen(
                      subject: subject,
                      tasks: randomTasks,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      height: 60,
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
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Klyakson',
            ),
          ),
        ),
      ),
    );
  }
}