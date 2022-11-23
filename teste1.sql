DROP DATABASE IF EXISTS teste1;
CREATE DATABASE teste1;

\c teste1;

CREATE TABLE tabela (
    id serial primary key,
    nome text
);
INSERT INTO tabela (nome) values ('igor');

CREATE GROUP gerente;
CREATE GROUP atendente;
CREATE GROUP estagiario;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public to gerente;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public to gerente;
GRANT SELECT ON ALL TABLES IN SCHEMA public to estagiario;


CREATE USER pedro WITH PASSWORD '123';
ALTER GROUP gerente ADD USER pedro;

CREATE USER gabryel WITH PASSWORD '123';
ALTER GROUP estagiario ADD USER gabryel;




