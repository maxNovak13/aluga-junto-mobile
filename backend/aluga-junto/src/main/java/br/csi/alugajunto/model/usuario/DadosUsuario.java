package br.csi.alugajunto.model.usuario;


import java.util.UUID;

public record DadosUsuario (UUID uuid, String email, String tipo) {
    public DadosUsuario(Usuario usuario) {
        this(usuario.getUuid(), usuario.getEmail(), usuario.getTipo());
    }
}
