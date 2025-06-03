import 'vaga.dart';

class Usuario {
  final int? id;
  final String? uuid;
  final String nome;
  final String email;
  final String telefone;
  final String senha;
  final String tipo;
  final List<Vaga>? vagas;

  Usuario({
    this.id,
    this.uuid,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
    required this.tipo,
    this.vagas,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      uuid: json['uuid'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      senha: json['senha'],
      tipo: json['tipo'],
      vagas: json['vagas'] != null
          ? List<Vaga>.from(json['vagas'].map((v) => Vaga.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'senha': senha,
      'tipo': tipo,
      if (vagas != null) 'vagas': vagas!.map((v) => v.toJson()).toList(),
    };
  }
}