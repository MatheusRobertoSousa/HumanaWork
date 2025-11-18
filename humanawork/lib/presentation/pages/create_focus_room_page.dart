import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../data/services/api_service.dart';

class CreateFocusRoomPage extends StatefulWidget {
  const CreateFocusRoomPage({super.key});

  @override
  State<CreateFocusRoomPage> createState() => _CreateFocusRoomPageState();
}

class _CreateFocusRoomPageState extends State<CreateFocusRoomPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _temaController = TextEditingController();

  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _nomeController.dispose();
    _descricaoController.dispose();
    _temaController.dispose();
    super.dispose();
  }

  Future<void> _criarSala() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final nome = _nomeController.text.trim();
    final descricao = _descricaoController.text.trim();
    final tema = _temaController.text.trim();

    final novaSala = await ApiService.criarSala(
      nomeSala: nome,
      descricao: descricao,
      tema: tema,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (novaSala != null) {
      Navigator.pop(context, novaSala);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao criar sala. Tente novamente.'),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Nova Sala de Foco'),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Card estilizado envolvendo os inputs
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nomeController,
                          decoration: _inputDecoration('Nome da Sala'),
                          validator: (value) =>
                              value!.isEmpty ? 'Digite um nome.' : null,
                        ),
                        const SizedBox(height: 18),

                        TextFormField(
                          controller: _descricaoController,
                          maxLines: 3,
                          decoration: _inputDecoration('Descrição (opcional)'),
                        ),
                        const SizedBox(height: 18),

                        TextFormField(
                          controller: _temaController,
                          decoration: _inputDecoration('Tema da sala'),
                          validator: (value) =>
                              value!.isEmpty ? 'Digite um tema.' : null,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botão Criar Sala
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _criarSala,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Criar Sala"),
                    ),
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
