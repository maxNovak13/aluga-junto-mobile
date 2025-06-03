package br.csi.alugajunto.service;

import br.csi.alugajunto.model.usuario.DadosUsuario;
import br.csi.alugajunto.model.usuario.Usuario;
import br.csi.alugajunto.model.usuario.UsuarioRepository;
import br.csi.alugajunto.model.vaga.Vaga;
import br.csi.alugajunto.model.vaga.VagaRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class UsuarioService {
    private final UsuarioRepository repository;
    private final VagaRepository vagaRepository;

    public UsuarioService(UsuarioRepository repository, VagaRepository vagaRepository) {
        this.repository = repository;
        this.vagaRepository = vagaRepository;
    }

    public void cadastrar(Usuario usuario) {
        //criptografia
        usuario.setSenha(new BCryptPasswordEncoder().encode(usuario.getSenha()));
        this.repository.save(usuario);
    }

    public DadosUsuario findUsuario(Long id){
        Usuario usuario = this.repository.getReferenceById(id);
        return new DadosUsuario(usuario);
    }
    public List<DadosUsuario> findAllUsuarios(){
        return this.repository.findAll().stream().map(DadosUsuario::new).toList();
    }


    public void excluirUsuario(Long id) {
        this.repository.deleteById(id);
    }

    public void atualizar(Usuario usuario) {
        Usuario u = this.repository.getReferenceById(usuario.getId());
        u.setEmail(usuario.getEmail());
        u.setNome(usuario.getNome());
        u.setTelefone(usuario.getTelefone());
        u.setSenha(usuario.getSenha());
        this.repository.save(u);
    }

    public void atualizarUUID(Usuario usuario) {
        Usuario u = this.repository.findUsuarioByUuid(usuario.getUuid());
        u.setEmail(usuario.getEmail());
        u.setNome(usuario.getNome());
        u.setTelefone(usuario.getTelefone());
        u.setSenha(usuario.getSenha());
        this.repository.save(u);
    }

    public Usuario getUsuarioUUID(String uuid) {
        UUID uuidformatado = UUID.fromString(uuid);
        return this.repository.findUsuarioByUuid(uuidformatado);
    }

    public void deletarUUID(String uuid) {
        this.repository.deleteUsuarioByUuid(UUID.fromString(uuid));
    }

    //métodos em relação a gerenciar relação entre vaga e usuário
    public void associarUsuarioComVaga(String usuarioUuid, Long vagaId) {
        UUID uuidformatado = UUID.fromString(usuarioUuid);
        Usuario usuario = repository.findUsuarioByUuid(uuidformatado);
        Vaga vaga = vagaRepository.findById(vagaId).orElseThrow();
        usuario.getVagas().add(vaga);
        vaga.getUsuarios().add(usuario);
        repository.save(usuario);
    }

    //tira interesse do user a vaga -> dessassociar usuário e vaga da tabela usuario_vaga quando usuario do tipo "user" = uma relacao de interesse
    public void dessassociarUsuarioComVaga(String usuarioUuid, Long vagaId) {
        UUID uuidformatado = UUID.fromString(usuarioUuid);
        Usuario usuario = repository.findUsuarioByUuid(uuidformatado);
        //verifica se o usuario inserido é um usuário user = apenas se interessa por vagas
        repository.dessassociarVaga(usuario.getId(), vagaId);//se for remove/dessassocia a relaçao usuário vaga
    }

    //busco vagas do usuario -> proprietario ou interessado
    public List<Vaga> listarVagasPorUsuarioUuid(String uuidusuario) {
        UUID uuidformatado = UUID.fromString(uuidusuario);
        return this.repository.findVagaByUsuario(this.repository.findUsuarioByUuid(uuidformatado).getId());
    }

//    //busco usuários interessados em uma vaga do usuario
//    public List<Usuario> listarUsuariosPorVagasUuid(String uuidusuario) {
//        UUID uuidformatado = UUID.fromString(uuidusuario);
//        return this.repository.findUsuarioByVaga(this.repository.findUsuarioByUuid(uuidformatado).getId());
//    }
}
