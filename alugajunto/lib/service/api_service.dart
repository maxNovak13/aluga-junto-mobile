import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/usuario.dart';
import '../model/vaga.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/aluga-junto';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Método privado para pegar headers com token
  static Future<Map<String, String>> _getHeaders({bool isJson = true}) async {
    final token = await _storage.read(key: 'jwt_token');
    final headers = <String, String>{};
    if (isJson) headers['Content-Type'] = 'application/json';
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  static Future<List<Vaga>> listarVagas() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/vaga/listar'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Vaga.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar vagas: ${response.statusCode}');
    }
  }

  static Future<List<Vaga>> listarVagasDoUsuario(String uuid) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/usuario/$uuid/listar-vagas'),
      headers: headers,
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

    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['titulo'] = titulo;
    request.fields['descricao'] = descricao;
    request.fields['area'] = area.toString();
    request.fields['dormitorio'] = dormitorio.toString();
    request.fields['banheiro'] = banheiro.toString();
    request.fields['garagem'] = garagem.toString();
    request.fields['perfil'] = jsonEncode(perfil);
    request.fields['endereco'] = jsonEncode(endereco);

    if (imagem != null) {
      var stream = http.ByteStream(imagem.openRead().cast());
      var length = await imagem.length();
      var multipartFile = http.MultipartFile(
        'imagem',
        stream,
        length,
        filename: imagem.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final json = jsonDecode(responseBody);
      return json['id']; // espera que o backend retorne o id
    } else {
      print('Erro ao cadastrar vaga: $responseBody');
      return null;
    }
  }

  static Future<bool> associarUsuarioComVaga(String uuid, int vagaId) async {
    final headers = await _getHeaders(isJson: false);
    final response = await http.post(
      Uri.parse('$baseUrl/usuario/$uuid/criarrelacao/$vagaId'),
      headers: headers,
    );

    return response.statusCode == 204;
  }

  static Future<bool> excluirVaga(int id) async {
    final headers = await _getHeaders(isJson: false);
    final response = await http.delete(
      Uri.parse('$baseUrl/vaga/$id'),
      headers: headers,
    );

    return response.statusCode == 204;
  }

  static Future<List<Usuario>> listarInteressados(String vagaUuid) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/usuario/$vagaUuid/listar-interessados');

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao listar interessados: ${response.statusCode}');
    }
  }

  static Future<List<Vaga>> buscarVagasComFiltro(Map<String, dynamic> filtro) async {
    final headers = await _getHeaders();
    final jsonBody = jsonEncode(filtro);
    print('JSON enviado no ApiService: $jsonBody');

    final response = await http.post(
      Uri.parse('$baseUrl/vaga/buscar-filtro'),
      headers: headers,
      body: jsonBody,
    );

    print('Status da resposta: ${response.statusCode}');
    print('Body da resposta: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Vaga.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar vagas com filtro: ${response.statusCode}');
    }
  }

  static Future<bool> verificarInteresse(int idVaga, String uuidUsuario) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/usuario/$idVaga/interesse/$uuidUsuario'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body == 'true';
    } else {
      throw Exception('Erro ao verificar interesse: ${response.statusCode}');
    }
  }
}
