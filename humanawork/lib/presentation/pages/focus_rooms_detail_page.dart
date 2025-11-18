import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../data/services/api_service.dart';

class FocusRoomDetailPage extends StatefulWidget {
  final Map<String, dynamic> sala;

  const FocusRoomDetailPage({super.key, required this.sala});

  @override
  State<FocusRoomDetailPage> createState() => _FocusRoomDetailPageState();
}

class _FocusRoomDetailPageState extends State<FocusRoomDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  int? _sessaoAtivaId;
  Timer? _timer;
  int _segundos = 0; // Cronômetro
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Robust: aceita id vindo como int ou String
  int? _getSalaId() {
    final raw = widget.sala["idSala"] ?? widget.sala["id"];
    if (raw == null) return null;
    if (raw is int) return raw;
    try {
      return int.parse(raw.toString());
    } catch (_) {
      return null;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _segundos = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _segundos++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatarTempo(int totalSegundos) {
    final m = (totalSegundos ~/ 60).toString().padLeft(2, '0');
    final s = (totalSegundos % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final sala = widget.sala;

    final nome = sala["nomeSala"] ?? "Sala sem nome";
    final tema = sala["tema"] ?? "Geral";
    final descricao = sala["descricao"] ?? "Sem descrição";
    final dataCriacao =
        (sala["dataCriacao"] ?? "").toString().split("T").first;

    final participantes = (sala["participantes"] is List)
        ? List<dynamic>.from(sala["participantes"])
        : ["Alice", "Bruno", "Carlos"];

    return Scaffold(
      appBar: AppBar(title: Text(nome)),
      body: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animController,
          curve: Curves.easeOut,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut),
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _headerInfo(nome, tema, dataCriacao),
              const SizedBox(height: 25),
              _descricaoCard(descricao),
              const SizedBox(height: 30),

              if (_sessaoAtivaId != null) _cronometroCard(),
              if (_sessaoAtivaId != null) const SizedBox(height: 30),

              _tituloSessao("Participantes"),
              const SizedBox(height: 10),
              ..._listaParticipantes(participantes),

              const SizedBox(height: 40),
              _botaoSessao(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cronometroCard() {
    return AnimatedScale(
      scale: _sessaoAtivaId != null ? 1 : 0.8,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E8FF), // roxo claro (ou troque para seu theme)
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            const Text(
              "Sessão em andamento",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B21A8),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _formatarTempo(_segundos),
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerInfo(String nome, String tema, String dataCriacao) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(tema,
              style: const TextStyle(
                  fontSize: 15, color: Color(0xFF6B21A8), fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Criada em: $dataCriacao",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _descricaoCard(String descricao) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B21A8).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(descricao, style: const TextStyle(fontSize: 16, height: 1.4)),
    );
  }

  Widget _tituloSessao(String titulo) {
    return Text(titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700));
  }

  List<Widget> _listaParticipantes(List participantes) {
    return List.generate(participantes.length, (index) {
      final nome = participantes[index].toString();

      final animation = CurvedAnimation(
        parent: _animController,
        curve: Interval(0.3 + index * 0.15, 1.0, curve: Curves.easeOut),
      );

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(animation),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B21A8).withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFF3E8FF),
                  child: Text(
                    nome.isNotEmpty ? nome.substring(0, 1).toUpperCase() : "?",
                    style: const TextStyle(
                        color: Color(0xFF6B21A8), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Text(nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _botaoSessao() {
    final bool temSessao = _sessaoAtivaId != null;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: temSessao ? const Color(0xFFB00020) : const Color(0xFF6B21A8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: _loading ? null : () async {
        final idSala = _getSalaId();
        if (idSala == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro: id da sala inválido.")),
          );
          return;
        }

        setState(() => _loading = true);

        final objetivo = widget.sala["objetivo"] ?? "Sessão de foco";

        if (!temSessao) {
          // INICIAR SESSÃO (iniciarSessaoFoco exige named params idSala, objetivo)
          final idSessao = await ApiService.iniciarSessaoFoco(
            idSala: idSala,
            objetivo: objetivo,
          );

          if (idSessao != null) {
            setState(() => _sessaoAtivaId = idSessao);
            _startTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sessão iniciada!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Falha ao iniciar sessão.")),
            );
          }
        } else {
          // ENCERRAR SESSÃO (ApiService.encerrarSessaoFoco espera posicional int)
          try {
            final sucesso = await ApiService.encerrarSessaoFoco(_sessaoAtivaId!);

            if (sucesso) {
              _stopTimer();
              final tempo = _formatarTempo(_segundos);
              setState(() {
                _sessaoAtivaId = null;
                _segundos = 0;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Sessão encerrada! Tempo total: $tempo")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Falha ao encerrar sessão.")),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erro ao encerrar sessão: $e")),
            );
          }
        }

        setState(() => _loading = false);
      },
      child: _loading
          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(temSessao ? "Encerrar sessão" : "Iniciar sessão",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }
}
