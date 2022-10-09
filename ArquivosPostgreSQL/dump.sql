DROP DATABASE IF EXISTS teste;

CREATE DATABASE teste;

\c teste;

CREATE TABLE images (
    imgname text, 
    img bytea,
    imgoid oid
); 

-- [bytea] Para o insert funcionar o arquivo tem que estar no tmp (se não dá erro de permissão)
-- teste=# INSERT INTO images (imgname, img) values ('agoravai20', pg_read_binary_file('/tmp/teste.png'));

-- [oid==very large file] Para o insert funcionar o arquivo tem que estar no tmp (se não dá erro de permissão)
-- teste=# INSERT INTO images (imgname, imgoid) values ('agoravai', lo_import('/tmp/ksnip_20221008-171938.png'));
-- Extras:
-- teste=# select lo_get(imgoid) from images where imgname = '/tmp/ksnip_20221008-171938.png';


