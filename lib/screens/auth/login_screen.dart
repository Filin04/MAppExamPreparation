import 'package:flutter/material.dart';
import 'package:app/app_theme.dart';
import 'package:app/sound_manager.dart';
import 'package:app/services/auth_service.dart';
import '../subject_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Контроллеры для входа
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  
  // Контроллеры для регистрации
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmPasswordController = TextEditingController();
  
  // Ключи для форм
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  
  // Видимость паролей
  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  bool _registerConfirmPasswordVisible = false;

  // Состояние загрузки
  bool _isLoading = false;

  // Сервис аутентификации
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  // Валидация email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }
    return null;
  }

  // Валидация пароля
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    return null;
  }

  // Валидация подтверждения пароля
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != _registerPasswordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  // Обработка входа
  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SoundManager.playPenClick();

    try {
      final result = await _authService.login(
        _loginEmailController.text.trim(),
        _loginPasswordController.text,
      );

      if (!mounted) return;

      if (result.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SubjectSelectionScreen()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.message,
              style: const TextStyle(fontFamily: 'Klyakson'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Произошла ошибка при входе',
            style: TextStyle(fontFamily: 'Klyakson'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Обработка регистрации
  Future<void> _handleRegister() async {
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SoundManager.playPenClick();

    try {
      final result = await _authService.register(
        _registerEmailController.text.trim(),
        _registerPasswordController.text,
      );

      if (!mounted) return;

      if (result.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SubjectSelectionScreen()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.message,
              style: const TextStyle(fontFamily: 'Klyakson'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Произошла ошибка при регистрации',
            style: TextStyle(fontFamily: 'Klyakson'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Подготовка к ЕГЭ',
          style: TextStyle(
            fontFamily: 'Klyakson',
            fontSize: 24,
            color: Color.fromARGB(255, 75, 79, 163),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color.fromARGB(255, 75, 79, 163),
          unselectedLabelColor: const Color.fromARGB(255, 75, 79, 163).withOpacity(0.6),
          indicatorColor: const Color.fromARGB(255, 75, 79, 163),
          labelStyle: const TextStyle(
            fontFamily: 'Klyakson',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Klyakson',
            fontSize: 18,
          ),
          onTap: (index) {
            SoundManager.playPenClick();
          },
          tabs: const [
            Tab(text: 'Вход'),
            Tab(text: 'Регистрация'),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: AppTheme.paperBackground,
        padding: const EdgeInsets.only(top: 120),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildLoginTab(),
            _buildRegisterTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _loginEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          fontFamily: 'Klyakson',
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: _validateEmail,
                      style: const TextStyle(fontFamily: 'Klyakson'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _loginPasswordController,
                      obscureText: !_loginPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        labelStyle: const TextStyle(
                          fontFamily: 'Klyakson',
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _loginPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: const Color.fromARGB(255, 75, 79, 163),
                          ),
                          onPressed: () {
                            setState(() {
                              _loginPasswordVisible = !_loginPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: _validatePassword,
                      style: const TextStyle(fontFamily: 'Klyakson'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildHandwrittenButton(
              text: 'Войти',
              onPressed: _isLoading ? null : _handleLogin,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _registerEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          fontFamily: 'Klyakson',
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: _validateEmail,
                      style: const TextStyle(fontFamily: 'Klyakson'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _registerPasswordController,
                      obscureText: !_registerPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        labelStyle: const TextStyle(
                          fontFamily: 'Klyakson',
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _registerPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: const Color.fromARGB(255, 75, 79, 163),
                          ),
                          onPressed: () {
                            setState(() {
                              _registerPasswordVisible = !_registerPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: _validatePassword,
                      onChanged: (_) {
                        // Обновляем валидацию подтверждения пароля при изменении пароля
                        if (_registerConfirmPasswordController.text.isNotEmpty) {
                          _registerFormKey.currentState?.validate();
                        }
                      },
                      style: const TextStyle(fontFamily: 'Klyakson'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _registerConfirmPasswordController,
                      obscureText: !_registerConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Подтвердите пароль',
                        labelStyle: const TextStyle(
                          fontFamily: 'Klyakson',
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 75, 79, 163),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _registerConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: const Color.fromARGB(255, 75, 79, 163),
                          ),
                          onPressed: () {
                            setState(() {
                              _registerConfirmPasswordVisible = !_registerConfirmPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 75, 79, 163),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: _validateConfirmPassword,
                      style: const TextStyle(fontFamily: 'Klyakson'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildHandwrittenButton(
              text: 'Зарегистрироваться',
              onPressed: _isLoading ? null : _handleRegister,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandwrittenButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 60,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/handwritten_button.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 75, 79, 163),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          disabledForegroundColor: const Color.fromARGB(255, 75, 79, 163).withOpacity(0.5),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 75, 79, 163),
                    ),
                  ),
                )
              : Text(
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

