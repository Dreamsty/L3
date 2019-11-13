/*
Remaque : sans enregistrement et sans contraintes les lignes suivantes sont suffisantes : 
*/
DROP TABLE EMPRUNT; 
DROP TABLE CARACTERISE; 
DROP TABLE MOT_CLEF; 
DROP TABLE EXEMPLAIRE; 
DROP TABLE ABONNE;
DROP TABLE ECRIT;
DROP TABLE LIVRE; 
DROP TABLE AUTEUR;

prompt --**********************************--;
prompt -- CREATION DES RELATIONS-- ;
prompt --**********************************--;

CREATE TABLE LIVRE (
	ISBN VARCHAR(20), 
	TITRE VARCHAR(50) CONSTRAINT LITITRE NOT NULL, 
	SIECLE NUMERIC(2,0) CHECK (SIECLE BETWEEN 0 and 21),
	CATEGORIE VARCHAR(10),
	CONSTRAINT PK_LIVRE PRIMARY KEY (ISBN)
);

prompt -- LIVRE créé ;

CREATE TABLE ABONNE (
	NUM_AB  NUMERIC(6,0),  
	NOM VARCHAR(12)  CONSTRAINT ABNOM NOT NULL, 
	PRENOM VARCHAR(10), 
	VILLE VARCHAR(30), 
	AGE NUMERIC(3,0),
	TARIF NUMERIC(3,0),
	REDUC NUMERIC(3,0),
	CONSTRAINT PK_ABONNE PRIMARY KEY (NUM_AB),
	CONSTRAINT DOM_AGE CHECK (AGE BETWEEN 0 AND 120)
);

prompt -- ABONNE créé ;

CREATE TABLE EXEMPLAIRE (
	NUM_EX NUMERIC(4,0), 
	DATE_ACHAT DATE, 
	PRIX NUMERIC(5,2), 
	CODE_PRET VARCHAR(12) ,
	ETAT VARCHAR(15) CHECK (ETAT IN ('BON','ABIME','EN_REPARATION')), 
	ISBN  VARCHAR(20),
	CONSTRAINT PK_EXEMPLAIRE PRIMARY KEY (NUM_EX),
	CONSTRAINT DOM_CODE_PRET CHECK (CODE_PRET IN ('EXCLU','EMPRUNTABLE','CONSULTABLE')) 
);

prompt -- EXEMPLAIRE créé ;

CREATE TABLE MOT_CLEF (
	MOT VARCHAR(20),
	CONSTRAINT PK_ABONNE PRIMARY KEY (MOT)
);

prompt -- MOT_CLEF créé ;


ALTER TABLE MOT_CLEF ADD (
	PERE VARCHAR(20),
	CONSTRAINT FK_MOT_CLEF FOREIGN KEY (PERE) REFERENCES MOT_CLEF(MOT)
);

prompt -- ALTER TABLE MOT_CLEF;

CREATE TABLE EMPRUNT (
	NUM_AB  NUMERIC(6,0),
	NUM_EX NUMERIC (4,0) ,
	D_EMPRUNT DATE, 
	D_RETOUR DATE, 
	D_RET_REEL DATE, 
	NB_RELANCE NUMERIC(1,0) CHECK (NB_RELANCE IN (1,2,3)),
	CONSTRAINT FK_NUM_AB FOREIGN KEY (NUM_AB) REFERENCES ABONNE(NUM_AB),
	CONSTRAINT FK_NUM_EX FOREIGN KEY (NUM_EX) REFERENCES EXEMPLAIRE(NUM_EX)
);

prompt -- EMPRUNT créé ;

CREATE TABLE CARACTERISE (
	ISBN VARCHAR(20),
	MOT VARCHAR(20)
);

prompt -- CARACTERISE créé;

CREATE TABLE AUTEUR (
	IDA NUMERIC(3) PRIMARY KEY,
	NOM VARCHAR(20),
	PRENOM VARCHAR(20),
	NATIONALITE varchar(20)
);

prompt -- AUTEUR créé;

CREATE TABLE ECRIT (
	IDAUTEUR NUMERIC(3),
	ISBN VARCHAR(20),
	CONSTRAINT PK_AUTEUR PRIMARY KEY (IDAUTEUR, ISBN),
	CONSTRAINT FK1_ECRIT FOREIGN KEY (IDAUTEUR) REFERENCES AUTEUR(IDA),
	CONSTRAINT FK2_ECRIT FOREIGN KEY (ISBN) REFERENCES LIVRE(ISBN)
);

prompt -- ECRIT créé;