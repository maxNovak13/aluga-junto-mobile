package br.csi.alugajunto.model.vaga;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface VagaRepository extends JpaRepository<Vaga, Long> {
    public Vaga findVagaByUuid(UUID uuid);

    public void deleteVagaByUuid(UUID uuid);

}
