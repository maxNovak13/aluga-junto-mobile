package br.csi.alugajunto;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

//http://localhost:8080/aluga-junto/swagger-ui/index.html
@OpenAPIDefinition(
        info = @Info(
                title = "API Aluga Junto",
                version = "1.0",
                description = "Documentação da API Aluga Junto"
                //	contact = @Contact(name = "Suporte", email = "suporte@exemplo.com")
        )
)
@SpringBootApplication
public class AlugaJuntoApplication {
    public static void main(String[] args) {
        SpringApplication.run(AlugaJuntoApplication.class, args);
    }
}
