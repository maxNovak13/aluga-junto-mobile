import 'package:flutter/material.dart';
import 'package:alugajunto/model/vaga.dart';
import 'package:alugajunto/service/api_service.dart';
import 'package:alugajunto/widgets/vaga_detalhada_card.dart';

class DetalhesVagaPage extends StatefulWidget {
  final Vaga vaga;
  final String uuidUsuario;
  final String tipoUsuario;


  const DetalhesVagaPage({
    super.key,
    required this.vaga,
    required this.uuidUsuario,
    required this.tipoUsuario
  });

  @override
  State<DetalhesVagaPage> createState() => _DetalhesVagaPageState();
}

class _DetalhesVagaPageState extends State<DetalhesVagaPage> {
  bool _isLoading = false;

  Future<void> _mostrarInteresse() async {
    setState(() => _isLoading = true);

    final sucesso = await ApiService.associarUsuarioComVaga(
      widget.uuidUsuario,
      widget.vaga.id,
    );

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso ? 'Interesse enviado com sucesso!' : 'Erro ao enviar interesse.',
        ),
        backgroundColor: sucesso ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Vaga', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: VagaDetalhadaCard(vaga: widget.vaga),
      ),
      bottomNavigationBar: widget.tipoUsuario.toUpperCase() != 'ADMIN'
          ? Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _isLoading ? null : _mostrarInteresse,
          icon: _isLoading
              ? const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          )
              : const Icon(Icons.favorite, color: Colors.white),
          label: Text(
            _isLoading ? 'Enviando...' : 'Mostrar Interesse',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      )
          : null
    );
  }
}
