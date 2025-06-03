package br.csi.alugajunto.model.usuario;

import br.csi.alugajunto.model.vaga.Vaga;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;

import java.util.*;

@Entity
@Table(name = "usuario")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@RequiredArgsConstructor
@Schema(description = "Entidade que representa o usuário no sistema")
public class Usuario {
    @Id
    @GeneratedValue(
            strategy = GenerationType.IDENTITY)
    @Schema(description = "ID do usuário", example = "1")
    private Long id;
    @UuidGenerator
    @Schema(description = "UUID único do usuário", example = "6effe31d-6eaa-4a15-8330-ff78588cb843")
    private UUID uuid;
    @NonNull
    @Size(max = 50, message = "Nome deve ter no máximo 50 digitos")
    @Schema(description = "Nome completo do usuário", example = "Felipe Silva")
    private String nome;
    @NonNull
    @Email
    @Size(max = 100, message = "Email inválido.")
    @Schema(description = "Endereço de e-mail do usuário", example = "felipe@exemplo.com")
    private String email;
    @NonNull
    @Size(max = 15, message = "Telefone deve ser no formato 12 12345-1234")
    @Schema(description = "Número de telefone do usuário", example = "12 12345-1234")
    private String telefone;
    @NonNull
    @Size(max = 100, message = "A senha deve ter no máximo 50 caracteres.")
    @Schema(description = "Senha do usuário", example = "senha1234")
    private String senha; //tem que fazer a criptografia
    @Schema(description = "Tipo de usuário (user = busca vagas, admin = oferece vaga(s))", example = "0")
    private String tipo;

    @ManyToMany
    @JoinTable(
            name = "usuario_vaga", // nome da tabela de junção
            joinColumns = @JoinColumn(name = "usuario_id"),
            inverseJoinColumns = @JoinColumn(name = "vaga_id")
    )
    //  @JsonManagedReference
    @Schema(description = "Lista de vagas associadas ao usuário", implementation = Usuario.class)
    private List<Vaga> vagas = new ArrayList<>();


}
