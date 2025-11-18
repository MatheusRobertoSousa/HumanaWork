import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../data/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _primeiroNome = 'Usuário';

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // ANIMAÇÃO PRINCIPAL DA TELA
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // CARREGA NOME DO USUÁRIO
    _carregarNomeUsuario();

    _controller.forward();
  }

  void _carregarNomeUsuario() {
    final nomeCompleto = ApiService.userName;
    if (nomeCompleto != null && nomeCompleto.isNotEmpty) {
      setState(() {
        _primeiroNome = nomeCompleto.split(' ').first;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedCard({
    required int position,
    required VoidCallback onTap,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final delay = (position * 120);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animValue = CurvedAnimation(
          parent: _controller,
          curve: Interval(delay / 600, 1, curve: Curves.easeOut),
        );

        return Opacity(
          opacity: animValue.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animValue.value)),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          leading: Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  // HEADER
                  Text(
                    'Olá, $_primeiroNome 👋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Como posso ajudar hoje?',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // CARDS COM ANIMAÇÃO INDIVIDUAL
                  _buildAnimatedCard(
                    position: 1,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.checkin),
                    title: 'Estado do dia',
                    subtitle: 'Registre como você está se sentindo hoje.',
                    icon: Icons.emoji_emotions_outlined,
                  ),

                  const SizedBox(height: 16),

                  _buildAnimatedCard(
                    position: 2,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.focusRooms),
                    title: 'Salas de foco',
                    subtitle: 'Concentre-se junto com seu time.',
                    icon: Icons.access_time_filled_rounded,
                  ),

                  const SizedBox(height: 16),

                  _buildAnimatedCard(
                    position: 3,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.metrics),
                    title: 'Minhas métricas',
                    subtitle: 'Veja seu progresso de foco e bem-estar.',
                    icon: Icons.stacked_line_chart_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
