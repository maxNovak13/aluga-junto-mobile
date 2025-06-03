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
@Schema(description = "Classe que representa o perfil de morador desejado para uma vaga, contendo informações sobre o estilo de vida e preferências.")
public class Perfil {
    @Size(max = 20, message = "Valor máximo de dígitos atingido(20)")
    @Schema(description = "Prefência de gênero do possível morador. Pode ser uma string de até 20 caracteres.", example = "Feminino")
    private String genero;
    @Size(max = 10, message = "Valor máximo de dígitos atingido(10)")
    @Schema(description = "Faixa etária do perfil de morador. Pode ser uma string de até 10 caracteres.", example = "18-25")
    private String idade;
    @NotBlank
    @Schema(description = "Indica se aceitam pessoas com pet na vaga. 'true' para sim e 'false' para não.", example = "true")
    private boolean pet;
    @NotBlank
    @Schema(description = "Indica se aceitam fumantes. 'true' para sim e 'false' para não.", example = "false")
    private boolean fumante;
    @Size(min = 500, message = "Texto muito grande, máximo 500 digitos")
    @Schema(description = "Texto adicional sobre o perfil de morador, descrevendo preferências de estilo de vida e características. Deve ter no máximo 500 caracteres.", example = "Uma pessoa organizada e responsável")
    private String texto;
}
