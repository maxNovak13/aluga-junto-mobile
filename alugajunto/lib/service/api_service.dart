import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../model/vaga.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/aluga-junto';

  static Future<http.Response> cadastrarUsuario(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuario'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dados),
    );
    return response;
  }

  static Future<List<Vaga>> listarVagas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/vaga/listar'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Vaga.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar vagas: ${response.statusCode}');
    }
  }

  static Future<List<Vaga>> listarVagasDoUsuario(String uuid) async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuario/$uuid/listar-vagas'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Vaga.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar vagas do usuário: ${response.statusCode}');
    }
  }

  static Future<int?> cadastrarVaga({
    required String titulo,
    required String descricao,
    required int area,
    required int dormitorio,
    required int banheiro,
    required int garagem,
    File? imagem,
    required Map<String, dynamic> perfil,
    required Map<String, dynamic> endereco,
  }) async {
    var uri = Uri.parse('$baseUrl/vaga');
    var request = http.MultipartRequest('POST', uri);

    request.fields['titulo'] = titulo;
    request.fields['descricao'] = descricao;
    request.fields['area'] = area.toString();
    request.fields['dormitorio'] = dormitorio.toString();
    request.fields['banheiro'] = banheiro.toString();
    request.fields['garagem'] = garagem.toString();
    request.fields['perfil'] = jsonEncode(perfil);
    request.fields['endereco'] = jsonEncode(endereco);

    if (imagem != null) {
      var stream = http.ByteStream(imagem.openRead());
      var length = await imagem.length();
      var multipartFile = http.MultipartFile('imagem', stream, length, filename: imagem.path.split('/').last);
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final json = jsonDecode(responseBody);
      return json['id']; // <<-- precisa que o backend retorne o ID da vaga
    } else {
      print('Erro ao cadastrar vaga: $responseBody');
      return null;
    }
  }

  static Future<bool> associarUsuarioComVaga(String uuid, int vagaId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuario/$uuid/criarrelacao/$vagaId'),
    );

    return response.statusCode == 204;
  }

  static Future<bool> excluirVaga(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/vaga/$id'),
    );

    return response.statusCode == 204;
  }

}
