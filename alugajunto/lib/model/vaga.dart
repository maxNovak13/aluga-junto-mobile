

class Vaga {
  final int id;
  final String uuid;
  final String titulo;
  final String descricao;
  final int area;
  final int dormitorio;
  final int banheiro;
  final int garagem;
  final String? imagem;
  final Endereco endereco;
  final Perfil perfil;

  Vaga({
    required this.id,
    required this.uuid,
    required this.titulo,
    required this.descricao,
    required this.area,
    required this.dormitorio,
    required this.banheiro,
    required this.garagem,
    required this.imagem,
    required this.endereco,
    required this.perfil,
  });

  factory Vaga.fromJson(Map<String, dynamic> json) {
    return Vaga(
      id: json['id'],
      uuid: json['uuid'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      area: json['area'],
      dormitorio: json['dormitorio'],
      banheiro: json['banheiro'],
      garagem: json['garagem'],
      imagem: json['imagem'] != null
          ? 'http://10.0.2.2:8080/aluga-junto/${json['imagem'].replaceAll(r'\\', '/')}'
          : null,
      endereco: Endereco.fromJson(json['endereco']),
      perfil: Perfil.fromJson(json['perfil']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'titulo': titulo,
      'descricao': descricao,
      'area': area,
      'dormitorio': dormitorio,
      'banheiro': banheiro,
      'garagem': garagem,
      'imagem': imagem,
      'endereco': endereco.toJson(),
      'perfil': perfil.toJson(),
    };
  }
}

class Endereco {
  final String rua;
  final String bairro;
  final String cep;
  final String cidade;
  final String estado;

  Endereco({
    required this.rua,
    required this.bairro,
    required this.cep,
    required this.cidade,
    required this.estado,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      rua: json['rua'],
      bairro: json['bairro'],
      cep: json['cep'],
      cidade: json['cidade'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rua': rua,
      'bairro': bairro,
      'cep': cep,
      'cidade': cidade,
      'estado': estado,
    };
  }
}

class Perfil {
  final String genero;
  final String idade;
  final bool pet;
  final bool fumante;
  final String texto;

  Perfil({
    required this.genero,
    required this.idade,
    required this.pet,
    required this.fumante,
    required this.texto,
  });

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      genero: json['genero'],
      idade: json['idade'],
      pet: json['pet'],
      fumante: json['fumante'],
      texto: json['texto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genero': genero,
      'idade': idade,
      'pet': pet,
      'fumante': fumante,
      'texto': texto,
    };
  }
}


// import 'endereco.dart';
// import 'perfil.dart';
// import 'usuario.dart';
//
// class Vaga {
//   final int? id;
//   final String? uuid;
//   final String titulo;
//   final String descricao;
//   final int area;
//   final int dormitorio;
//   final int banheiro;
//   final int garagem;
//   final String? imagem;
//   final Endereco endereco;
//   final Perfil perfil;
//   final List<Usuario>? usuarios;
//
//   Vaga({
//     this.id,
//     this.uuid,
//     required this.titulo,
//     required this.descricao,
//     required this.area,
//     required this.dormitorio,
//     required this.banheiro,
//     required this.garagem,
//     this.imagem,
//     required this.endereco,
//     required this.perfil,
//     this.usuarios,
//   });
//
//   factory Vaga.fromJson(Map<String, dynamic> json) {
//     return Vaga(
//       id: json['id'],
//       uuid: json['uuid'],
//       titulo: json['titulo'],
//       descricao: json['descricao'],
//       area: json['area'],
//       dormitorio: json['dormitorio'],
//       banheiro: json['banheiro'],
//       garagem: json['garagem'],
//       imagem: json['imagem'],
//       endereco: Endereco.fromJson(json['endereco']),
//       perfil: Perfil.fromJson(json['perfil']),
//       usuarios: json['usuarios'] != null
//           ? List<Usuario>.from(json['usuarios'].map((u) => Usuario.fromJson(u)))
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       if (id != null) 'id': id,
//       if (uuid != null) 'uuid': uuid,
//       'titulo': titulo,
//       'descricao': descricao,
//       'area': area,
//       'dormitorio': dormitorio,
//       'banheiro': banheiro,
//       'garagem': garagem,
//       if (imagem != null) 'imagem': imagem,
//       'endereco': endereco.toJson(),
//       'perfil': perfil.toJson(),
//       if (usuarios != null) 'usuarios': usuarios!.map((u) => u.toJson()).toList(),
//     };
//   }
// }