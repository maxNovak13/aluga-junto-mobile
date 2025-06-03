package br.csi.alugajunto.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

@Configuration
public class StaticResourceConfig implements WebMvcConfigurer {
//configura para encontrar a pasta uploads
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // caminho físico absoluto para a pasta de uploads
        String uploadPath = Paths.get("uploads").toAbsolutePath().toUri().toString();

        registry.addResourceHandler("/uploads/**")  // URL que será acessada no front
                .addResourceLocations(uploadPath)   // pasta física do servidor
                .setCachePeriod(0);                 // desativa cache (útil para desenvolvimento)
    }
}
