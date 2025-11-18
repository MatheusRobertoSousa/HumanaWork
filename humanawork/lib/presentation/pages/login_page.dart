import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../data/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    setState(() => _carregando = true);
    final ok = await ApiService.login(
      _emailController.text,
      _senhaController.text,
    );
    setState(() => _carregando = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciais inválidas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LOGO + ANIMAÇÃO
                    AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        Icons.work_rounded,
                        size: 90,
                        color: colors.primary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'HumanaWork',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Trabalho remoto mais humano e colaborativo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // CAMPOS DE TEXTO
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                      ),
                    ),

                    const SizedBox(height: 28),

                    // BOTÃO ANIMADO
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _carregando ? null : _fazerLogin,
                          style: ElevatedButton.styleFrom(
                            elevation: _carregando ? 0 : 2,
                          ),
                          child: _carregando
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                  ),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TEXTO ANIMADO OPCIONAL
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Esqueci minha senha",
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
