-- Question 1
SELECT NOM, PRENOM 
FROM ABONNE 
WHERE VILLE='MONTPELLIER';

-- Question 2
SELECT * 
FROM EXEMPLAIRE 
WHERE CODE_PRET='EMPRUNTABLE';

-- Question 3
SELECT TITRE, CATEGORIE
FROM LIVRE
WHERE CATEGORIE <> 'MEDECINE'
AND CATEGORIE <> 'SCIENCES'
AND CATEGORIE <> 'LOISIRS'
ORDER BY CATEGORIE;

-- Question 4
SELECT *
FROM EMPRUNT
WHERE D_RET_REEL IS NULL;

-- Question 5
SELECT NUM_EX, D_EMPRUNT, NOM
FROM ABONNE, EMPRUNT
WHERE ABONNE.NUM_AB = EMPRUNT.NUM_AB 
AND NOM = 'DUPONT' 
AND PRENOM = 'JEAN'
ORDER BY D_EMPRUNT;

-- Question 6
SELECT NUMERO, CODE_PRET, ETAT
FROM EXEMPLAIRE, LIVRE
WHERE EXEMPLAIRE.ISBN = LIVRE.ISBN
AND TITRE='LE MUR';

-- Question 7
SELECT NUMERO
FROM EXEMPLAIRE
WHERE ETAT='BON'
AND NUMERO<>'4112'
AND ISBN=(
    SELECT ISBN
    FROM EXEMPLAIRE
    WHERE NUMERO = '4112'
);

-- Question 8 v1
SELECT ISBN
FROM LIVRE
WHERE NOT EXISTS (
    SELECT ISBN
    FROM EXEMPLAIRE
    WHERE LIVRE.ISBN = EXEMPLAIRE.ISBN
    );

-- Question 8 v2
SELECT ISBN
FROM LIVRE
WHERE ISBN NOT IN (
    SELECT ISBN
    FROM EXEMPLAIRE
    );

-- Question 9 v1
SELECT CATEGORIE
FROM LIVRE 
WHERE NOT EXISTS(
    SELECT CATEGORIE
    FROM LIVRE, EXEMPLAIRE, EMPRUNT
    WHERE LIVRE.ISBN = EXEMPLAIRE.ISBN
    AND NUMERO = NUM_EX
    );

-- Question 9 v2
SELECT CATEGORIE
FROM LIVRE
WHERE CATEGORIE NOT IN(
    SELECT CATEGORIE
    FROM EXEMPLAIRE,EMPRUNT
    WHERE NUMERO = NUM_EX
    );

-- Question 10
SELECT COUNT(*)
FROM ABONNE, EMPRUNT
WHERE EMPRUNT.NUM_AB = ABONNE.NUM_AB
AND D_RET_REEL IS NULL
AND NOM = 'RENARD'
AND PRENOM = 'ALBERT';

-- Question 11
SELECT MIN(TARIF * NVL(1-REDUC/100,1)) AS TARIF_MIN
FROM ABONNE;

-- Question 12
SELECT NUMERO
FROM EXEMPLAIRE, EMPRUNT
WHERE EXEMPLAIRE.NUMERO = EMPRUNT.NUM_EX
AND ETAT = 'ABIME'
AND D_RET_REEL IS NULL;

-- Question 13
SELECT MOT
FROM MOT_CLEF
WHERE MOT NOT IN (
    SELECT MOT
    FROM CARACTERISE
);

-- Question 14
SELECT NUMERO, NOM, CATEGORIE, COUNT(*)
FROM ABONNE, EMPRUNT, EXEMPLAIRE, LIVRE
WHERE ABONNE.NUM_AB = EMPRUNT.NUM_AB
AND EMPRUNT.NUM_EX = EXEMPLAIRE.NUMERO
AND EXEMPLAIRE.ISBN = LIVRE.ISBN
GROUP BY NUMERO, NOM, CATEGORIE;

-- Question 15
SELECT ISBN, COUNT(ISBN), AVG(PRIX)
FROM EXEMPLAIRE
GROUP BY ISBN
HAVING COUNT(ISBN)>2;

-- Question 16
SELECT ISBN, TITRE
FROM LIVRE L
WHERE L.ISBN <> '0_8_7707_2'
AND NOT EXISTS (
    SELECT *
    FROM CARACTERISE C1
    WHERE C1.ISBN = '0_8_7707_2'
    AND NOT EXISTS (
        SELECT *
        FROM CARACTERISE C2
        WHERE L.ISBN = C2.ISBN
        AND C1.MOT = C2.MOT
    )
);

-- Question 17
SELECT CATEGORIE
FROM LIVRE,EXEMPLAIRE
WHERE LIVRE.ISBN = EXEMPLAIRE.ISBN 
AND NOT EXISTS (
    SELECT *
    FROM ABONNE
    WHERE NOT EXISTS(
        SELECT *
        FROM EMPRUNT
        WHERE EMPRUNT.NUM_EX = EXEMPLAIRE.NUMERO
        AND ABONNE.NUM_AB = EMPRUNT.NUM_AB
    )
);