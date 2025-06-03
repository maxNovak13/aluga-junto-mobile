package br.csi.alugajunto.model.vaga;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Classe que representa o endereço de uma vaga.")
public class Endereco {
    @NotBlank
    @Size(max = 80, message = "Deve ter menos de 80 digitos")
    @Schema(description = "Rua do endereço. Deve ser uma string não vazia e ter no máximo 80 caracteres.", example = "Rua Rio Branco")
    private String rua;
    @NotBlank
    @Size(max = 80, message = "Deve ter menos de 80 digitos")
    @Schema(description = "Bairro do endereço. Deve ser uma string não vazia e ter no máximo 80 caracteres.", example = "Centro")
    private String bairro;
    @Size(min = 9, max = 9, message = "CEP inválido, , deve ser no formato:12345-123")
    @Schema(description = "CEP do endereço, no formato XXXXX-XXX", example = "12345-123")
    private String cep;
    @NotBlank
    @Size(max = 30, message = "Deve ter menos de 30 digitos")
    @Schema(description = "Cidade do endereço. Deve ser uma string não vazia e ter no máximo 30 caracteres.", example = "Santa Maria")
    private String cidade;
    @Size(min = 2, message = "Estado deve ser no formato XX")
    @Schema(description = "Estado do endereço, no formato de sigla de 2 caracteres.", example = "SM")
    private String estado;
}
