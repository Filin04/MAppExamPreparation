import 'package:flutter/material.dart';
import 'package:app/app_theme.dart';
import 'package:app/sound_manager.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/data/repositories/progress_repository.dart';
import 'package:app/data/models/test_progress.dart';
import 'math_screen.dart';
import 'informatics_screen.dart';
import 'biology_screen.dart';
import 'obshchestvo_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final AuthService _authService = AuthService();
  final ProgressRepository _progressRepository = ProgressRepository();
  
  List<TestProgress> _allProgress = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final progress = _progressRepository.getAllProgressForUser(currentUser.id);
    setState(() {
      _allProgress = progress;
      _isLoading = false;
    });
  }

  /// Получить прогресс для конкретного предмета
  TestProgress? _getProgressForSubject(String subjectId) {
    try {
      return _allProgress.firstWhere((p) => p.subjectId == subjectId);
    } catch (e) {
      return null;
    }
  }

  /// Вычислить средний процент по всем предметам
  double _calculateAverageProgress() {
    if (_allProgress.isEmpty) return 0.0;
    double sum = 0.0;
    for (var progress in _allProgress) {
      sum += progress.percentage;
    }
    return sum / _allProgress.length;
  }

  /// Получить мотивационный текст на основе среднего прогресса
  String _getMotivationalText(double average) {
    if (average < 50) {
      return 'Отличное время начать тренироваться!';
    } else if (average < 80) {
      return 'Хороший прогресс — продолжай в том же духе!';
    } else {
      return 'Ты почти готов к экзамену!';
    }
  }

  /// Получить уровень на основе процента
  String _getLevel(double percentage) {
    if (percentage < 40) {
      return 'Новичок';
    } else if (percentage < 70) {
      return 'Ученик';
    } else if (percentage < 90) {
      return 'Профи';
    } else {
      return 'Эксперт';
    }
  }

  /// Получить цвет уровня
  Color _getLevelColor(double percentage) {
    if (percentage < 40) {
      return Colors.grey;
    } else if (percentage < 70) {
      return Colors.blue;
    } else if (percentage < 90) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  /// Конвертировать subjectId в русское название
  String _getSubjectName(String subjectId) {
    switch (subjectId) {
      case 'math':
        return 'Математика';
      case 'informatics':
        return 'Информатика';
      case 'biology':
        return 'Биология';
      case 'obshchestvo':
        return 'Обществознание';
      default:
        return subjectId;
    }
  }

  /// Получить экран предмета для навигации
  Widget _getSubjectScreen(String subjectId) {
    switch (subjectId) {
      case 'math':
        return const MathScreen();
      case 'informatics':
        return const InformaticsScreen();
      case 'biology':
        return const BiologyScreen();
      case 'obshchestvo':
        return const ObshchestvoScreen();
      default:
        return const SizedBox();
    }
  }

  /// Форматировать дату
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Твоя статистика',
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
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: AppTheme.paperBackground,
          padding: const EdgeInsets.only(top: 80),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Для просмотра статистики необходимо войти в систему',
                    style: const TextStyle(
                      fontFamily: 'Klyakson',
                      fontSize: 16,
                      color: Color.fromARGB(255, 75, 79, 163),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Твоя статистика',
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
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: AppTheme.paperBackground,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 75, 79, 163),
              ),
            ),
          ),
        ),
      );
    }

    final averageProgress = _calculateAverageProgress();
    final subjects = ['math', 'informatics', 'biology', 'obshchestvo'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Твоя статистика',
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
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: AppTheme.paperBackground,
        padding: const EdgeInsets.only(top: 80),
        child: RefreshIndicator(
          onRefresh: _loadProgress,
          color: const Color.fromARGB(255, 75, 79, 163),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Общий прогресс
                Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Общий прогресс',
                          style: TextStyle(
                            fontFamily: 'Klyakson',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: averageProgress / 100,
                            minHeight: 30,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              averageProgress < 50
                                  ? Colors.orange
                                  : averageProgress < 80
                                      ? Colors.blue
                                      : Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${averageProgress.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontFamily: 'Klyakson',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 75, 79, 163),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _getMotivationalText(averageProgress),
                                style: const TextStyle(
                                  fontFamily: 'Klyakson',
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Карточки предметов
                ...subjects.map((subjectId) {
                  final progress = _getProgressForSubject(subjectId);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildSubjectCard(subjectId, progress),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(String subjectId, TestProgress? progress) {
    final subjectName = _getSubjectName(subjectId);
    final percentage = progress?.percentage ?? 0.0;
    final hasData = progress != null;

    return Card(
      color: Colors.white.withOpacity(0.9),
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
              subjectName,
              style: const TextStyle(
                fontFamily: 'Klyakson',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 75, 79, 163),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Круговой индикатор прогресса
                if (hasData)
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: percentage / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getLevelColor(percentage),
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontFamily: 'Klyakson',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.help_outline,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasData) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getLevelColor(percentage).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getLevelColor(percentage),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _getLevel(percentage),
                            style: TextStyle(
                              fontFamily: 'Klyakson',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getLevelColor(percentage),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Последний тест: ${_formatDate(progress!.updatedAt)}',
                          style: const TextStyle(
                            fontFamily: 'Klyakson',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ] else
                        Text(
                          'Тест ещё не проходили',
                          style: TextStyle(
                            fontFamily: 'Klyakson',
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 50,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/handwritten_button.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  SoundManager.playPenClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _getSubjectScreen(subjectId),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 75, 79, 163),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Center(
                  child: Text(
                    'Улучшить результат',
                    style: const TextStyle(
                      fontSize: 16,
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
    );
  }
}

