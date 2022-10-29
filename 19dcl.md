# DCL

DCL é formado por um grupo de comandos SQL, responsáveis pela administração dos usuários, dos grupos e das permissões.

De fora do psql (no prompt) utiliza-se comandos sem espaço:

createdb, dropdb, etc.

De dentro do psql os comandos são formados por duas palavras:

CREATE DATABASE, DROP DATABASE, etc (sintaxe SQL).

De dentro do psql:

CREATE USER é agora um alias para CREATE ROLE, que tem mais recursos.

```
banco=# \h create role
```

Comando: CREATE ROLE

Descrição: define um novo papel (role) do banco de dados

**Sintaxe:**
```
CREATE ROLE nome [ [ WITH ] opção [ ... ] ]
```

onde opção pode ser:
    ```SUPERUSER | NOSUPERUSER```
   ```| CREATEDB | NOCREATEDB```
   ```| CREATEROLE | NOCREATEROLE```
   ```| CREATEUSER | NOCREATEUSER```
   ```| INHERIT | NOINHERIT```
   ```| LOGIN | NOLOGIN```
   ```| CONNECTION LIMIT limite_con```
   ```| [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'senha'```
   ```| VALID UNTIL 'tempo_absoluto'```
   ```| IN ROLE nome_role [, ...]```
   ```| IN GROUP nome_role [, ...]```
   ```| ROLE nome_role [, ...]```
   ```| ADMIN nome_role [, ...]```
   ```| USER nome_role [, ...]```
   ```| SYSID uid```

**Criar Usuário**

```CREATE ROLE nomeusuario;```

Nas versões anteriores usava-se o parâmetro “CREATEUSER” para indicar a criação de um superusuário, agora usa-se o parâmetro mais adequado SUPERUSER.


Para poder criar um novo usuário local, com senha, devemos setar antes o pg_hba.conf:

local all all 127.0.0.1/32 password

Comentar as outras entradas para conexão local.

Isso para usuário local (conexão via socket UNIX).

Criamos assim:

```CREATE ROLE nomeuser WITH ENCRYPTED PASSWORD '********';```

Ao se logar: psql -U nomeuser nomebanco.

```CREATE ROLE nomeusuario VALID UNTIL 'data'```

**Excluindo Usuário**

```DROP USER nomeusuario;```

Como usuário, fora do psql:

**Criar Usuário**

```CREATEROLE nomeusuario;```

**Excluindo Usuário**

```DROPUSER nomeusuario;```

Detalhe: sem espaços.

**Criando Superusuário**

```CREATE ROLE nomeuser WITH SUPERUSER ENCRYPTED PASSWORD '<password>';```

Obs: usuário com poderes de super usuário

**Alterar Conta de Usuário**

```ALTER ROLE nomeuser ENCRYPTED PASSWORD '<password>' CREATEUSER```

-- permissão de criar usuários

```ALTER ROLE nomeuser VALID UNTIL '12/05/2006';```

```ALTER ROLE fred VALID UNTIL ’infinity’;```

```ALTER ROLE miriam CREATEROLE CREATEDB; -- poderes para criar bancos```

Obs.: Lembrando que ALTER ROLE é uma extensão do PostgreSQL.

**Listando todos os usuários:**

```SELECT usename FROM pg_user;```

A tabela pg_user é uma tabela de sistema (_pg) que guarda todos os usuários do PostgreSQL.

Também podemos utilizar:

```\du``` ou ```\dg```


**Criando Um Grupo de usuários**

```CREATE GROUP nomedogrupo;```

**Adicionar/Remover Usuários de um Grupo**

```ALTER GROUP nomegrupo ADD USER user1, user2,user3;```

```ALTER GROUP nomegrupo DROP USER user1, user2 ;```


**Excluindo Grupo**

```DROP GROUP nomegrupo;```

Obs.: isso remove somente o grupo, não remove os usuários.

**Listando todos os grupos:**

```SELECT groname FROM pg_group;```


**Privilégios**

**Dando Privilégios A Um Usuário**

```GRANT UPDATE ON nometabela TO nomeusuario;```


**Dando Privilégios A Um Grupo Inteiro**

```GRANT SELECT ON nometabela TO nomegrupo;```

**Removendo Todos os Privilégios de Todos os Users**

```REVOKE ALL ON nometabela FROM PUBLIC```


**Privilégios**

O superusuário tem direito a fazer o que bem entender em qualquer banco de dados do SGBD.

O usuário que cria um objeto (banco, tabela, view, etc) é o dono do objeto.

Para que outro usuário tenha acesso ao mesmo deve receber privilégios.

Existem vários privilégios diferentes: SELECT, INSERT, UPDATE, DELETE, RULE, REFERENCES, TRIGGER, CREATE, TEMPORARY, EXECUTE e USAGE.

Os privilégios aplicáveis a um determinado tipo de objeto variam de acordo com o tipo do objeto (tabela, função, etc.).

O comando para conceder privilégios é o GRANT. O de remover é o REVOKE.

```GRANT UPDATE ON contas TO joel;```

Dá a joel o privilégio de executar consultas update no objeto contas.

```GRANT SELECT ON contas TO GROUP contabilidade;```

```REVOKE ALL ON contas FROM PUBLIC;```


Os privilégios especiais do dono da tabela (ou seja, os direitos de DROP, GRANT, REVOKE, etc.) são sempre inerentes à condição de ser o dono, não podendo ser concedidos ou revogados. Porém, o dono do objeto pode decidir revogar seus próprios privilégios comuns como, por exemplo, tornar a tabela somente para leitura para o próprio, assim como para os outros.

Normalmente, só o dono do objeto (ou um superusuário) pode conceder ou revogar privilégios para um objeto.


**Criação dos grupos**

```CREATE GROUP adm;```
```CREATE USER paulo ENCRYPTED PASSWORD 'paulo' CREATEDB CREATEUSER;```


**Criação dos Usuários do Grupo *adm***
```CREATE USER andre ENCRYPTED PASSWORD 'andre' CREATEDB IN GROUP adm;```
```CREATE USER michela ENCRYPTED PASSWORD 'michela' CREATEDB IN GROUP adm;```

O usuário de sistema (super usuário) deve ser um usuário criado exclusivamente para o PostgreSQL. Nunca devemos torná-lo dono de nenhum executável.

Os nomes de usuários são globais para todo o agrupamento de bancos de dados, ou seja, podemos utilizar um usuário com qualquer dos bancos.

Os privilégios DROP, GRANT, REVOKE, etc pertencem ao dono do objeto não podendo ser concedidos ou revogados. O máximo que um dono pode fazer é abdicar de seus privilégios e com isso ninguém mais teria os mesmos e o objeto seria somente leitura para todos.

Exemplo: para permitir a um usuário apenas os privilégios de INSERT, UPDATE e SELECT e não permitir o de DELETE em uma tabela, use:

```REVOKE ALL ON tabela FROM usuario;```
```GRANT SELECT,UPDATE,INSERT ON tabela TO usuario;```

**Mais detalhes:**

[wikibooks.org](https://pt.wikibooks.org/wiki/PostgreSQL_Pr%C3%A1tico/DCL/Administra%C3%A7%C3%A3o_de_usu%C3%A1rios,_grupos_e_privil%C3%A9gios)

https://www.devmedia.com.br/gerenciando-usuarios-e-permissoes-no-postgresql/14301

http://pgdocptbr.sourceforge.net/pg80/user-manag.html

http://pgdocptbr.sourceforge.net/pg80/sql-revoke.html

http://pgdocptbr.sourceforge.net/pg80/sql-grant.html

