import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../sound_manager.dart';
import '../services/auth_service.dart';
import '../data/repositories/progress_repository.dart';
import '../data/models/test_progress.dart';

class TestScreen extends StatefulWidget {
  final String subject;
  final List<dynamic> tasks;

  const TestScreen({
    super.key,
    required this.subject,
    required this.tasks,
  });

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late List<TextEditingController> _controllers;
  late List<bool> _isCorrect;
  bool _testCompleted = false;
  int _correctAnswers = 0;
  final AuthService _authService = AuthService();
  final ProgressRepository _progressRepository = ProgressRepository();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.tasks.length,
      (index) => TextEditingController(),
    );
    _isCorrect = List.filled(widget.tasks.length, false);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Конвертировать название предмета в subjectId
  String _getSubjectId(String subjectName) {
    switch (subjectName.toLowerCase()) {
      case 'математика':
        return 'math';
      case 'информатика':
        return 'informatics';
      case 'биология':
        return 'biology';
      case 'обществознание':
        return 'obshchestvo';
      default:
        return subjectName.toLowerCase();
    }
  }

  Future<void> _checkAnswers() async {
    int correct = 0;
    for (int i = 0; i < widget.tasks.length; i++) {
      final userAnswer = _controllers[i].text.trim();
      final correctAnswer = widget.tasks[i].answer.trim();
      _isCorrect[i] = userAnswer == correctAnswer;
      if (_isCorrect[i]) correct++;
    }

    setState(() {
      _correctAnswers = correct;
      _testCompleted = true;
    });

    // Сохраняем прогресс, если пользователь авторизован
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      try {
        final progress = TestProgress(
          userId: currentUser.id,
          subjectId: _getSubjectId(widget.subject),
          correctAnswers: correct,
          totalQuestions: widget.tasks.length,
          updatedAt: DateTime.now(),
        );
        await _progressRepository.saveProgress(progress);
      } catch (e) {
        // Игнорируем ошибки сохранения прогресса, чтобы не мешать пользователю
        debugPrint('Ошибка при сохранении прогресса: $e');
      }
    }
  }

  void _resetTest() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _isCorrect = List.filled(widget.tasks.length, false);
      _testCompleted = false;
      _correctAnswers = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Тест по ${widget.subject}',
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
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.tasks.length,
                  itemBuilder: (context, index) {
                    final task = widget.tasks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      color: _testCompleted
                          ? (_isCorrect[index] 
                              ? Colors.green[50] 
                              : Colors.red[50])
                          : Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: const Color.fromARGB(255, 75, 79, 163),
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Задание ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Klyakson',
                                color: Color.fromARGB(255, 75, 79, 163),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.question,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _controllers[index],
                              decoration: InputDecoration(
                                labelText: 'Ваш ответ',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Klyakson',
                                  color: Color.fromARGB(255, 75, 79, 163),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: const Color.fromARGB(255, 75, 79, 163),
                                  ),
                                ),
                                suffixIcon: _testCompleted
                                    ? Icon(
                                        _isCorrect[index]
                                            ? Icons.check
                                            : Icons.close,
                                        color: _isCorrect[index]
                                            ? Colors.green
                                            : Colors.red,
                                      )
                                    : null,
                              ),
                              readOnly: _testCompleted,
                              style: const TextStyle(fontFamily: 'Klyakson'),
                            ),
                            if (_testCompleted && !_isCorrect[index])
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Правильный ответ: ${task.answer}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Klyakson',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_testCompleted)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromARGB(255, 75, 79, 163),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Результат: $_correctAnswers из ${widget.tasks.length}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Klyakson',
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Процент правильных ответов: ${(_correctAnswers / widget.tasks.length * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Klyakson',
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/handwritten_button.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    SoundManager.playPenClick();
                    _testCompleted ? _resetTest() : _checkAnswers();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 75, 79, 163),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Center(
                    child: Text(
                      _testCompleted ? 'Пройти тест заново' : 'Проверить ответы',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Klyakson',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}