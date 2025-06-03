package br.csi.alugajunto.model.vaga;

import br.csi.alugajunto.model.usuario.Usuario;
import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;

import java.util.*;


@Entity
@Table(name = "vaga")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@RequiredArgsConstructor
@Schema(description = "Entidade que representa a vaga ofertada para locação ou aluguel.")
public class Vaga {
    @Id
    @GeneratedValue(
            strategy = GenerationType.IDENTITY)
    @Schema(description = "ID da vaga", example = "1")
    private Long id;
    @UuidGenerator
    @Schema(description = "UUID único da vaga", example = "38e9fcf3-f40a-4e93-8f90-310f7e30f330")
    private UUID uuid;
    @NotBlank
    @Size(max = 80, message = "Título deve ter no máximo 80 digitos")
    @Schema(description = "Título da vaga", example = "República masculina no Centro")
    private String titulo;
    @NotBlank
    @Size(max = 200, message = "Decrição deve ter no máximo 200 digitos")
    @Schema(description = "Descrição com outras informações relevantes sobre a vaga", example = "O quarto é mobiliado, o apartamento próximo ao transporte público, supermercados e comércio.")
    private String descricao;
    @Schema(description = "Área total da vaga em metros quadrados", example = "80")
    private int area;
    @Schema(description = "Quantidade de dormitórios do lugar", example = "4")
    private int dormitorio;
    @Schema(description = "Quantidade de banheiros do lugar", example = "2")
    private int banheiro;
    @Schema(description = "Número de vagas de garagem disponíveis", example = "1")
    private int garagem;
    @Schema(description = "Imagem do lugar", example = "https://example.com/images/apartamentofachada.jpg")
    private String imagem;

    @Embedded
    @NonNull
    private Endereco endereco;

    @Embedded
    @NonNull
    private Perfil perfil;


    @ManyToMany(mappedBy = "vagas")
    @JsonIgnore
    //  @JsonBackReference
    @Schema(description = "Lista de usuarios associadas a uma vaga", implementation = Usuario.class)
    private List<Usuario> usuarios = new ArrayList<>();
}
