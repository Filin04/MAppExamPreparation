import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../sound_manager.dart';
import '../models/informatics_data.dart';
import 'test_variants_screen.dart';

class InformaticsScreen extends StatefulWidget {
  const InformaticsScreen({super.key});

  @override
  State<InformaticsScreen> createState() => _InformaticsScreenState();
}

class _InformaticsScreenState extends State<InformaticsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Информатика',
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
        child: _selectedIndex == 0 ? _buildTheoryScreen() : _buildPracticeScreen(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildTestButton(context),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: Colors.white.withOpacity(0.8),
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: 'Теория',
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment),
            label: 'Практика',
            backgroundColor: Colors.transparent,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          SoundManager.playPenClick();
          _onItemTapped(index);
        },
        selectedItemColor: const Color.fromARGB(255, 75, 79, 163),
        unselectedItemColor: const Color.fromARGB(255, 75, 79, 163).withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Widget _buildTestButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 75, 79, 163).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          SoundManager.playPenClick();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestVariantsScreen(subject: 'Информатика'),
            ),
          );
        },
        tooltip: 'Варианты тестов',
        backgroundColor: Colors.white,
        child: Icon(
          Icons.assignment_turned_in,
          color: const Color.fromARGB(255, 75, 79, 163),
          size: 28,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildTheoryScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: informaticsTheory.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              title: Text(
                informaticsTheory[index].topic,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Klyakson',
                  fontSize: 18,
                  color: Color.fromARGB(255, 75, 79, 163),
                ),
              ),
              onExpansionChanged: (expanded) {
                if (expanded) SoundManager.playPageFlip();
              },
              children: [
                Container(
                  color: Colors.white.withOpacity(0.9),
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    informaticsTheory[index].content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPracticeScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: informaticsTasks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
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
                  'Задание ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Klyakson',
                    decoration: TextDecoration.underline,
                    color: Color.fromARGB(255, 75, 79, 163),
                  ),
                ),
                const SizedBox(height: 12),
                Text(informaticsTasks[index].question),
                const SizedBox(height: 16),
                _buildAnswerButton(context, informaticsTasks[index].answer),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerButton(BuildContext context, String answer) {
    return Container(
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
          _showAnswerDialog(context, answer);
        },
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 75, 79, 163),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Center(
          child: Text(
            'Показать ответ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Klyakson',
            ),
          ),
        ),
      ),
    );
  }

  void _showAnswerDialog(BuildContext context, String answer) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ответ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Klyakson',
                    color: Color.fromARGB(255, 75, 79, 163),
                  ),
                ),
                const SizedBox(height: 16),
                Text(answer),
                const SizedBox(height: 24),
                _buildCloseButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/handwritten_button.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: TextButton(
        onPressed: () {
          SoundManager.playPenClick();
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 75, 79, 163),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
        ),
        child: const Text(
          'Закрыть',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Klyakson',
          ),
        ),
      ),
    );
  }
}