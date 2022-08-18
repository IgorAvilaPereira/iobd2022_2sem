DROP DATABASE IF EXISTS noveleiros;

CREATE DATABASE noveleiros;

\c noveleiros;



CREATE TABLE novelas (
    codigo SERIAL PRIMARY KEY, 
    nome CHARACTER VARYING(50), 
    data_primeiro_capitulo DATE, 
    data_ultimo_capitulo DATE,
    horario_exibicao TIME
);

CREATE TABLE atores (
    codigo SERIAL PRIMARY KEY, 
    nome CHARACTER VARYING (50), 
    data_nascimento DATE, 
    cidade TEXT DEFAULT 'RIO GRANDE', 
    salario REAL, 
    sexo CHARACTER(1) CHECK (sexo = 'F' OR sexo = 'M')
);

CREATE TABLE personagens (
    codigo SERIAL PRIMARY KEY, 
    nome CHARACTER VARYING (50), 
    data_nascimento DATE, 
    situacao_financeira CHARACTER(1) CHECK(situacao_financeira = 'A' OR situacao_financeira = 'B' OR situacao_financeira = 'C'),
    cod_ator INTEGER REFERENCES atores (codigo)
);

CREATE TABLE novelas_personagens (
    cod_novela INTEGER REFERENCES novelas (codigo), 
    cod_personagem INTEGER REFERENCES personagens (codigo),
    PRIMARY KEY (cod_novela, cod_personagem)
);

CREATE TABLE capitulos (
    codigo SERIAL PRIMARY KEY, 
    nome TEXT NOT NULL, 
    data_exibicao DATE DEFAULT CURRENT_DATE, 
    cod_novela INTEGER REFERENCES novelas (codigo)
);

INSERT INTO novelas (nome, data_primeiro_capitulo, data_ultimo_capitulo, horario_exibicao) 
VALUES ('Mulheres de Areia', '1990-01-01', '1990-06-01', '21:00:00');

INSERT INTO novelas (nome, data_primeiro_capitulo, data_ultimo_capitulo, horario_exibicao) 
VALUES ('Mistérios de uma Vida', '2022-01-01', '2022-04-11', '21:00:00');

INSERT INTO novelas (nome, data_primeiro_capitulo, data_ultimo_capitulo, horario_exibicao) 
VALUES ('Vida da gente', '2010-01-01', '2010-04-11', '18:00:00');

INSERT INTO novelas (nome, data_primeiro_capitulo, data_ultimo_capitulo, horario_exibicao) 
VALUES ('Quanto mais vida melhor', '2010-01-01', '2010-04-11', '18:00:00');

INSERT INTO novelas (nome, data_primeiro_capitulo, data_ultimo_capitulo, horario_exibicao) 
VALUES ('Convida a gente', '2010-01-01', '2010-04-11', '18:00:00');

INSERT INTO novelas (nome, data_primeiro_capitulo, data_ultimo_capitulo, horario_exibicao) 
VALUES ('vida', '2010-01-01', '2010-04-11', '18:00:00');


INSERT INTO novelas (nome, data_primeiro_capitulo, data_ultimo_capitulo, horario_exibicao) 
VALUES ('O Clone', '2022-01-01', '2022-04-11', NULL);

INSERT INTO atores (nome, data_nascimento, cidade, salario, sexo) VALUES ('Gloria Pires', '1972-01-01', 'Rio de Janeiro', 50000, 'F');

INSERT INTO atores (nome, data_nascimento, cidade, salario, sexo) VALUES ('Antonio Fagundes', '1957-10-05', 'Marau', 150000, 'M');


INSERT INTO atores (nome, data_nascimento, cidade, salario, sexo) VALUES ('Marcos Frota', '1957-02-02', 'Floripa', 300, 'M');

INSERT INTO atores (nome, data_nascimento, cidade, salario, sexo) VALUES ('Alexandre Frota', '1972-11-07', 'salvador', 150000, 'M');

INSERT INTO personagens (nome, data_nascimento, situacao_financeira, cod_ator) VALUES ('Ruth', '1972-03-04', 'C', 1);
INSERT INTO personagens (nome, data_nascimento, situacao_financeira, cod_ator) VALUES ('Raquel', '1972-03-04', 'C', 1);
INSERT INTO personagens (nome, data_nascimento, situacao_financeira, cod_ator) VALUES ('Tonho da Lua', '1992-07-10', 'C', 3);

INSERT INTO novelas_personagens (cod_novela, cod_personagem) VALUES (1, 1);
INSERT INTO novelas_personagens (cod_novela, cod_personagem) VALUES (1, 2);
INSERT INTO novelas_personagens (cod_novela, cod_personagem) VALUES (1, 3);

INSERT INTO capitulos(nome, data_exibicao, cod_novela) VALUES
('ULTIMO CAPITULO', '2022-04-11', 2);

-- 2) By Doris: noveleiros=# SELECT data_ultimo_capitulo FROM novelas WHERE nome = 'Mistérios de uma Vida';
-- 3) by Joao: noveleiros=# SELECT nome FROM novelas WHERE horario_exibicao IS NULL;
-- 4) noveleiros=# SELECT nome FROM atores WHERE cidade ILIKE 'm%';
-- 5) By Pedro, by Gabryel noveleiros=# SELECT count(codigo) FROM novelas WHERE nome ILIKE 'vida%' OR nome ILIKE '%vida' OR nome ILIKE '% vida %';
-- 6)  by Igor: SELECT count(*) FROM novelas INNER JOIN novelas_personagens ON (novelas.codigo = novelas_personagens.cod_novela) INNER JOIN personagens ON (personagens.codigo = novelas_personagens.cod_personagem) INNER JOIN atores ON (personagens.cod_ator = atores.codigo) WHERE atores.nome = 'Gloria Pires';
-- 7) noveleiros=# SELECT * FROM personagens ORDER BY nome;
-- 8) noveleiros=# SELECT * FROM personagens ORDER BY data_nascimento DESC;
-- 9) noveleiros=# SELECT count(*) FROM atores;
-- 10) noveleiros=# select count(*) from novelas;
-- 11) noveleiros=# SELECT count(*) from atores where sexo = 'F';
-- off-topic: noveleiros=# SELECT (CURRENT_DATE - '1987-01-20')/365;
-- Off-topic: noveleiros=# SELECT EXTRACT(YEAR FROM AGE(CAST('1987-01-20' AS DATE)));
-- 12) by Doris: noveleiros=# SELECT AVG((CURRENT_DATE - data_nascimento)/365) as media_idade FROM atores;
-- 13) noveleiros=# SELECT count(*) FROM personagens WHERE (CURRENT_DATE - data_nascimento)/365 < 15;
-- 14) noveleiros=# SELECT DISTINCT atores.nome FROM atores INNER JOIN personagens ON (atores.codigo = personagens.cod_ator) WHERE (CURRENT_DATE - atores.data_nascimento)/365 = (CURRENT_DATE - personagens.data_nascimento)/365;
-- 15) noveleiros=# SELECT MAX(salario) from atores;
-- 16) noveleiros=# SELECT Min(salario) from atores;
-- 17) noveleiros=# select sum(salario) from atores;







