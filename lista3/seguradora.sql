DROP DATABASE IF EXISTS seguradora_bd;

CREATE DATABASE seguradora_bd;

\c seguradora_bd;


CREATE TABLE seguradora (
    cnpj character(14) primary key,
    nome text not null
);

INSERT INTO seguradora (cnpj, nome) VALUES ('12312312312312', 'IFRS Seguradora LTDA.');


CREATE TABLE cliente (
    cpf character(11) primary key,
    nome character varying(60) not null,
    telefone text,
    cnh text,
    endereco text,
    seguradora_cnpj character(14) references seguradora (cnpj)
);

INSERT INTO cliente (cpf, nome, seguradora_cnpj) VALUES 
('12312312311', 'Gabryel','12312312312312'),
('78978978999', 'Doris','12312312312312');


CREATE TABLE carro (
    chassi character(17) primary key,
    descricao text,
    placa character(7),
    km real,
    cliente_cpf character(11) references cliente (cpf)
);
INSERT INTO carro (chassi, descricao, cliente_cpf) VALUES 
('67867867889999999', 'Escort','12312312311'),
('45645645645645666', 'Brasilia', '12312312311'),
('12345678911111111', 'Gol da Doris', '78978978999');


CREATE TABLE acidente (
    codigo serial primary key,
    descricao text,
    data date,
    hora time,
    local text,
    valor real,
    carro_chassi character(17) references carro (chassi)
);
INSERT INTO acidente (descricao, data, hora, local, valor, carro_chassi) VALUES 
('bateu lá no portico',CURRENT_DATE, CURRENT_TIME,'presidente vargas',1000, '67867867889999999'),
('bateu lá no cassino','2014-01-20', '20:00','na avenida',1000, '67867867889999999'),
('bateu lá no canalete',CURRENT_DATE, CURRENT_TIME,'major carlos pinto',100, '12345678911111111');

-- 2) seguradora_bd=# SELECT cliente.nome, acidente.descricao, acidente.data, acidente.hora FROM cliente inner join carro on (carro.cliente_cpf = cliente.cpf) inner join acidente on (acidente.carro_chassi = carro.chassi) WHERE cliente.nome = 'Gabryel';

-- 3) seguradora_bd=# select cliente.nome, count(*) FROM cliente inner join carro on (cliente.cpf = carro.cliente_cpf) inner join acidente on (acidente.carro_chassi = carro.chassi) WHERE data >= '2014-01-01' AND data < '2014-03-01' group by cliente.nome;







