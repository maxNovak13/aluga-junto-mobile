import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/menu_page.dart';

class BottomMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final String uuidUsuario;
  final String tipoUsuario;

  const BottomMenu({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.uuidUsuario,
    required this.tipoUsuario,
  });

  void _handleTap(BuildContext context, int index) {
    onTap(index);

    // Navegação adaptada conforme índice real
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(uuidUsuario: uuidUsuario, tipoUsuario: tipoUsuario),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SearchPage(uuidUsuario: uuidUsuario, tipoUsuario: tipoUsuario),
        ),
      );
    } else if (index == 2 && tipoUsuario.toUpperCase() == 'ADMIN') {//só aparece para user admin = ofertar vagas
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MenuPage(uuidUsuario: uuidUsuario, tipoUsuario: tipoUsuario),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = tipoUsuario.toUpperCase() == 'ADMIN';

    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
      const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
    ];

    if (isAdmin) {
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'));
    }

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _handleTap(context, index),
      items: items,
    );
  }
}
