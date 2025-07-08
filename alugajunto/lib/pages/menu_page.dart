import 'package:flutter/material.dart';

import 'package:alugajunto/model/vaga.dart';
import 'package:alugajunto/widgets/bottom_menu.dart';
import 'package:alugajunto/pages/cadastro_vaga_page.dart';
import 'package:alugajunto/service/api_service.dart';
import 'package:alugajunto/widgets/vaga_detalhada_card.dart';
import 'package:alugajunto/pages/detalhes_vaga_page.dart';

class MenuPage extends StatefulWidget {
  final String uuidUsuario;
  final String tipoUsuario;

  const MenuPage({
    super.key,
    required this.uuidUsuario,
    required this.tipoUsuario
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 2;

  List<Vaga> vagas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarVagas();
  }

  Future<void> carregarVagas() async {
    setState(() => carregando = true);
    try {
      final resultado = await ApiService.listarVagasDoUsuario(widget.uuidUsuario);
      setState(() {
        vagas = resultado;
      });
    } catch (e) {
      print("Erro ao buscar vagas: $e");
    } finally {
      setState(() => carregando = false);
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _excluirVaga(Vaga vaga) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta vaga?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirm != true) return;

    final sucesso = await ApiService.excluirVaga(vaga.id);
    if (sucesso) {
      setState(() {
        vagas.removeWhere((v) => v.id == vaga.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vaga excluída com sucesso')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir a vaga')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //tira seta de voltar
        title: const Text('Minhas Vagas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : vagas.isEmpty
          ? const Center(child: Text('Você ainda não cadastrou vagas.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vagas.length,
        itemBuilder: (context, index) {
          final vaga = vagas[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesVagaPage(vaga: vaga, uuidUsuario: widget.uuidUsuario, tipoUsuario: widget.tipoUsuario,),
                ),
              );
            },
            child: VagaDetalhadaCard(
              vaga: vaga,
              onRemover: () => _excluirVaga(vaga),
              mostrarInteressados: true,
              // onEditar: () = _editar,  //nao foi implemtado ainda
            ),
          );
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroVagaPage(uuidUsuario: widget.uuidUsuario)),
          );
          if (resultado == true) {
            await carregarVagas();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomMenu(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
        uuidUsuario: widget.uuidUsuario,
        tipoUsuario: widget.tipoUsuario
      ),
    );
  }
}
