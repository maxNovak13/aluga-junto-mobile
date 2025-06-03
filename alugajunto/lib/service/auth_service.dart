import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8080/aluga-junto/login'; // ajuste se necessário

  Future<Map<String, dynamic>?> login(String email, String senha) async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Aqui retorna os dados do usuário, incluindo o UUID
      } else {
        return null;
      }
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }
}