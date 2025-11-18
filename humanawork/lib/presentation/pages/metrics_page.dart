import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../data/services/api_service.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage>
    with SingleTickerProviderStateMixin {
  bool _carregando = true;
  List<dynamic> _metricas = [];

  late AnimationController _animController;

  // COR ROXA DO TEMA
  final Color primary = const Color(0xFF6C63FF);

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _carregar();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    try {
      final agora = DateTime.now();
      final ontem = agora.subtract(const Duration(days: 1));

      final usuarioId = ApiService.userId!;
      final dados = await ApiService.obterMetricas(
        usuarioId: usuarioId,
        dataIni: ontem,
        dataFim: agora,
      );

      setState(() {
        _metricas = dados;
        _carregando = false;
      });

      _animController.forward(); // inicia animações
    } catch (e) {
      setState(() {
        _metricas = [];
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Métricas'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _metricas.isEmpty
                ? _semMetricas()
                : _listaMetricas(),
      ),
    );
  }

  Widget _semMetricas() {
    return const Center(
      child: Text(
        'Nenhuma métrica encontrada neste período.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _listaMetricas() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _metricas.length,
      itemBuilder: (context, index) {
        final item = _metricas[index];

        final animation = CurvedAnimation(
          parent: _animController,
          curve: Interval(
            index * 0.15,
            0.9,
            curve: Curves.easeOut,
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).animate(animation),
            child: _cardMetrica(item, index),
          ),
        );
      },
    );
  }

  Widget _cardMetrica(dynamic item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topoCard(index, item),
            const SizedBox(height: 20),

            _linhaValor(
              icon: Icons.schedule,
              titulo: "Total de Minutos Focados",
              valor: "${item["TOTAL_MINUTOS"]}",
            ),

            _linhaValor(
              icon: Icons.check_circle,
              titulo: "Total de Sessões",
              valor: "${item["SESSOES_QTD"]}",
            ),

            _linhaValor(
              icon: Icons.mood,
              titulo: "Humor médio",
              valor: "${item["MEDIA_HUMOR"]}",
            ),

            const SizedBox(height: 16),

            _barraProgresso(
              label: "Produtividade",
              valor: ((item["TOTAL_MINUTOS"] ?? 0) / 60).clamp(0, 1.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topoCard(int index, dynamic item) {
    final data = (item["DIA"] ?? "").toString().split("T").first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Dia $data",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        CircleAvatar(
          radius: 18,
          backgroundColor: primary.withOpacity(0.15),
          child: Text(
            "${index + 1}",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _linhaValor({
    required IconData icon,
    required String titulo,
    required String valor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(titulo, style: const TextStyle(fontSize: 15)),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _barraProgresso({
    required String label,
    required double valor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: valor),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    backgroundColor: primary.withOpacity(0.20),
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${(value * 100).round()}%",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
