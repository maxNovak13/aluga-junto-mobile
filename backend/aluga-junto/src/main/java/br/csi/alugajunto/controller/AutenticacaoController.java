package br.csi.alugajunto.controller;


import br.csi.alugajunto.model.usuario.UsuarioRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import br.csi.alugajunto.infra.security.TokenServiceJWT;

import java.util.UUID;

@RestController
@RequestMapping("/login")
public class AutenticacaoController {

    //versao sem uso de token
    private final AuthenticationManager manager;
    private final UsuarioRepository usuarioRepository;

    public AutenticacaoController(AuthenticationManager manager, UsuarioRepository usuarioRepository) {
        this.manager = manager;
        this.usuarioRepository = usuarioRepository;
    }

    @PostMapping
    public ResponseEntity<?> efetuarLogin(@RequestBody @Valid DadosAutenticacao dados) {
        try {
            UsernamePasswordAuthenticationToken authToken =
                    new UsernamePasswordAuthenticationToken(dados.email(), dados.senha());

            Authentication autenticado = manager.authenticate(authToken);

            // busca o usuário no banco de dados
            var u = usuarioRepository.findByEmail(dados.email());
            return ResponseEntity.ok().body(new DadosUsuarioLogado(u.getUuid(), u.getTipo()));

        } catch (Exception e) {
            return ResponseEntity.status(401).body("Email ou senha inválidos.");
        }
    }

    private record DadosUsuarioLogado(UUID uuid, String tipo) {}

    private record DadosAutenticacao(String email, String senha) {}



//     private final AuthenticationManager manager;  /// versao que usa usa token
//
//     private final TokenServiceJWT tokenServiceJWT;
//
//     public AutenticacaoController(AuthenticationManager manager, TokenServiceJWT tokenServiceJWT) {
//         this.manager = manager;
//         this.tokenServiceJWT = tokenServiceJWT;
//     }
//
//     @PostMapping
//    public ResponseEntity efetuarLogin(@RequestBody @Valid DadosAutenticacao dados) {
//         try {
//             Authentication autenticado = new UsernamePasswordAuthenticationToken(dados.email(), dados.senha());
//            Authentication at = manager.authenticate(autenticado);
//
//            User user = (User) at.getPrincipal();
//            String token = this.tokenServiceJWT.gerarToken(user);
//
//            return ResponseEntity.ok().body(new DadosTokenJWT(token));
//         } catch (Exception e){
//             e.printStackTrace();
//             return ResponseEntity.badRequest().body(e.getMessage());
//         }
//     }
//
//
//     private record  DadosTokenJWT(String token) {}
//
//    private record DadosAutenticacao(String email, String senha) { }
}
