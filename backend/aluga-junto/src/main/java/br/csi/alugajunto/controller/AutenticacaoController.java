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

@RestController
@RequestMapping("/login")
public class AutenticacaoController {

    private final AuthenticationManager manager;  /// versao que usa usa token
    private final TokenServiceJWT tokenServiceJWT;
    private final UsuarioRepository usuarioRepository;

    public AutenticacaoController(AuthenticationManager manager,
                                  TokenServiceJWT tokenServiceJWT,
                                  UsuarioRepository usuarioRepository) {
        this.manager = manager;
        this.tokenServiceJWT = tokenServiceJWT;
        this.usuarioRepository = usuarioRepository;
    }

     @PostMapping
    public ResponseEntity efetuarLogin(@RequestBody @Valid DadosAutenticacao dados) {
         try {
             Authentication autenticado = new UsernamePasswordAuthenticationToken(dados.email(), dados.senha());
             Authentication at = manager.authenticate(autenticado);

             User user = (User) at.getPrincipal();

             // Buscar usuário no banco para pegar uuid e tipo
             var usuario = usuarioRepository.findByEmail(user.getUsername());
             if (usuario==null) {
                 return ResponseEntity.badRequest().body("Usuário não encontrado");
             }

             var usu = usuario;

             String token = tokenServiceJWT.gerarToken(
                     usu.getEmail(),
                     usu.getTipo(),
                     usu.getUuid().toString()
             );

             return ResponseEntity.ok().body(new DadosTokenJWT(token, usu.getUuid().toString(), usu.getTipo()));
         } catch (Exception e) {
             e.printStackTrace();
             return ResponseEntity.badRequest().body("Email ou senha incorretos");
         }
     }


     private record  DadosTokenJWT(String token, String uuid, String tipo) {}

    private record DadosAutenticacao(String email, String senha) { }
}
