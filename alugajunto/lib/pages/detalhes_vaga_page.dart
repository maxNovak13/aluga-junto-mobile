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
  bool _jaMostrouInteresse = false;

  @override
  void initState() {
    super.initState();
    _verificarInteresse();
  }

  Future<void> _verificarInteresse() async {
    try {
      final jaTemInteresse = await ApiService.verificarInteresse(
        widget.vaga.id,
        widget.uuidUsuario,
      );
      setState(() {
        _jaMostrouInteresse = jaTemInteresse;
      });
    } catch (e) {
      print("Erro ao verificar interesse: $e");
    }
  }

  Future<void> _mostrarInteresse() async {
    setState(() => _isLoading = true);

    final sucesso = await ApiService.associarUsuarioComVaga(
      widget.uuidUsuario,
      widget.vaga.id,
    );

    setState(() {
      _isLoading = false;
      if (sucesso) _jaMostrouInteresse = true;
    });

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
        child: VagaDetalhadaCard(vaga: widget.vaga, mostrarInteressados: false),
      ),
      bottomNavigationBar: widget.tipoUsuario.toUpperCase() != 'ADMIN'
          ? Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            _jaMostrouInteresse ? Colors.indigo[900] : Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed:
          _isLoading || _jaMostrouInteresse ? null : _mostrarInteresse,
          icon: _isLoading
              ? const CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 2,
          )
              : const Icon(Icons.favorite, color: Colors.white),
          label: Text(
            _isLoading
                ? 'Enviando...'
                : _jaMostrouInteresse
                ? 'Você já demonstrou interesse'
                : 'Mostrar Interesse',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      )
          : null,
    );
  }
}
