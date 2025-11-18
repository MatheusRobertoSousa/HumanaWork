import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../core/app_routes.dart';
import '../../../data/services/api_service.dart';

class FocusRoomsPage extends StatefulWidget {
  const FocusRoomsPage({super.key});

  @override
  State<FocusRoomsPage> createState() => _FocusRoomsPageState();
}

class _FocusRoomsPageState extends State<FocusRoomsPage>
    with SingleTickerProviderStateMixin {
  bool _carregando = true;
  List<Map<String, dynamic>> _salas = [];

  late AnimationController _animController;

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
    final salas = await ApiService.listarSalas();

    setState(() {
      _salas = salas;
      _carregando = false;
    });

    _animController.forward();
  }

  void _navegarParaCriacaoSala() async {
    final novaSalaCriada = await Navigator.pushNamed(
      context,
      AppRoutes.createFocusRoom,
    );

    if (novaSalaCriada != null) {
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salas de foco'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _salas.isEmpty
                ? _semSalas()
                : _listaSalas(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaCriacaoSala,
        tooltip: 'Criar nova sala',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _semSalas() {
    return const Center(
      child: Text(
        "Nenhuma sala criada ainda.",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _listaSalas() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _salas.length,
      itemBuilder: (context, index) {
        final sala = _salas[index];

        final nomeSala = sala['nomeSala'] as String? ?? 'Sala sem nome';
        final temaSala = sala['tema'] as String? ?? 'Geral';
        final dataCriacaoStr = sala['dataCriacao'] as String? ?? '';

        String dataFormatada = 'Sem data';
        if (dataCriacaoStr.isNotEmpty) {
          dataFormatada = dataCriacaoStr.split('T').first;
        }

        /// ANIMAÇÃO STAGGERED
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
            child: _cardSala(
              sala: sala,
              nomeSala: nomeSala,
              temaSala: temaSala,
              dataFormatada: dataFormatada,
            ),
          ),
        );
      },
    );
  }

  Widget _cardSala({
    required Map<String, dynamic> sala,
    required String nomeSala,
    required String temaSala,
    required String dataFormatada,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

        title: Text(
          nomeSala,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        subtitle: Text(
          '$temaSala · Criada em $dataFormatada',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),

        trailing: const Icon(Icons.chevron_right, color: Colors.blueAccent),

        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.focusRoomDetail,
            arguments: sala,
          );
        },
      ),
    );
  }
}
