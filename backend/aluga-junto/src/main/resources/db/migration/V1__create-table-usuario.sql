create table usuario(
                        id serial not null primary key,
                        uuid uuid DEFAULT gen_random_uuid(),
                        nome varchar(50) not null,
                        email varchar(100) not null unique,
                        telefone varchar(15) not null,
                        tipo boolean not null,
                        senha varchar(100) not null
);