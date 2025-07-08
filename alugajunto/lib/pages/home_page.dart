import 'package:flutter/material.dart';
import 'package:alugajunto/widgets/bottom_menu.dart';
import 'package:alugajunto/widgets/custom_app_bar.dart';
import 'package:alugajunto/service/api_service.dart';
import 'package:alugajunto/model/vaga.dart';
import 'package:alugajunto/widgets/vaga_card.dart';
import 'package:alugajunto/pages/detalhes_vaga_page.dart';

class HomePage extends StatefulWidget {
  final String uuidUsuario;
  final String tipoUsuario; //

  const HomePage({
    super.key,
    required this.uuidUsuario,
    required this.tipoUsuario
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Vaga>> _futureVagas;

  @override
  void initState() {
    super.initState();

    if (widget.tipoUsuario == "user") {
      // Se for usuário comum, buscar vagas que ele demonstrou interesse
      _futureVagas = ApiService.listarVagasDoUsuario(widget.uuidUsuario);
    } else {
      // Se for outro tipo (ex: dono), listar todas
      _futureVagas = ApiService.listarVagas();
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onProfileTap: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Vaga>>(
          future: _futureVagas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child:
                  Text('Você ainda não demonstrou interesse em uma vaga.'));
            }

            final vagas = snapshot.data!;
            return ListView.builder(
              itemCount: vagas.length,
              itemBuilder: (context, index) {
                final vaga = vagas[index];
                return VagaCard(
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
                );
              },
            );
          },
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