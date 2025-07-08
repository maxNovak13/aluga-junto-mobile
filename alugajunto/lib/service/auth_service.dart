import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8080/aluga-junto';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<http.Response> cadastrarUsuario(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuario'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dados),
    );
    return response;
  }

  // Faz login, recebe o token JWT e guarda no storage
  Future<http.Response?> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token'];
        if (token != null) {
          await _storage.write(key: 'jwt_token', value: token);
          await _storage.write(key: 'uuid', value: json['uuid']);
          await _storage.write(key: 'tipo', value: json['tipo']);
        }
      }
      return response;
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  // Métodos para recuperar dados do storage
  Future<String?> getTipoUsuario() async {
    return await _storage.read(key: 'tipo');
  }

  Future<String?> getUuidUsuario() async {
    return await _storage.read(key: 'uuid');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}