package br.csi.alugajunto.model.vaga;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class FiltroVagaDTO {
    private String genero;
    private Boolean pet;
    private Boolean fumante;
    private String cidade;
    private String estado;
    private String bairro;
}
