package br.csi.alugajunto.model.vaga;

import java.util.List;

public interface VagaRepositoryCustom {
    List<Vaga> buscarComFiltros(FiltroVagaDTO filtro);
}
