DROP DATABASE IF EXISTS aula030822;

CREATE DATABASE aula030822;

\c aula030822;

CREATE TABLE empresa (
    id SERIAL PRIMARY KEY,
    nome text,
    endereco text
);

CREATE TABLE banner (
    id SERIAL PRIMARY KEY,
    arquivo TEXT NOT NULL,
    altura integer,
    largura integer,
    link text,
    tipo text CHECK (tipo = 'SUPERIOR' OR tipo = 'INFERIOR') DEFAULT 'SUPERIOR',
    qtde_cliques INTEGER DEFAULT 0,
    empresa_id INTEGER REFERENCES empresa (id)
);


CREATE TABLE jornalista (
    id serial primary key,
    nome text not null,
    cpf character(11),
    data_nascimento date,
    email text,
    senha text,
    unique(cpf),
    unique(email)
);

CREATE TABLE categoria (
    id serial primary key,
    nome text not null
);


CREATE TABLE noticia (
    id serial primary key,
    titulo text,
    texto text,
    data date DEFAULT CURRENT_DATE,
    hora time DEFAULT CURRENT_TIME,
    eh_publica boolean DEFAULT TRUE,
    qtde_views INTEGER DEFAULT 0,
    jornalista_id integer REFERENCES jornalista (id),
    categoria_id integer REFERENCES categoria (id)   
);

CREATE TABLE foto (
    id serial primary key,
    nome text,
    legenda text,
    noticia_id integer references noticia (id)    
);



CREATE TABLE assinante (
    id serial primary key,
    nome text not null,
    data_nascimento date,
    cpf character(11),
    email text,
    senha text not null,
    data_inicio date DEFAULT CURRENT_DATE,
    data_fim DATE CHECK (data_fim > data_inicio),
    unique(email),
    unique(cpf)

);

CREATE TABLE plano (
    id SERIAL PRIMARY KEY,
    valor real,
    nome text not null
);

CREATE TABLE historico (
    plano_id integer references plano (id),
    assinante_id integer references assinante (id),
    valor_pago real,
    data_pagamento date default CURRENT_DATE,
    PRIMARY KEY (plano_id, assinante_id, data_pagamento)
);

CREATE TABLE assinante_noticia (
    assinante_id integer references assinante(id),
    noticia_id integer references noticia (id),
    primary key (assinante_id, noticia_id)
);


INSERT INTO categoria (nome) VALUES
('ESPORTE'),
('ECONOMIA'),
(UPPER('entretenimento'));

INSERT INTO assinante(nome, cpf, email, senha) VALUES
('IGOR AVILA PEREIRA', '17658586072', 'igor.pereira@riogrande.ifrs.edu.br', md5('1234')),
('RAFAEL BETITO', '11111111111', 'rafael.betito@riogrande.ifrs.edu.br', md5('4321'));

INSERT INTO jornalista (nome, cpf, email, senha) VALUES
('CIBELE SINOTTI', '33333333333', 'cibele.sinotti@riogrande.ifrs.edu.br', md5('5678'));


INSERT INTO noticia (titulo, texto, jornalista_id, categoria_id) VALUES
('NOTICIA1', 'TEXTO DA NOTICIA 1', 1, 1),
('NOTICIA2 - ECONOMIA', 'TEXTO DA NOTICIA 2', 1, 2);
