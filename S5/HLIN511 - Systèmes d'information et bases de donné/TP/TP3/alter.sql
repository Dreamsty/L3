ALTER TABLE ABONNE ADD (
	DATE_NAI DATE,
	TYPE_AB VARCHAR(15) CHECK (TYPE_AB IN('ADULTE', 'ENFANT')),
	CAT_AB VARCHAR(15) CHECK (CAT_AB IN('REGULIER', 'OCCASIONNEL', 'A PROBLEME', 'EXCLU'))
);

prompt -- ALTER TABLE ABONNE;

UPDATE ABONNE
	SET DATE_NAI = SYSDATE - AGE*365;

UPDATE ABONNE
    SET TYPE_AB = 'ADULTE' WHERE AGE>=18; 

UPDATE ABONNE
    SET TYPE_AB = 'ENFANT' WHERE AGE<18;
    
prompt -- UPDATE TABLE ABONNE;
