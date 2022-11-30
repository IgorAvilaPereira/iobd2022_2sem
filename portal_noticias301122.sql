DROP DATABASE IF EXISTS portal_noticias;

CREATE DATABASE portal_noticias;

\c portal_noticias;

CREATE SCHEMA admin;
CREATE SCHEMA publicidade;
CREATE SCHEMA externo;

SET search_path TO public, admin, publicidade, externo;

CREATE TABLE publicidade.empresa (
    id SERIAL PRIMARY KEY,
    nome text,
    endereco text
);

INSERT INTO publicidade.empresa (nome, endereco) VALUES
('VETORIAL.NET', 'ALFREDO HUCH');

CREATE TABLE publicidade.banner (
    id SERIAL PRIMARY KEY,
    arquivo bytea,
    legenda text,
    altura integer,
    largura integer,
    link text,
    tipo text CHECK (tipo = 'SUPERIOR' OR tipo = 'INFERIOR') DEFAULT 'SUPERIOR',
    qtde_cliques INTEGER DEFAULT 0,
    empresa_id INTEGER REFERENCES empresa (id)
);


CREATE TABLE admin.jornalista (
    id serial primary key,
    nome text not null,
    cpf character(11),
    data_nascimento date,
    email text,
    senha text,
    unique(cpf),
    unique(email)
);

INSERT INTO admin.jornalista (nome, cpf, email, senha, data_nascimento) VALUES
('GABRYEL', '11111111111', 'gabryel@gmail.com', md5('gabryel'), '2000-02-17'),
('FLAVIO', '22222222222', 'flavio@vetorial.net', md5('flavio'), '1974-12-10'),
('IGOR', '33333333333', 'igor@mikrus.com', md5('igor'),'1987-01-20'),
('DANIELLE', '44444444444', 'danielle@bol.com', md5('danielle'), '1994-01-02'),
('DORIS', '55555555555', 'doris@hotmail.com', md5('doris'), '1990-12-24');

CREATE TABLE admin.categoria (
    id serial primary key,
    nome text not null
);


CREATE TABLE externo.noticia (
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

CREATE TABLE externo.foto (
    id serial primary key,
    nome text,
    legenda text,
    noticia_id integer references noticia (id)    
);



CREATE TABLE public.assinante (
    id serial primary key,
    nome text not null,
    data_nascimento date,
    cpf character(11),
    email text,
    senha text not null,
    unique(email),
    unique(cpf)

);

INSERT INTO public.assinante(nome, cpf, email, senha) VALUES
('IGOR AVILA PEREIRA', '17658586072', 'igor.pereira@riogrande.ifrs.edu.br', md5('1234')),
('RAFAEL BETITO', '11111111111', 'rafael.betito@riogrande.ifrs.edu.br', md5('4321'));

CREATE TABLE public.modalidade (
    id SERIAL PRIMARY KEY,
    valor real,
    nome text not null,
    unique(nome)
);

INSERT INTO modalidade (nome, valor) VALUES
('XUBREGA', 1.99),
('DELUXE', 2.99);

CREATE TABLE public.plano (
    id serial primary key,
    modalidade_id integer references modalidade (id),
    assinante_id integer references assinante (id),
    data_inicio date DEFAULT CURRENT_DATE,
    data_fim DATE CHECK (data_fim > data_inicio)
);

INSERT INTO plano (modalidade_id, assinante_id) VALUES
(1,1),
(1,2);

CREATE TABLE public.pagamento (
    id serial primary key,
    valor_pago real,
    data date DEFAULT CURRENT_DATE,
    plano_id integer references plano (id)    
);

INSERT INTO pagamento (plano_id, valor_pago) VALUES
(1, 1.99);

CREATE TABLE public.assinante_noticia (
    assinante_id integer references assinante(id),
    noticia_id integer references noticia (id),
    data_hora timestamp DEFAULT CURRENT_TIMESTAMP,    
    primary key (assinante_id, noticia_id, data_hora)
);



INSERT INTO admin.categoria (nome) VALUES
('ESPORTE'),
('ECONOMIA'),
(UPPER('entretenimento'));


INSERT INTO externo.noticia (titulo, texto, jornalista_id, categoria_id) VALUES
('NOTICIA1', 'TEXTO DA NOTICIA 1', 1, 1),
('NOTICIA2 - ECONOMIA', 'TEXTO DA NOTICIA 2', 1, 2);

INSERT INTO assinante_noticia (assinante_id, noticia_id) VALUES 
(1,1);
INSERT INTO assinante_noticia (assinante_id, noticia_id) VALUES 
(1,1);
INSERT INTO assinante_noticia (assinante_id, noticia_id) VALUES 
(2,1);
INSERT INTO assinante_noticia (assinante_id, noticia_id) VALUES 
(1,2);


-- 1) schemas criados
-- 2) Correção da chave pk composta de assinante_noticia resolvida com a criação de uma nova chave composta com a adição da data da leitura daquela determinada noticia por aquele determinado assinante
-- 3) portal_noticias=# select assinante.nome, modalidade.nome from assinante inner join plano on (plano.assinante_id = assinante.id) INNER JOIN modalidade on (modalidade.id = plano.modalidade_id);
-- 4) portal_noticias=# select assinante.nome, modalidade.nome from assinante inner join plano on (plano.assinante_id = assinante.id) INNER JOIN modalidade on (modalidade.id = plano.modalidade_id) where plano.id not in (select plano_id from pagamento where extract(month from data) = extract(month from current_date) and extract(year from data) = extract(year from current_date));
-- 5) portal_noticias=# SELECT externo.noticia.titulo FROM externo.noticia LEFT JOIN externo.foto ON (externo.noticia.id = externo.foto.noticia_id);
-- 6) portal_noticias=# SELECT admin.jornalista.nome, count(*) FROM admin.jornalista INNER JOIN externo.noticia ON (admin.jornalista.id = externo.noticia.jornalista_id) group by admin.jornalista.nome having count(*) = (select count(*) from admin.jornalista INNER JOIN externo.noticia ON (admin.jornalista.id = externo.noticia.jornalista_id) group by admin.jornalista.id ORDER BY count(*) DESC LIMIT 1);
-- 7) portal_noticias=# SELECT admin.categoria.nome, count(*) FROM admin.categoria inner join externo.noticia on (admin.categoria.id = externo.noticia.categoria_id) group by admin.categoria.nome having count(*) = (select count(*) from admin.categoria inner join externo.noticia on (admin.categoria.id = externo.noticia.categoria_id) group by admin.categoria.id ORDER BY COUNT(*) DESC LIMIT 1);
/* 8) portal_noticias=# select 
    noticia_id, 
    count(*) as qtde,  
    CASE    
         WHEN COUNT(*) = 1 THEN 'lida 1x' 
         WHEN COUNT(*) = 2 THEN 'lida 2x' 
   ELSE 'noticia top' END as comentario 
from 
    assinante_noticia 
group by noticia_id;
*/
-- 9) já foi nos inserts de assinante
-- 10) pendente
-- 11) feito => criamos uma tabela especifica para plano, modalidade e pagamento
/* 12) portal_noticias=#*/ CREATE VIEW qtde_visualizacoes AS select                                     
    noticia_id, 
    count(*) as qtde,  
    CASE    
         WHEN COUNT(*) = 1 THEN 'lida 1x' 
         WHEN COUNT(*) = 2 THEN 'lida 2x' 
   ELSE 'noticia top' END               
from 
    assinante_noticia 
group by noticia_id;
-- 13) pendente

DROP USER administrador1;
DROP USER administrador2;

DROP USER jornalista1;
DROP USER jornalista2;

DROP USER estagiario1;
DROP USER estagiario2;

DROP GROUP grupo_administrador;
DROP GROUP grupo_jornalista;
DROP GROUP grupo_estagiario;

CREATE GROUP grupo_administrador;
CREATE GROUP grupo_jornalista;
CREATE GROUP grupo_estagiario;

CREATE USER administrador1 WITH PASSWORD '123' SUPERUSER;
CREATE USER administrador2 WITH PASSWORD '123' SUPERUSER;

ALTER GROUP grupo_administrador ADD USER administrador1;
ALTER GROUP grupo_administrador ADD USER administrador2;

CREATE USER jornalista1 WITH PASSWORD '123';
CREATE USER jornalista2 WITH PASSWORD '123';

ALTER GROUP grupo_jornalista ADD USER jornalista1;
ALTER GROUP grupo_jornalista ADD USER jornalista2;

GRANT USAGE ON SCHEMA externo TO grupo_jornalista;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA externo TO grupo_jornalista;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA externo TO grupo_jornalista;

CREATE USER estagiario1 WITH PASSWORD '123';
CREATE USER estagiario2 WITH PASSWORD '123';

ALTER GROUP grupo_estagiario ADD USER estagiario1;
ALTER GROUP grupo_estagiario ADD USER estagiario2;

GRANT USAGE ON SCHEMA public,admin,externo,publicidade TO grupo_estagiario;
GRANT SELECT ON ALL TABLES IN SCHEMA public, admin, externo, publicidade TO grupo_estagiario;

