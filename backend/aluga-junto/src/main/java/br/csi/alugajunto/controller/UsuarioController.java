package br.csi.alugajunto.controller;

import br.csi.alugajunto.model.usuario.DadosUsuario;
import br.csi.alugajunto.model.usuario.Usuario;
import br.csi.alugajunto.model.vaga.Vaga;
import br.csi.alugajunto.service.UsuarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/usuario")
@Tag(name = "Usuários", description = "Path relacionado a operações de usuários")
public class UsuarioController {
    private final UsuarioService service;

    public UsuarioController(UsuarioService service) {
        this.service = service;
    }

    ///http://localhost:8080/aluga-junto/usuario/listar  --> vai ser excluido
    @Operation(summary = "Listar todos os usuários")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Lista de usuários obtida com sucesso")
    })
    @GetMapping("/listar")
    public List<DadosUsuario> findAll() {
        return this.service.findAllUsuarios();
    }

    ///http://localhost:8080/aluga-junto/usuario/{id} --> vai ser excluido
    @GetMapping("/{id}")
    @Operation(summary = "Buscar usuário por ID", description = "Retorna um usuário correspondente ao ID fornecido")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Usuário encontrado",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Usuario.class))),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado", content = @Content)
    })
    public DadosUsuario findById(@Parameter(description = "ID do usuário a ser buscado") @PathVariable Long id) {
        return this.service.findUsuario(id);
    }

    ///http://localhost:8080/aluga-junto/usuario
    @PostMapping()
    @Transactional
    @Operation(summary = "Criar um novo usuário", description = "Cria um novo usuário e o adiciona à lista")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Usuário criado com sucesso",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Usuario.class))),
            @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos", content = @Content)
    })
    public ResponseEntity criar(@RequestBody @Valid Usuario usuario, UriComponentsBuilder uriBuilder) {
        this.service.cadastrar(usuario);
        URI uri = uriBuilder.path("/uuid/{uuid}").buildAndExpand(usuario.getUuid()).toUri();
        return ResponseEntity.created(uri).body(usuario);
    }

    @Operation(summary = "Atualizar informações do usuário")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Usuário atualizado com sucesso",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = Usuario.class))}),
            @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos",
                    content = @Content)
    })
    @PutMapping
    public ResponseEntity atualizar(@RequestBody Usuario usuario) {
        this.service.atualizar(usuario);
        return ResponseEntity.ok(usuario);
    }

    ///http://localhost:8080/aluga-junto/usuario/{id}
    @Operation(summary = "Deletar usuário por ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Usuário deletado com sucesso"),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity deletar(@PathVariable Long id) {
        this.service.excluirUsuario(id);
        return ResponseEntity.noContent().build();
    }

    ///http://localhost:8080/aluga-junto/usuario/uuid/{uuid}
    @Operation(summary = "Obter usuário por UUID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Usuário encontrado",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = Usuario.class))}),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    })
    @GetMapping("/uuid/{uuid}")
    public Usuario usuarioUuid(@PathVariable String uuid) {
        return this.service.getUsuarioUUID(uuid);
    }

    ///http://localhost:8080/aluga-junto/usuario/uuid
    @Operation(summary = "Atualizar usuário por UUID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Usuário atualizado com sucesso"),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    })
    @PutMapping("/uuid")
    public void atualizarUUID(@RequestBody Usuario usuario) {
        this.service.atualizarUUID(usuario);
    }

    ///http://localhost:8080/aluga-junto/usuario/{uuid}/criarrelacao/{id}
    @Operation(summary = "Associar usuário a uma vaga")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Associação criada com sucesso"),
            @ApiResponse(responseCode = "404", description = "Usuário ou vaga não encontrados")
    })
    @Transactional
    @PostMapping("/{uuid}/criarrelacao/{id}")
    public ResponseEntity criarRelacao(@PathVariable String uuid, @PathVariable Long id) {
        this.service.associarUsuarioComVaga(uuid, id);
        return ResponseEntity.noContent().build();
    }


    ///http://localhost:8080/aluga-junto/usuario/{uuid}/listar-vagas
    @Operation(summary = "Listar vagas associadas a um usuário")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Vagas listadas com sucesso",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = Vaga.class))}),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    })
    @GetMapping("/{uuid}/listar-vagas")
    public List<Vaga> vagasDoUsuarioParte(@PathVariable String uuid) {
        return this.service.listarVagasPorUsuarioUuid(uuid);
    }


//    ///http://localhost:8080/aluga-junto/usuario/{uuid}/listar-usuarios
//    @Operation(summary = "Listar usuários interessados em uma vaga")
//    @ApiResponses(value = {
//            @ApiResponse(responseCode = "200", description = "Usuários listados com sucesso",
//                    content = {@Content(mediaType = "application/json",
//                            schema = @Schema(implementation = Vaga.class))}),
//            @ApiResponse(responseCode = "404", description = "Vaga não encontrada")
//    })
//    @GetMapping("/{uuid}/listar-interessados")
//    public List<Usuario> interessadosEmUmaVaga(@PathVariable String uuid) {
//        return this.service.listarUsuariosPorVagasUuid(uuid);
//    }

    ///http://localhost:8080/aluga-junto/usuario/{uuid}/exclui-relacao/{id}
    @Operation(summary = "Deletar a relação de um  usuário e vaga por UUID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Relação deletada com sucesso"),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado")
    })
    @Transactional
    @DeleteMapping("/{uuid}/exclui-relacao/{id}")
    public ResponseEntity excluirRelacao(@PathVariable String uuid, @PathVariable Long id) {
        this.service.dessassociarUsuarioComVaga(uuid, id);
        return ResponseEntity.noContent().build();
    }



}
