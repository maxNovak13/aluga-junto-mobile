import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alugajunto/service/api_service.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:alugajunto/widgets/image_picker_widget.dart';

File? _imagemSelecionada;
final ImagePicker _picker = ImagePicker();

class CadastroVagaPage extends StatefulWidget {
  final String uuidUsuario;

  const CadastroVagaPage({
    super.key,
    required this.uuidUsuario
  });

  @override
  State<CadastroVagaPage> createState() => _CadastroVagaPageState();
}

class _CadastroVagaPageState extends State<CadastroVagaPage> {
  final _formKey = GlobalKey<FormState>();

  // Endereço
  String? _uf;
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  // Perfil
  String? _genero;
  String? _idade;
  bool _aceitaFumante = false;
  bool _petFriendly = false;
  final TextEditingController _observacaoController = TextEditingController();

  // Geral
  final TextEditingController _imagemController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _dormitoriosController = TextEditingController();
  final TextEditingController _banheirosController = TextEditingController();
  final TextEditingController _garagensController = TextEditingController();

  void _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> perfil = {
        "genero": _genero ?? '',
        "idade": _idade ?? '',
        "fumante": _aceitaFumante,
        "pet": _petFriendly,
        "texto": _observacaoController.text,
      };

      Map<String, dynamic> endereco = {
        "estado": _uf ?? '',
        "cidade": _cidadeController.text,
        "rua": _ruaController.text,
        "bairro": _bairroController.text,
        "cep": _cepController.text,
      };

      File? imagem = _imagemSelecionada;

      int? vagaId = await ApiService.cadastrarVaga(
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        area: int.tryParse(_areaController.text) ?? 0,
        dormitorio: int.tryParse(_dormitoriosController.text) ?? 0,
        banheiro: int.tryParse(_banheirosController.text) ?? 0,
        garagem: int.tryParse(_garagensController.text) ?? 0,
        imagem: imagem,
        perfil: perfil,
        endereco: endereco,
      );

      if (vagaId != null) {
        bool associou = await ApiService.associarUsuarioComVaga(widget.uuidUsuario, vagaId);
        if (associou) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao associar usuário com vaga')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar vaga')),
        );
      }
    }
  }

  Future<void> _escolherImagemDaGaleria() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }


  void _cancelar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Cadastrar Vaga',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Endereço', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Endereço do lugar'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _uf,
                items: ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO']
                    .map((uf) => DropdownMenuItem(value: uf, child: Text(uf)))
                    .toList(),
                onChanged: (value) => setState(() => _uf = value),
                decoration: const InputDecoration(labelText: 'UF'),
              ),
              TextFormField(
                  controller: _cidadeController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                      labelText: 'Cidade'
                  )
              ),
              TextFormField(
                  controller: _ruaController,
                  maxLength: 80,
                  decoration: const InputDecoration(
                      labelText: 'Rua')
              ),
              TextFormField(
                  controller: _bairroController,
                  maxLength: 80,
                  decoration: const InputDecoration(
                      labelText: 'Bairro'
                  )
              ),
              TextFormField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                inputFormatters: [MaskedInputFormatter('#####-###')],
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length != 9) {
                    return 'CEP inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              const Text('Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Perfil de morador desejado'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _genero,
                items: ['Masculino', 'Feminino', 'Tanto Faz']
                    .map((gen) => DropdownMenuItem(value: gen, child: Text(gen)))
                    .toList(),
                onChanged: (value) => setState(() => _genero = value),
                decoration: const InputDecoration(labelText: 'Gênero'),
              ),
              DropdownButtonFormField<String>(
                value: _idade,
                items: ['18-25', '26-35', '36-50', '50+']
                    .map((age) => DropdownMenuItem(value: age, child: Text(age)))
                    .toList(),
                onChanged: (value) => setState(() => _idade = value),
                decoration: const InputDecoration(labelText: 'Faixa Etária'),
              ),
              SwitchListTile(
                title: const Text(
                    'Aceita fumante',
                    style: TextStyle(color: Colors.black)
                ),
                value: _aceitaFumante,
                onChanged: (value) => setState(() => _aceitaFumante = value),
                selected: _aceitaFumante, // Controla se está ativado
                activeColor: Colors.white, // Cor da "bolinha" do switch
                activeTrackColor: Colors.lightBlue, // Cor da "trilha" do switch
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),

              SwitchListTile(
                title: const Text(
                    'Pet Friendly',
                    style: TextStyle(color: Colors.black)
                ),
                value: _petFriendly,
                onChanged: (value) => setState(() => _petFriendly = value),
                selected: _petFriendly, // indica se está ativado
                activeColor: Colors.white, // cor da "bolinha" do switch
                activeTrackColor: Colors.lightBlue, // cor do fundo da "trilha" do switch
                contentPadding: const EdgeInsets.symmetric(horizontal: 16), // padding opcional
              ),
              TextFormField(
                controller: _observacaoController,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Observação',
                  hintText: 'vaga para pessoa organizada e independente',
                ),
              ),
              const SizedBox(height: 24),

              const Text('Geral', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Imagem do lugar', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  ImagePickerWidget(
                    onImageSelected: (image) {
                      setState(() {
                        _imagemSelecionada = image;
                      });
                    },
                  ),
                ],
              ),
              TextFormField(
                  controller: _tituloController,
                  maxLength: 80,
                  decoration: const InputDecoration(
                      labelText: 'Título'
                  )
              ),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'ex.: Apto bem localizado próximo ao comércio',
                ),
              ),

              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Área (m²)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              TextFormField(
                controller: _dormitoriosController,
                decoration: const InputDecoration(labelText: 'Número de dormitórios'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextFormField(
                controller: _banheirosController,
                decoration: const InputDecoration(labelText: 'Número de banheiros'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextFormField(
                controller: _garagensController,
                decoration: const InputDecoration(labelText: 'Vagas de garagem'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: _cancelar,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Cancelar')),
                  ElevatedButton(
                    onPressed: _cadastrar,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cadastrar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
