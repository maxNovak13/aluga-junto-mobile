import 'package:flutter/material.dart';
import 'package:alugajunto/model/vaga.dart';
import 'package:alugajunto/model/usuario.dart';
import 'package:alugajunto/service/api_service.dart';

class VagaDetalhadaCard extends StatefulWidget {
  final Vaga vaga;
  final void Function()? onEditar;
  final void Function()? onRemover;
  final bool mostrarInteressados;

  const VagaDetalhadaCard({
    super.key,
    required this.vaga,
    this.onEditar,
    this.onRemover,
    this.mostrarInteressados = false,
  });

  @override
  State<VagaDetalhadaCard> createState() => _VagaDetalhadaCardState();
}

class _VagaDetalhadaCardState extends State<VagaDetalhadaCard> {
  List<Usuario> interessados = [];
  bool carregandoInteressados = false;

  @override
  void initState() {
    super.initState();
    if (widget.mostrarInteressados && widget.vaga.uuid != null) {
      carregarInteressados();
    }
  }

  Future<void> carregarInteressados() async {
    setState(() => carregandoInteressados = true);
    try {
      final resultado = await ApiService.listarInteressados(widget.vaga.uuid!);
      setState(() {
        interessados = resultado;
      });
    } catch (e) {
      print("Erro ao carregar interessados: $e");
    } finally {
      setState(() => carregandoInteressados = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.vaga.titulo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Imagem
          if (widget.vaga.imagem != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.network(
                  widget.vaga.imagem!,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Ícones principais
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconInfo(Icons.bed, '${widget.vaga.dormitorio}'),
                _buildIconInfo(Icons.bathtub, '${widget.vaga.banheiro}'),
                _buildIconInfo(Icons.directions_car, '${widget.vaga.garagem}'),
                _buildIconInfo(Icons.square_foot, '${widget.vaga.area} m²'),
              ],
            ),
          ),

          _buildSectionTitle('Descrição'),
          _buildSectionText(widget.vaga.descricao),

          _buildSectionTitle('Endereço'),
          _buildSectionText(
            '${widget.vaga.endereco.rua} - ${widget.vaga.endereco.bairro}\n'
                '${widget.vaga.endereco.cidade} - ${widget.vaga.endereco.estado}, ${widget.vaga.endereco.cep}',
          ),

          _buildSectionTitle('Perfil'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIconInfo(Icons.smoking_rooms, widget.vaga.perfil.fumante ? 'Fumante' : 'Não fumante'),
                    const SizedBox(width: 16),
                    _buildIconInfo(Icons.pets, widget.vaga.perfil.pet ? 'Aceita pet' : 'Sem pet'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildIconInfo(Icons.person, widget.vaga.perfil.genero),
                    const SizedBox(width: 16),
                    _buildIconInfo(Icons.cake, '${widget.vaga.perfil.idade} anos'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info, size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.vaga.perfil.texto,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Seção: Interessados
          if (widget.mostrarInteressados) ...[
            _buildSectionTitle('Interessados'),
            if (carregandoInteressados)
              const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              )
            else if (interessados.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Nenhum interessado ainda.'),
              )
            else
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: interessados.map((usuario) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('${usuario.nome} - ${usuario.telefone}'),
                    );
                  }).toList(),
                ),
              ),
          ],

          const SizedBox(height: 12),

          // Botões de ação (editar/remover)
          if (widget.onEditar != null || widget.onRemover != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.onEditar != null)
                    TextButton.icon(
                      onPressed: widget.onEditar,
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      label: const Text('Editar', style: TextStyle(color: Colors.blue)),
                    ),
                  if (widget.onRemover != null)
                    TextButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirmar exclusão'),
                            content: const Text('Tem certeza que deseja excluir esta vaga?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          final sucesso = await ApiService.excluirVaga(widget.vaga.id);
                          if (sucesso) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Vaga excluída com sucesso')),
                            );
                            widget.onRemover!(); // Atualiza lista
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao excluir a vaga')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Retirar oferta', style: TextStyle(color: Colors.red)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(text),
    );
  }

  Widget _buildIconInfo(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
