DROP DATABASE IF EXISTS hospitalbd;

CREATE DATABASE hospitalbd;

\c hospitalbd;


CREATE TABLE hospital (
    cnpj character(14) primary key,
    nome text not null,
    endereco text
);

INSERT INTO hospital (cnpj, nome, endereco) VALUES
('39159144000120', 'HOSPITAL DO IFRS', 'ALFREDO HUCH 123');

CREATE TABLE medico (
    crm character(6) primary key,
    nome character varying(60) NOT NULL,
    telefone character(15),
    hospital_cnpj character(14) references hospital (cnpj)
);
INSERT INTO medico (crm, nome, hospital_cnpj) VALUES
('553810', 'JOÃ0 DA SILVA','39159144000120'),
('121169', 'PEDRO PEREIRA','39159144000120');


CREATE TABLE especialidade (
    id serial primary key,
    nome text not null
);
INSERT INTO especialidade (nome) VALUES
('ORTOPEDIA'),
('OFTALMOLOGIA'),
('GERIATRIA'),
('CARDIOLOGIA'); 


CREATE TABLE medico_especialidade (
    medico_crm character(6) references medico (crm),
    especialidade_id integer references especialidade (id),
    primary key(medico_crm, especialidade_id)
);

INSERT INTO medico_especialidade (medico_crm, especialidade_id) VALUES
('553810',1),
('553810',4),
('121169',2);

CREATE TABLE paciente (
    cpf character(11) primary key,
    rg character varying(10),
    nome text not null,
    endereco text,
    telefone character(15),
    data_nascimento date
);

INSERT INTO paciente (cpf, nome) VALUES
('17658586072','FRANCISCO CUNHA'),
('09856787652', 'GERALDO OTAVIO');


CREATE TABLE consulta (
    id serial primary key,
    data date,
    hora time,
    diagnostico text,
    realizada boolean DEFAULT false,
    medico_crm character(6) references medico (crm),
    paciente_cpf character(11) references paciente (cpf)
);

INSERT INTO consulta (data, hora, diagnostico, medico_crm, paciente_cpf, realizada) VALUES
(CURRENT_DATE, CURRENT_TIME, 'vai morrer', '553810', '17658586072', TRUE),
('2022-09-15', '09:00:00', 'cuidado com o coração', '553810', '09856787652', FALSE);

CREATE TABLE exame (
    id serial primary key,
    data date,
    hora time,
    descricao text,
    laudo text,
    valor real,
    consulta_id integer references consulta (id)
);

INSERT INTO exame (descricao, data, valor, consulta_id) VALUES 
('EXAME1', '2013-01-01', 100, 1),
('EXAME2', '2013-02-02', 50, 1);

-- 17) hospitalbd=# SELECT exame.descricao FROM exame INNER JOIN consulta ON (exame.consulta_id = consulta.id) INNER JOIN paciente ON (consulta.paciente_cpf = paciente.cpf) WHERE paciente.nome = 'FRANCISCO CUNHA' aND EXTRACT(YEAR FROM exame.data) = 2013;

-- 18) hospitalbd=# SELECT medico.nome FROM medico INNER JOIN medico_especialidade ON (medico.crm = medico_especialidade.medico_crm) INNER JOIN especialidade ON(medico_especialidade.especialidade_id = especialidade.id) WHERE especialidade.nome = 'CARDIOLOGIA';

-- 19) hospitalbd=# SELECT medico.nome, count(exame.id) FROM medico INNER JOIN consulta ON (medico.crm = consulta.medico_crm) INNER JOIN exame ON (exame.consulta_id = consulta.id) WHERE EXTRACT(YEAR FROM exame.data) = 2013 GROUP BY medico.nome;

-- 20) hospitalbd=# select paciente.nome, sum(exame.valor) from paciente inner join consulta on (consulta.paciente_cpf = paciente.cpf) inner join exame on (consulta.id = exame.consulta_id) where extract(year from exame.data) = 2013 group by paciente.nome;

-- 21) hospitalbd=# select DISTINCT paciente.nome from paciente inner join consulta on (consulta.paciente_cpf = paciente.cpf) inner join exame on (exame.consulta_id = consulta.id) inner join medico on (medico.crm = consulta.medico_crm) where medico.nome = 'JOÃ0 DA SILVA';

-- 22) Quantidade de pacientes por especialidade
-- hospitalbd=# SELECT especialidade.nome, count(DISTINCT paciente.cpf) from especialidade inner join medico_especialidade on (especialidade.id = medico_especialidade.especialidade_id) inner join medico on (medico.crm = medico_especialidade.medico_crm) inner join consulta on (consulta.medico_crm = medico.crm) inner join paciente on (consulta.paciente_cpf = paciente.cpf)inner join exame on (consulta.id = exame.consulta_id) where extract(year from exame.data) = 2013 group by especialidade.nome;







