import 'package:flutter/material.dart';
import 'package:alugajunto/pages/login_page.dart'; // Certifique-se de que o arquivo está em lib/login_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Página de login como tela inicial
    );
  }
}
