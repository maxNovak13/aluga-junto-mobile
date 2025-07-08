package br.csi.alugajunto.infra.security;


import br.csi.alugajunto.model.usuario.UsuarioRepository;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.exceptions.JWTVerificationException;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
@Service
public class TokenServiceJWT {

    UsuarioRepository repository;

    public TokenServiceJWT(UsuarioRepository repository) {
        this.repository = repository;
    }


    public String gerarToken(String email, String role, String uuid){
        try{
            Algorithm algorithm = Algorithm.HMAC256("POO2");
            return JWT.create()
                    .withIssuer("API Aluga Junto")
                    .withSubject(email)
                    .withClaim("ROLE", role)
                    .withClaim("uuid", uuid)
                    .withExpiresAt(dataExpiracao())
                    .sign(algorithm);
        } catch (JWTCreationException e){
            throw new RuntimeException("Erro ao gerar o token JWT" + e);
        }

    }
    private Instant dataExpiracao(){
        return LocalDateTime.now().plusHours(2).toInstant(ZoneOffset.of("-03:00"));

    }

    public String getSubject(String token) {
        try {
            Algorithm algorithm = Algorithm.HMAC256("POO2");
            return JWT.require(algorithm)
                    .withIssuer("API Aluga Junto")
                    .build()
                    .verify(token)
                    .getSubject();
        } catch (JWTVerificationException e) {
            throw new RuntimeException("Token inválido ou expirado");
        }
    }

}
