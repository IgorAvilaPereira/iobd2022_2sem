DROP DATABASE IF EXISTS 
aula_particular;

CREATE DATABASE aula_particular;

\c aula_particular;

CREATE TABLE professor (
    id serial primary key,
    nome character varying(50) not null,
    cpf character(11),
    unique(cpf)
);
INSERT INTO professor (nome, cpf) VALUES 
('IGOR','11111111111'),
('BRIÃO','22222222222'),
('MARCIO', '33333333333');

CREATE TABLE disciplina (
    id serial primary key,
    nome character varying(100) not null
);

INSERT INTO disciplina (nome) VALUES 
('BANCO DE DADOS'),
('LÓGICA DE PROGRAMAÇÃO'),
('DESENVOLVIMENTO WEB');

CREATE TABLE professor_disciplina (
    professor_id integer references professor (id),
    disciplina_id integer references disciplina (id),
    primary key (professor_id, disciplina_id)
);

INSERT INTO professor_disciplina (professor_id, disciplina_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 3);

CREATE TABLE aluno (
    id serial primary key,
    nome character varying (50) not null,
    data_nascimento date
);

INSERT INTO aluno (nome, data_nascimento) VALUES 
('GABRYEL', '2010-02-03'),
('DANIELLE', '2011-02-02'),
('FLAVIO', '2020-09-10');

CREATE TABLE aula (
    id serial primary key,
    data date default current_date,
    hora time default current_time,
    professor_id integer references professor (id),
    aluno_id integer references aluno (id)
);

INSERT INTO aula (professor_id, aluno_id) VALUES 
(1,1),
(1,2),
(1,2),
(2,2),
(2,2),
(2,2),
(3,2);

-- 3) aula_particular=# SELECT aluno.nome, count(*) FROM aluno INNER JOIN aula ON (aluno.id = aula.aluno_id) WHERE EXTRACT(MONTH FROM aula.data) = EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM aula.data) = EXTRACT(YEAR FROM aula.data) GROUP BY aluno.nome;

-- 4) aula_particular=# SELECT DISTINCT professor.nome FROM professor INNER JOIN aula ON (professor.id = aula.professor_id) INNER JOIN aluno ON (aula.aluno_id = aluno.id) WHERE aluno.nome = 'DANIELLE';

-- 5) aula_particular=# SELECT professor.nome FROM professor WHERE professor.id NOT IN (SELECT professor.id FROM professor INNER JOIN professor_disciplina ON (professor.id = professor_disciplina.professor_id));

-- 6) aula_particular=# SELECT aluno.nome FROM aluno WHERE EXTRACT(MONTH FROM data_nascimento) = EXTRACT(MONTH FROM CURRENT_DATE);


-- 7) aula_particular=# SELECT AVG(EXTRACT(YEAR FROM AGE(data_nascimento))) FROM aluno;

-- 8) aula_particular=# SELECT professor.nome FROM professor INNER JOIN aula ON (professor.id = aula.professor_id) GROUP BY professor.nome HAVING count(*) = (SELECT count(*) FROM professor INNER JOIN aula ON (professor.id = aula.professor_id) GROUP BY professor.id ORDER BY count(*) DESC LIMIT 1);

-- EXEMPLO VIEW
/*
DROP VIEW prof_trabalhador;
CREATE VIEW prof_trabalhador AS SELECT professor.id, count(*) FROM professor INNER JOIN aula ON (professor.id = aula.professor_id) GROUP BY professor.id HAVING count(*) = (SELECT count(*) FROM professor INNER JOIN aula ON (professor.id = aula.professor_id) GROUP BY professor.id ORDER BY count(*) DESC LIMIT 1);
*/

-- EXEMPLO CASE WHEN END
/*
aula_particular=# 
    SELECT 
        CASE 
            WHEN EXTRACT(DOW FROM CAST('2022-09-28' AS DATE)) = 0 THEN 'DOMINGO' 
            WHEN EXTRACT(DOW FROM CAST('2022-09-28' AS DATE)) = 1 THEN 'SEGUNDA'
            WHEN EXTRACT(DOW FROM CAST('2022-09-28' AS DATE)) = 2 THEN 'TERÇA'
            WHEN EXTRACT(DOW FROM CAST('2022-09-28' AS DATE)) = 3 THEN 'QUARTA'
            WHEN EXTRACT(DOW FROM CAST('2022-09-28' AS DATE)) = 4 THEN 'QUINTA'
            WHEN EXTRACT(DOW FROM CAST('2022-09-28' AS DATE)) = 5 THEN 'SEXTA'
        WHEN EXTRACT(DOW FROM CAST('2022-09-28' AS DATE)) = 6 THEN 'SÁBADO'      
             
        END;
*/

