package br.csi.alugajunto.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {
//configura para aceitar requisição
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {

            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")   // libera CORS para todos os endpoints
                        .allowedOrigins("http://localhost:53788") // libera seu front-end
                        //.allowedOrigins("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // métodos permitidos
                        .allowedHeaders("*")   // permite todos os headers
                        .allowCredentials(true); // se usar cookies/autenticação com credenciais
            }
        };

    }
}
