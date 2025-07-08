import 'package:flutter/material.dart';
import 'package:alugajunto/model/vaga.dart';
import 'package:alugajunto/service/api_service.dart';
import 'package:alugajunto/widgets/vaga_card.dart';
import 'package:alugajunto/widgets/bottom_menu.dart';

import 'detalhes_vaga_page.dart';
import 'login_page.dart';

class SearchPage extends StatefulWidget {
  final String uuidUsuario;
  final String tipoUsuario;

  const SearchPage({
    super.key,
    required this.uuidUsuario,
    required this.tipoUsuario,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();

  // Filtros
  String? _genero;
  bool? _pet;
  bool? _fumante;
  String? _cidade;
  String? _estado;
  String? _bairro;

  List<Vaga> _resultados = [];

  int _selectedIndex = 1;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _buscarVagas() async {
    final filtro = {
      'genero': _genero,
      'pet': _pet,
      'fumante': _fumante,
      'cidade': _cidade,
      'estado': _estado,
      'bairro': _bairro,
    };

    try {
      final vagas = await ApiService.buscarVagasComFiltro(filtro);
      setState(() {
        _resultados = vagas;
      });
    } catch (e) {
      print('Erro ao buscar vagas: $e');
    }
  }

  Widget _buildDropdownBool(String label, bool? value, ValueChanged<bool?> onChanged) {
    return DropdownButtonFormField<bool>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: const [
        DropdownMenuItem(value: true, child: Text('Sim')),
        DropdownMenuItem(value: false, child: Text('Não')),
      ],
      onChanged: onChanged,
      isExpanded: true,
    );
  }


  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Buscar Vagas',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _confirmarLogout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gênero'),
                value: _genero,
                items: const [
                  DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
                  DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'Tanto faz', child: Text('Tanto faz')),
                ],
                onChanged: (value) => setState(() => _genero = value),
              ),
              _buildDropdownBool('Aceita pet?', _pet, (value) => setState(() => _pet = value)),
              _buildDropdownBool('Aceita fumante?', _fumante, (value) => setState(() => _fumante = value)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cidade'),
                onChanged: (value) => _cidade = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Estado'),
                onChanged: (value) => _estado = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Bairro'),
                onChanged: (value) => _bairro = value,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _buscarVagas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // fundo azul
                  foregroundColor: Colors.white, // texto branco
                ),
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 16),
              if (_resultados.isEmpty)
                const Center(child: Text('Nenhuma vaga encontrada.'))
              else
                ..._resultados.map((vaga) => VagaCard(
                  vaga: vaga,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesVagaPage(
                          vaga: vaga,
                          uuidUsuario: widget.uuidUsuario,
                          tipoUsuario: widget.tipoUsuario,
                        ),
                      ),
                    );
                  },
                )).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
        uuidUsuario: widget.uuidUsuario,
        tipoUsuario: widget.tipoUsuario,
      ),
    );
  }
}