DROP DATABASE IF EXISTS universidadedb;

CREATE DATABASE universidadedb;

\c universidadedb;

CREATE TABLE universidade (
    cnpj character(14) primary key,
    nome character varying(100) not null,
    endereco text
);


CREATE TABLE departamento (
    id serial primary key,
    nome character varying(100) not null,
    universidade_cnpj character(14) references universidade (cnpj)    
);

CREATE TABLE turno (
    id serial primary key,
    nome character varying(50) not null
);

CREATE TABLE nivel (
    id serial primary key,
    nome character varying(100) not null
);


CREATE TABLE curso (
    id serial primary key,
    nome character varying(100) not null,
    departamento_id integer references departamento (id),
    nivel_id integer references nivel (id),
    turno_id integer references turno (id)  
);


CREATE TABLE disciplina (
    id serial primary key,
    nome character varying (150) not null,
    semestre integer,
    creditos integer,
    carga_horaria integer,
    ementa text,
    curso_id integer references curso (id)
);

CREATE TABLE prerequisito (
    disciplina_id integer references disciplina(id),
    prerequisito_id integer references disciplina(id),
    CHECK (disciplina_id != prerequisito_id),
    PRIMARY KEY (disciplina_id, prerequisito_id)    
);


insert into universidade (cnpj, nome, endereco) values
('42278291000639', 'IFRS - Campus Rio Grande', 'Rua Alfredo Huck, 200');

insert into departamento (nome, universidade_cnpj) values
('COMPUTACAO', '42278291000639');

insert into departamento (nome, universidade_cnpj) values
('DEPTO EDIFICIOS', '42278291000639');

insert into departamento (nome, universidade_cnpj) values
('DEPTO FIOS', '42278291000639');

insert into turno (nome) values
('NOTURNO'),
('DIURNO');

insert into nivel (nome) values
('GRADUACAO'),
('TECNICO');

insert into curso (nome, departamento_id, turno_id, nivel_id) values
('TECNOLOGO EM ANALISE E DESENVOLVIMENTO DE SISTEMAS', 1, 1, 1);

insert into curso (nome, departamento_id, turno_id, nivel_id) values
('TECNICO EM INFORMÁTICA PARA INTERNET', 1, 2, 2);

insert into curso (nome, departamento_id, turno_id, nivel_id) values
('TECNOLOGO EM CONSTRUÇÃO DE EDIFICIOS', 2, 1, 1);


insert into disciplina (nome, creditos, carga_horaria, ementa, semestre, curso_id) values
('IMPLEMENTACAO E OPERACAO DE BANCO DE DADOS', 4, 66, 'MODELO RELACIONAL. LINGUAGEM PARA DEFINICAO. CONSULTA DE DADOS. NORMALIZACAO. NOCOES DE PROGRAMACAO EM BD.', 3, 1),
('PROJETO E MODELAGEM DE BANCO DE DADOS', 2, 33, 'Introdução aos conceitos básicos de banco de dados e sistemas.', 2, 1);

insert into disciplina (nome, creditos, carga_horaria, ementa, semestre, curso_id) values
('WEB1', 4, 20, 'COISAS DE WEB1', 1, 2),
('WEB2', 2, 30, 'COISAS DE WEB2', 2, 2);

insert into disciplina (nome, creditos, carga_horaria, ementa, semestre, curso_id) values
('TIJOLO 1', 4, 20, 'MATERIAIS DOS TIJOLOS', 1, 3),
('VIGA 1', 4, 30, 'MATERIAIS DAS VIGAS E PRÉ-LAJES', 2, 3);

insert into prerequisito (disciplina_id, prerequisito_id) values
(1, 2);

-- 10) universidadedb=# SELECT disciplina.nome, creditos, carga_horaria FROM disciplina inner join curso on (curso.id = disciplina.curso_id) where curso.id = 1 order by disciplina.semestre, disciplina.nome;

-- 11) universidadedb=# SELECT SUM(disciplina.carga_horaria) FROM disciplina inner join curso on (curso.id = disciplina.curso_id) where curso.id = 1;

-- 12) universidadedb=# SELECT curso.nome FROM curso INNER JOIN disciplina ON (curso.id = disciplina.curso_id) GROUP BY curso.nome HAVING SUM(disciplina.creditos) in (SELECT SUM(disciplina.creditos) from curso inner join disciplina on (curso.id = disciplina.curso_id) group by curso.nome order by sum(disciplina.creditos) limit 1);

-- 13) universidadedb=# Select curso.nome from departamento inner join curso on (departamento.id = curso.departamento_id) where departamento.nome = 'COMPUTACAO';

-- 14) universidadedb=# SELECT departamento.nome, count(curso.id) FROM departamento LEFT JOIN curso ON (departamento.id = curso.departamento_id) GROUP BY departamento.nome;

-- 15) universidadedb=# select curso.nome, disciplina.semestre, sum(disciplina.creditos) from disciplina inner join curso on (curso.id = disciplina.curso_id) WHERE curso.nome = 'TECNOLOGO EM ANALISE E DESENVOLVIMENTO DE SISTEMAS' group by curso.nome, disciplina.semestre order by curso.nome, semestre;

















