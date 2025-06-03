package br.csi.alugajunto.service;

import br.csi.alugajunto.model.vaga.Vaga;
import br.csi.alugajunto.model.vaga.VagaRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class VagaService {
    private final VagaRepository repository;

    public VagaService(VagaRepository repository) {
        this.repository = repository;
    }

    public void salvarVaga(Vaga vaga) {
        this.repository.save(vaga);
    }

    public List<Vaga> listarVagas() {
        return this.repository.findAll();
    }

    public Vaga getVaga(Long id) {
        return this.repository.findById(id).get();
    }

    public void excluirVaga(Long id) {
        this.repository.deleteById(id);
    }

    public void atualizarVaga(Vaga vaga) {
        Vaga v = this.repository.getReferenceById(vaga.getId());
        v.setTitulo(vaga.getTitulo());
        v.setDescricao(vaga.getDescricao());
        v.setArea(vaga.getArea());
        v.setDormitorio(vaga.getDormitorio());
        v.setBanheiro(vaga.getBanheiro());
        v.setGaragem(vaga.getGaragem());
        v.setImagem(vaga.getImagem());
        v.setEndereco(vaga.getEndereco());
        v.setPerfil(vaga.getPerfil());
        this.repository.save(v);
    }

    public void atualizarVagaUUID(Vaga vaga) {
        Vaga v = this.repository.findVagaByUuid(vaga.getUuid());
        v.setTitulo(vaga.getTitulo());
        v.setDescricao(vaga.getDescricao());
        v.setArea(vaga.getArea());
        v.setDormitorio(vaga.getDormitorio());
        v.setBanheiro(vaga.getBanheiro());
        v.setGaragem(vaga.getGaragem());
        v.setImagem(vaga.getImagem());
        v.setEndereco(vaga.getEndereco());
        v.setPerfil(vaga.getPerfil());

        this.repository.save(v);
    }

    public Vaga getVagaUUID(String uuid) {
        UUID uuidformatado = UUID.fromString(uuid);
        return this.repository.findVagaByUuid(uuidformatado);
    }

    public void deletarVagaUUID(String uuid) {
        this.repository.deleteVagaByUuid(UUID.fromString(uuid));
    }



    public String salvarImagem(MultipartFile imagem) throws IOException {
        final String diretorioImagens = "uploads/";
        if (imagem.isEmpty()) {
            throw new IllegalArgumentException("A imagem está vazia");
        }

        String nomeArquivo = UUID.randomUUID() + "_" + imagem.getOriginalFilename();
        Path caminho = Paths.get(diretorioImagens + nomeArquivo);

        // Cria o diretório se não existir
        Files.createDirectories(caminho.getParent());

        // Salva o arquivo no sistema
        Files.write(caminho, imagem.getBytes());

        return caminho.toString().replace("\\", "/"); // ou só o nomeArquivo se quiser salvar só o nome
    }


}


