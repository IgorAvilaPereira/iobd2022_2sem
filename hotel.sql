DROP DATABASE IF EXISTS hotel;

CREATE DATABASE hotel;

\c hotel;

-- tabelas
CREATE TABLE cliente (
     rg NUMERIC NOT NULL,
     nome VARCHAR(40) NOT NULL,
     sexo CHAR(1) NOT NULL,
     telefone NUMERIC(10,0),
     PRIMARY KEY (rg)
  );

  CREATE TABLE tipo_quarto
  (
     id_tipo SERIAL NOT NULL,
     descricao VARCHAR(40) NOT NULL,
     valor NUMERIC(9,2) NOT NULL,
     PRIMARY KEY (id_tipo)
  );

  CREATE TABLE quarto  (
     num_quarto INTEGER NOT NULL,
     andar CHAR(10),
     id_tipo INTEGER NOT NULL,
     status CHAR(01) NOT NULL DEFAULT 'D',
     PRIMARY KEY (num_quarto),
     FOREIGN KEY (id_tipo) REFERENCES tipo_quarto (id_tipo)
     ON UPDATE RESTRICT ON DELETE RESTRICT
  );

  CREATE TABLE servico (
     id_servico SERIAL NOT NULL,
     descricao VARCHAR(60) NOT NULL,
     valor NUMERIC(9,2) NOT NULL,
     PRIMARY KEY (id_servico)
  );

  CREATE TABLE reserva (
  id_reserva SERIAL NOT NULL,
  rg NUMERIC NOT NULL,
  num_quarto INTEGER NOT NULL,
  dt_reserva DATE NOT NULL,
  qtd_dias INTEGER NOT NULL,
  data_entrada DATE NOT NULL,
       status CHAR(1) NOT NULL DEFAULT 'A',
   PRIMARY KEY (id_reserva),
   FOREIGN KEY (rg) REFERENCES cliente (rg)
   ON UPDATE RESTRICT ON DELETE RESTRICT,
   FOREIGN KEY (num_quarto) REFERENCES quarto (num_quarto)
   ON UPDATE RESTRICT ON DELETE RESTRICT
  ) ;

  CREATE TABLE hospedagem
  (
       id_hospedagem SERIAL NOT NULL,
       rg NUMERIC NOT NULL,
       num_quarto INTEGER NOT NULL,
       data_entrada DATE NOT NULL,
       data_saida DATE,
       status CHAR(1) NOT NULL,
   PRIMARY KEY (id_hospedagem),
   FOREIGN KEY (rg) REFERENCES cliente (rg)
   ON UPDATE RESTRICT ON DELETE RESTRICT,
   FOREIGN KEY (num_quarto) REFERENCES quarto (num_quarto)
   ON UPDATE RESTRICT ON DELETE RESTRICT
  ) ;

  CREATE TABLE atendimento
  (
       id_atendimento SERIAL NOT NULL,
       id_servico INTEGER NOT NULL,
       id_hospedagem INTEGER NOT NULL,
   PRIMARY KEY (id_atendimento),
   FOREIGN KEY (id_servico) REFERENCES servico (id_servico)
   ON UPDATE RESTRICT ON DELETE RESTRICT,
   FOREIGN KEY (id_hospedagem) REFERENCES hospedagem (id_hospedagem)
   ON UPDATE RESTRICT ON DELETE RESTRICT
  ) ;
  
  -- stored procedure1
  CREATE OR REPLACE FUNCTION adicionaHospedagem(rg_cliente numeric, numero_quarto int) RETURNS void AS
  $
    begin
      perform * from cliente where rg = rg_cliente;
      if found then
        perform * from quarto where upper(status) = 'D' and num_quarto = numero_quarto;
        if found then
          insert into hospedagem values (default, rg_cliente, numero_quarto, current_date, null, 'A');
          update quarto set status = 'O' where num_quarto = numero_quarto;
          RAISE NOTICE 'Hospedagem realizada com sucesso!';
        else
          RAISE EXCEPTION 'Quarto indisponivel para hospedagem!';
        end if;
      else
        RAISE EXCEPTION 'Cliente nao consta no cadastro!';
      end if;
    end;
  $
  LANGUAGE plpgsql SECURITY DEFINER;
  
  -- stored procedure2
  CREATE OR REPLACE FUNCTION adicionaReserva(rg_cliente numeric, numero_quarto int, dias int, data_entrada date) RETURNS void AS
  $
    begin
      perform * from cliente where rg = rg_cliente;
      if found then
        perform * from quarto where upper(status) = 'D' and num_quarto = numero_quarto;
        if found then
          insert into reserva values (default, rg_cliente, numero_quarto, current_date, dias, data_entrada, 'A');
          update quarto set status = 'R' where num_quarto = numero_quarto;
          RAISE NOTICE 'Reserva realizada com sucesso!';
        else
          RAISE EXCEPTION 'Quarto indisponivel para reserva!';
        end if;
      else
        RAISE EXCEPTION 'Cliente nao consta no cadastro!';
      end if;
    end;
  $
  LANGUAGE plpgsql SECURITY DEFINER;
  
  -- stored procedure3
  CREATE OR REPLACE FUNCTION realizaPedido(hosp int, serv int) RETURNS void AS
  $
    begin
      perform * from hospedagem where upper(status) = 'A' and id_hospedagem = hosp;
      if found then
        perform * from servico where id_servico = serv;
        if found then
          insert into atendimento values (default, serv, hosp);
          RAISE NOTICE 'Pedido realizado com sucesso!';
        else
          RAISE EXCEPTION 'Servico indisponivel!';
        end if;
      else
        RAISE EXCEPTION 'Hospedagem nao consta no cadastro ou ja foi desativada!';
      end if;
    end;
  $
  LANGUAGE plpgsql SECURITY DEFINER;
  
  -- view
  CREATE VIEW listaClientes (nome_cliente,sexo) AS
  SELECT nome, sexo FROM cliente;
  
  -- grupos 
  CREATE ROLE gerente;
  CREATE ROLE atendente;
  CREATE ROLE estagiario;
  
  -- removendo permissoes dos stored procedure
  REVOKE ALL ON FUNCTION adicionaReserva(numeric,int,int,date) FROM PUBLIC;
  REVOKE ALL ON FUNCTION adicionaHospedagem(numeric,int) FROM PUBLIC;
  REVOKE ALL ON FUNCTION realizaPedido(int,int) FROM PUBLIC;
  
  
  -- dando permissao para gerente
  GRANT SELECT, INSERT ON cliente, reserva, hospedagem, quarto, tipo_quarto, atendimento, servico, listaClientes TO gerente WITH GRANT OPTION;
  
  GRANT EXECUTE ON FUNCTION adicionaHospedagem(numeric,int) TO gerente;

GRANT EXECUTE ON FUNCTION adicionaReserva(numeric,int,int,date) TO gerente;


GRANT EXECUTE ON FUNCTION realizaPedido(int,int) TO gerente;

GRANT SELECT ON listaClientes TO gerente;


-- dando permissao para atendente
GRANT EXECUTE ON FUNCTION adicionaHospedagem(numeric,int) TO atendente;
GRANT EXECUTE ON FUNCTION adicionaReserva(numeric,int,int,date) TO atendente;
GRANT EXECUTE ON FUNCTION
  realizaPedido(int,int) TO atendente;
  
  -- permissao para estagiario
  GRANT SELECT ON listaClientes TO estagiario;

-- criando usuarios e colocando em seus grupos
CREATE ROLE tony LOGIN PASSWORD '111' IN ROLE gerente;
CREATE ROLE maria LOGIN PASSWORD '222' IN ROLE atendente;
CREATE ROLE vitoria LOGIN PASSWORD '333' IN ROLE estagiario;




  
  
