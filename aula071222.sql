DROP DATABASE IF EXISTS teste;

CREATE DATABASE teste;

\c teste;

CREATE TABLE aluno (
    id serial primary key,
    cpf character(11) unique,
    nome text
);

INSERT INTO aluno(cpf, nome) VALUES
('11111111111','igor'),
('22222222222','gabryel');

CREATE FUNCTION somar_tres_valores (v1 anyelement, v2 anyelement, v3 anyelement) RETURNS anyelement AS 
$$
BEGIN
    RETURN v1 + v2 + v3;
END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION sorteiaAluno() RETURNS RECORD AS
$$
DECLARE
    resultado RECORD;
BEGIN
    SELECT * FROM aluno ORDER BY RANDOM() LIMIT 1 INTO resultado;    
    RETURN resultado;
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION geradorDeAlunoGabryel() RETURNS VOID AS
$$
DECLARE
    vetNome text[];
    vetSobrenome text[];
    var_cpf character(11);
    var_nome text;
BEGIN
    vetNome[0] := 'Joao';
    vetSobrenome[0] := 'Pereira';
    vetNome[1] := 'Pedro';
    vetSobrenome[1] := 'Silva';
    vetNome[2] := 'Paulo';
    vetSobrenome[2] := 'Afonso';    
    var_nome := vetNome[floor(random() * 3)] || ' ' || vetSobrenome[floor(random() * 3)];  
     SELECT floor(random() * (11111111111-99999999999+1)+99999999999)::text INTO var_cpf;     
    INSERT INTO aluno (nome, cpf) VALUES(var_nome, var_cpf);
    EXCEPTION
        WHEN OTHERS THEN RAISE NOTICE 'Por uma baita sorte (sarcasmo) o cpf gerador ja foi gerado anteriormente';    
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION geradorDeAlunoEnquanto(vezes integer) RETURNS VOID AS
$$
DECLARE
    vetNome text[];
    vetSobrenome text[];
    var_cpf character(11);
    var_nome text;
    i integer;
BEGIN
    vetNome[0] := 'Joao';
    vetSobrenome[0] := 'Pereira';
    vetNome[1] := 'Pedro';
    vetSobrenome[1] := 'Silva';
    vetNome[2] := 'Paulo';
    vetSobrenome[2] := 'Afonso';    
    FOR i IN 1..vezes LOOP      
        var_nome := vetNome[floor(random() * 3)] || ' ' || vetSobrenome[floor(random() * 3)];  
         SELECT floor(random() * (11111111111-99999999999+1)+99999999999)::text INTO var_cpf;     
        INSERT INTO aluno (nome, cpf) VALUES(var_nome, var_cpf);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN RAISE NOTICE 'Por uma baita sorte (sarcasmo) o cpf gerador ja foi gerado anteriormente';        
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION geradorDeAlunoIgor() RETURNS VOID AS
$$
DECLARE
    vetNome text[];
    vetSobrenome text[];
    var_cpf character(11);
    var_nome text;
BEGIN
    vetNome[0] := 'Joao';
    vetSobrenome[0] := 'Pereira';
    vetNome[1] := 'Pedro';
    vetSobrenome[1] := 'Silva';
    vetNome[2] := 'Paulo';
    vetSobrenome[2] := 'Afonso';
    
    var_nome := vetNome[floor(random() * 3)] || ' ' || vetSobrenome[floor(random() * 3)];    
    SELECT floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text||floor(random() * 10)::text INTO var_cpf;    
    INSERT INTO aluno (nome, cpf) VALUES(var_nome, var_cpf);
    EXCEPTION
        WHEN OTHERS THEN RAISE NOTICE 'Por uma baita sorte (sarcasmo) o cpf gerador ja foi gerado anteriormente';    
END;
$$ LANGUAGE 'plpgsql';



-- SELECT somar_tres_valores (10, 20, 30); 
-- SELECT somar_tres_valores (1.1, 2.2, 3.3);

