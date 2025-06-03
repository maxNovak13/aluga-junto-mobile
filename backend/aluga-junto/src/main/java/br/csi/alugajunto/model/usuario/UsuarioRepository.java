package br.csi.alugajunto.model.usuario;

import br.csi.alugajunto.model.vaga.Vaga;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Usuario findByEmail(String email);

    Usuario findUsuarioByUuid(UUID uuid);

    void deleteUsuarioByUuid(UUID uuid);

    @Query("SELECT v FROM Vaga v JOIN v.usuarios u WHERE u.id = :id")
    List<Vaga> findVagaByUsuario(@Param("id") Long id);

//    @Query("SELECT u FROM Usuario u JOIN u.vagas v WHERE v.id = :id")
//    List<Usuario> findUsuarioByVaga(@Param("id") Long id);

    @Modifying
    @Query(value = "DELETE FROM usuario_vaga uv " +
            "USING usuario u " +
            "WHERE u.id= :idusu " +
            "AND u.tipo = 'user' " +
            "AND uv.usuario_id = u.id " +
            "AND uv.usuario_id = :idusu " +
            "AND uv.vaga_id = :idvaga", nativeQuery = true)
    void dessassociarVaga(@Param("idusu") Long idusu, @Param("idvaga") Long idvaga);

}