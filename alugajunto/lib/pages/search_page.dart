import 'package:flutter/material.dart';
import 'package:alugajunto/widgets/bottom_menu.dart';
import 'package:alugajunto/widgets/custom_app_bar.dart';

class SearchPage extends StatefulWidget {
  final String uuidUsuario;
  final String tipoUsuario;

  const SearchPage({
    super.key,
    required this.uuidUsuario,
    required this.tipoUsuario
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  int _selectedIndex = 1;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _performSearch(String query) {
    // Implementar lógica de busca futuramente
    setState(() {
      _searchResults = ['Resultado 1 para $query', 'Resultado 2 para $query'];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearchChanged: (text) {
          // Implementar a lógica de busca ou filtrar a lista
          print('Busca digitada: $text');
        },
        onProfileTap: () {},
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchResults[index]),
          );
        },
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