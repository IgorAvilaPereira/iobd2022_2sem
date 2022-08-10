DROP DATABASE IF EXISTS cinema;

CREATE DATABASE cinema;

\c cinema;

CREATE TABLE salas (
    numero integer primary key,
    descricao character varying (50),
    capacidade integer
);

CREATE TABLE diretores (
    codigo serial primary key,
    nome text not null
);

CREATE TABLE filmes (
    codigo serial primary key,
    nome character varying(100),
    ano_lancamento integer,
    categoria character varying(50),
    cod_diretor integer references diretores (codigo)
);


CREATE TABLE salas_filmes (
    numero_sala integer references salas (numero),
    cod_filme integer references filmes (codigo),
    data date,
    horario time,
    primary key (numero_sala, cod_filme, data)
);

CREATE TABLE premios (
    codigo serial primary key,
    nome character varying(100),
    ano_premiacao integer,
    cod_filme integer references filmes (codigo)
);

INSERT INTO salas (numero, descricao, capacidade) VALUES
(101, 'Sala 3D 1', 100),
(102, 'Sala 3D 2', 100),
(103, 'Sala Convencional 1', 150),
(201, 'Sala Convencional 2', 100),
(202, 'Sala 3D 3', 80);

INSERT INTO diretores (nome) VALUES
('Fulano de Tal da Silva'),
('Ciclana das Neves'),
('Josicreidson Seilayevski');

INSERT INTO filmes (nome, ano_lancamento, categoria, cod_diretor) VALUES
('Titanic', 1997, 'Drama', 1),
('Matrix', 2001, 'Ficção', 1),
('À Prova de Fogo', 2009, 'Romance', 2),
('Toy Story', 1998, 'Animação', 3),
('Shrek', 2000, 'Animação', 2);

INSERT INTO salas_filmes (numero_sala, cod_filme, data, horario) VALUES
(101,1,'2014-04-14', '20:00'),
(101,2, '2014-04-15', '22:00'),
(102,1, '2014-04-10', '19:00'),
(103,3, '2014-04-22', '16:00'),
(201,4, '2014-04-14', '22:00'),
(201,5, '2014-04-15', '20:00'),
(202,3, '2014-04-21', '20:00');

INSERT INTO premios (nome, ano_premiacao, cod_filme) VALUES
('Oscar - Melhor Filme', 1997, 1),
('Oscar - Melhor Diretor', 1997, 1),
('Globo de Ouro - Melhor Filme', 1997, 1),
('Oscar - Efeitos Especiais', 2002, 2),
('Globo de Ouro - Melhor Animação', 1999, 4),
('Globo de Ouro - Melhor Animação', 2001, 5),
('Oscar - Melhor Atriz Coadjuvante', 1997, 1);
