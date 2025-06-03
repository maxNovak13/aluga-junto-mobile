CREATE TABLE usuario_vaga (
            usuario_id BIGINT NOT NULL,   -- Coluna que referencia o ID do usuário
            vaga_id BIGINT NOT NULL,      -- Coluna que referencia o ID da vaga
            PRIMARY KEY (usuario_id, vaga_id),  -- Chave primária composta
            -- Constraints para garantir a integridade referencial
            FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
            FOREIGN KEY (vaga_id) REFERENCES vaga(id) ON DELETE CASCADE
);
