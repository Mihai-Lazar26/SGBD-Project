CREATE TABLE ADRESE(
    adresa_id NUMBER(5),
    judet VARCHAR2(50) CONSTRAINT null_judet_adr not null,
    localitate VARCHAR2(50) CONSTRAINT null_localitate_adr not null,
    cod_postal VARCHAR2(6) CONSTRAINT null_cod_postal not null,
    strada VARCHAR2(50),
    CONSTRAINT pk_adr PRIMARY KEY(adresa_id),
    CONSTRAINT unq_adresa_adr UNIQUE(judet, localitate, cod_postal, strada),
    CONSTRAINT lungime_cod_postal_adr CHECK(LENGTH(cod_postal) = 6)
);

COMMIT;


CREATE TABLE FUNCTII(
    functie_id NUMBER(5),
    denumire VARCHAR2(30) CONSTRAINT null_denumire_fun not null,
    salariu_minim NUMBER(10, 2) CONSTRAINT null_salariu_min_fun not null,
    salariu_maxim NUMBER(10, 2) CONSTRAINT null_salariu_max_fun not null,
    CONSTRAINT pk_fun PRIMARY KEY(functie_id),
    CONSTRAINT salariu_min_max_logic CHECK(salariu_minim <= salariu_maxim),
    CONSTRAINT unq_denumire_fun UNIQUE(denumire),
    CONSTRAINT salariu_min_not_negative_fun CHECK(salariu_minim > 0)
);

COMMIT;



CREATE TABLE ANGAJATI(
    angajat_id NUMBER(5),
    nume VARCHAR2(25) CONSTRAINT null_nume_ang not null,
    prenume VARCHAR2(25) CONSTRAINT null_prenume_ang not null,
    cnp VARCHAR2(13) CONSTRAINT null_cnp_ang not null,
    telefon VARCHAR2(20) CONSTRAINT null_telefon_ang not null,
    email VARCHAR2(320) CONSTRAINT null_email_ang not null,
    salariu NUMBER(10,2) CONSTRAINT null_salariu_ang not null,
    data_angajare DATE DEFAULT sysdate,
    functie_id NUMBER(5) CONSTRAINT null_functie_ang not null,
    biblioteca_id NUMBER(5) CONSTRAINT null_biblioteca_ang not null,
    CONSTRAINT pk_ang PRIMARY KEY(angajat_id),
    CONSTRAINT fk_angajati_functii_ang FOREIGN KEY(functie_id) REFERENCES FUNCTII(functie_id) ON DELETE CASCADE,
    CONSTRAINT unq_cnp_ang UNIQUE(cnp),
    CONSTRAINT unq_telefon_ang UNIQUE(telefon),
    CONSTRAINT unq_email_ang UNIQUE(email),
    CONSTRAINT salariu_logic_ang CHECK(salariu > 0),
    CONSTRAINT lungime_telefon_ang CHECK(LENGTH(telefon) >= 10)
);

COMMIT;



CREATE TABLE BIBLIOTECI(
    biblioteca_id NUMBER(5),
    denumire VARCHAR2(30) CONSTRAINT null_denumire_bibl not null,
    telefon VARCHAR2(20) CONSTRAINT null_telefon_bibl not null,
    manager_id NUMBER(5),
    adresa_id NUMBER(5) CONSTRAINT null_adresa_bibl not null,
    CONSTRAINT pk_bibl PRIMARY KEY(biblioteca_id),
    CONSTRAINT fk_manager_biblioteca_bibl FOREIGN KEY(manager_id) REFERENCES ANGAJATI(angajat_id) ON DELETE SET NULL,
    CONSTRAINT fk_adresa_biblioteca_bibl FOREIGN KEY(adresa_id) REFERENCES ADRESE(adresa_id) ON DELETE CASCADE,
    CONSTRAINT unq_denumire_bibl UNIQUE(denumire),
    CONSTRAINT unq_telefon_bibl UNIQUE(telefon),
    CONSTRAINT unq_manager_bibl UNIQUE(manager_id),
    CONSTRAINT lungime_telefon_bibl CHECK(LENGTH(telefon) >= 10)
);

ALTER TABLE ANGAJATI
ADD CONSTRAINT fk_angajati_biblioteci_ang FOREIGN KEY(biblioteca_id) REFERENCES BIBLIOTECI(biblioteca_id) ON DELETE CASCADE;

COMMIT;


CREATE TABLE ADRESA_ANG(
    angajat_id NUMBER(5),
    adresa_id NUMBER(5),
    CONSTRAINT pk_adrang PRIMARY KEY(angajat_id, adresa_id),
    CONSTRAINT fk_angajat_adrang FOREIGN KEY(angajat_id) REFERENCES ANGAJATI(angajat_id) ON DELETE CASCADE,
    CONSTRAINT fk_adresa_adrang FOREIGN KEY(adresa_id) REFERENCES ADRESE(adresa_id) ON DELETE CASCADE
);
COMMIT;


CREATE TABLE AUTORI(
    autor_id NUMBER(5),
    nume VARCHAR2(25) CONSTRAINT null_nume_autor not null,
    prenume VARCHAR2(25) CONSTRAINT null_prenume_autor not null,
    CONSTRAINT pk_aut PRIMARY KEY(autor_id),
    CONSTRAINT unq_nume_prenume_autor UNIQUE(nume, prenume)
);

COMMIT;

CREATE TABLE EDITURI(
editura_id NUMBER(5), 
denumire VARCHAR2(30) CONSTRAINT null_denumire_edituri not null, 
telefon VARCHAR2(20) CONSTRAINT null_telefon_edituri not null,
email VARCHAR2(320) CONSTRAINT null_email_edituri not null, 
adresa_id NUMBER(5) CONSTRAINT null_adresa_edituri not null,
CONSTRAINT pk_edituri PRIMARY KEY(editura_id),
CONSTRAINT fk_adresa_edituri FOREIGN KEY(adresa_id) REFERENCES ADRESE(adresa_id) ON DELETE CASCADE,
CONSTRAINT unq_denumire_edituri UNIQUE(denumire),
CONSTRAINT unq_telefon_edituri UNIQUE(telefon),
CONSTRAINT unq_email_edituri UNIQUE(email),
CONSTRAINT lungime_telefon_edituri CHECK(LENGTH(telefon) >= 10)
);

COMMIT;



CREATE TABLE CARTI(
    carte_id NUMBER(5),
    titlu VARCHAR2(50) CONSTRAINT null_titlu_car not null,
    editura_id NUMBER(5) CONSTRAINT null_editura_car not null,
    an_aparitie NUMBER(5) CONSTRAINT null_an_car not null,
    autor_id NUMBER(5) CONSTRAINT null_autor_car not null,
    tip_carte VARCHAR2(25) CONSTRAINT null_tip_car not null,
    CONSTRAINT pk_car PRIMARY KEY(carte_id),
    CONSTRAINT fk_autor_carte_car FOREIGN KEY(autor_id) REFERENCES AUTORI(autor_id) ON DELETE CASCADE,
    CONSTRAINT fk_editura_carte_car FOREIGN KEY(editura_id) REFERENCES EDITURI(editura_id) ON DELETE CASCADE
);

COMMIT;

CREATE TABLE CITITORI(
    cititor_id NUMBER(5), 
    nume VARCHAR2(25) CONSTRAINT null_nume_cit not null, 
    prenume VARCHAR2(25) CONSTRAINT null_prenume_cit not null, 
    cnp VARCHAR2(13) CONSTRAINT null_cnp_cit not null, 
    telefon VARCHAR2(20) CONSTRAINT null_telefon_cit not null, 
    email VARCHAR2(320) CONSTRAINT null_email_cit not null,
    CONSTRAINT pk_cit PRIMARY KEY(cititor_id),
    CONSTRAINT unq_cnp_cit UNIQUE(cnp),
    CONSTRAINT unq_telefon_cit UNIQUE(telefon),
    CONSTRAINT unq_email_cit UNIQUE(email),
    CONSTRAINT lungime_telefon_cit CHECK(LENGTH(telefon) >= 10)
);

COMMIT;




CREATE TABLE ADRESA_CIT(
    cititor_id NUMBER(5),
    adresa_id NUMBER(5),
    CONSTRAINT pk_adrcit PRIMARY KEY(cititor_id, adresa_id),
    CONSTRAINT fk_cititor_adrcit FOREIGN KEY(cititor_id) REFERENCES CITITORI(cititor_id) ON DELETE CASCADE,
    CONSTRAINT fk_adresa_adrcit FOREIGN KEY(adresa_id) REFERENCES ADRESE(adresa_id) ON DELETE CASCADE
);


COMMIT;


CREATE TABLE PERMIS_DE_INTRARE(
permis_id NUMBER(5), 
anul_inscrieri NUMBER(5) DEFAULT TO_CHAR(sysdate, 'YYYY'), 
cititor_id NUMBER(5) CONSTRAINT null_cititor_permis not null, 
biblioteca_id NUMBER(5) CONSTRAINT null_biblioteca_permis not null,
CONSTRAINT pk_permis PRIMARY KEY(permis_id),
CONSTRAINT fk_cititor_permis FOREIGN KEY(cititor_id) REFERENCES CITITORI(cititor_id) ON DELETE CASCADE,
CONSTRAINT fk_biblioteca_permis FOREIGN KEY(biblioteca_id) REFERENCES BIBLIOTECI(biblioteca_id) ON DELETE CASCADE,
CONSTRAINT unq_biblioteca_cititor_permis UNIQUE(cititor_id, biblioteca_id)
);

COMMIT;


CREATE TABLE FISA_DE_LECTURA(
    fisa_id NUMBER(5), 
    cititor_id NUMBER(5) CONSTRAINT null_cititor_fisa not null, 
    carte_id NUMBER(5) CONSTRAINT null_carte_fisa not null,
    biblioteca_id NUMBER(5) CONSTRAINT null_biblioteca_fisa not null, 
    permis_id NUMBER(5) CONSTRAINT null_permis_fisa not null, 
    data_imprumut DATE DEFAULT sysdate, 
    data_restituire DATE DEFAULT sysdate,
    CONSTRAINT pk_fisa PRIMARY KEY(fisa_id),
    CONSTRAINT fk_cititor_fisa FOREIGN KEY(cititor_id) REFERENCES CITITORI(cititor_id) ON DELETE CASCADE,
    CONSTRAINT fk_carte_fisa FOREIGN KEY(carte_id) REFERENCES CARTI(carte_id) ON DELETE CASCADE,
    CONSTRAINT fk_biblioteca_fisa FOREIGN KEY(biblioteca_id) REFERENCES BIBLIOTECI(biblioteca_id) ON DELETE CASCADE,
    CONSTRAINT fk_permis_fisa FOREIGN KEY(permis_id) REFERENCES PERMIS_DE_INTRARE(permis_id) ON DELETE CASCADE,
    CONSTRAINT data_logic_fisa CHECK(data_imprumut <= data_restituire),
    CONSTRAINT unq_carte_data_imprumut_fisa UNIQUE(cititor_id, carte_id, data_imprumut)
);

COMMIT;



CREATE TABLE FURNIZORI(
furnizor_id NUMBER(5),
denumire VARCHAR2(30) CONSTRAINT null_denumire_furn not null,
telefon VARCHAR2(20) CONSTRAINT null_telefon_furn not null,
email VARCHAR2(320) CONSTRAINT null_email_furn not null,
adresa_id NUMBER(5) CONSTRAINT null_adresa_furn not null,
CONSTRAINT pk_furn PRIMARY KEY(furnizor_id),
CONSTRAINT fk_adresa_furn FOREIGN KEY(adresa_id) REFERENCES ADRESE(adresa_id) ON DELETE CASCADE,
CONSTRAINT unq_denumire_furn UNIQUE(denumire),
CONSTRAINT unq_telefon_furn UNIQUE(telefon),
CONSTRAINT unq_email_furn UNIQUE(email),
CONSTRAINT lungime_telefon_furn CHECK(LENGTH(telefon) >= 10)
);


COMMIT;





CREATE TABLE LUCREAZA(
editura_id NUMBER(5),
furnizor_id NUMBER(5),
CONSTRAINT pk_lucreaza PRIMARY KEY(editura_id, furnizor_id),
CONSTRAINT fk_editura_lucreaza FOREIGN KEY(editura_id) REFERENCES EDITURI(editura_id) ON DELETE CASCADE,
CONSTRAINT fk_furnizor_lucreaza FOREIGN KEY(furnizor_id) REFERENCES FURNIZORI(furnizor_id) ON DELETE CASCADE
);

COMMIT;

CREATE TABLE COMENZI(
comanda_id NUMBER(5),
furnizor_id NUMBER(5) CONSTRAINT null_furnizor_comenzi not null,
carte_id NUMBER(5) CONSTRAINT null_carte_comenzi not null,
biblioteca_id NUMBER(5) CONSTRAINT null_biblioteca_comenzi not null,
nr_exemplare NUMBER(10) CONSTRAINT null_nr_exemplare_comenzi not null,
pret_comanda NUMBER(10, 2) CONSTRAINT null_pret_comenzi not null,
CONSTRAINT pk_comenzi PRIMARY KEY(comanda_id),
CONSTRAINT fk_furnizor_comenzi FOREIGN KEY(furnizor_id) REFERENCES FURNIZORI(furnizor_id) ON DELETE CASCADE,
CONSTRAINT fk_carte_comenzi FOREIGN KEY(carte_id) REFERENCES CARTI(carte_id) ON DELETE CASCADE,
CONSTRAINT fk_biblioteca_comenzi FOREIGN KEY(biblioteca_id) REFERENCES BIBLIOTECI(biblioteca_id) ON DELETE CASCADE,
CONSTRAINT nr_exemplare_logic CHECK(nr_exemplare > 0),
CONSTRAINT pret_logic CHECK(pret_comanda >= 0)
);

COMMIT;

CREATE TABLE SUBTIPURI(
subtip_id NUMBER(5),
denumire VARCHAR2(30) CONSTRAINT null_denumire_subtipuri not null,
CONSTRAINT pk_subtipuri PRIMARY KEY(subtip_id),
CONSTRAINT unq_denumire_subtipuri UNIQUE(denumire)
);


COMMIT;


CREATE TABLE CATALOGARE(
carte_id NUMBER(5),
subtip_id NUMBER(5),
CONSTRAINT pk_catalog PRIMARY KEY(carte_id, subtip_id),
CONSTRAINT fk_carte_catalog FOREIGN KEY(carte_id) REFERENCES CARTI(carte_id) ON DELETE CASCADE,
CONSTRAINT fk_subtip_catalog FOREIGN KEY(subtip_id) REFERENCES SUBTIPURI(subtip_id) ON DELETE CASCADE
);

COMMIT;


CREATE SEQUENCE seq_adrese
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_angajati
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_autori
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_biblioteci
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_carti
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_cititori
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_comenzi
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_edituri
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_fisa_de_lectura
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_functii
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_furnizori
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_permis_de_intrare
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_subtipuri
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

COMMIT;


INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Alba', 'Sebe?', '515800', 'Bistrei');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Olt', 'Brastavă?u', '237045', 'Bujorului');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Cluj', 'Cluj-Napoca', '400417', 'Unirii');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Bihor', 'Oradea', '410087', 'Bacăului');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Sibiu', 'Turnu Ro?u', '557285', 'Olte?');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Dolj', 'Popoveni', '200003', 'Brăila');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Maramure?', 'Baia Mare', '430301', 'Vasile Alecsandri');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Gorj', 'Târgu Jiu', '210101', 'Aleea Livezi');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Satu Mare', 'Satu Mare', '440141', 'Dariu Pop');
INSERT INTO ADRESE(adresa_id, judet, localitate, cod_postal, strada)
VALUES (SEQ_ADRESE.nextval, 'Ia?i', 'Ia?i', '700341', 'Vasile Lupu');


COMMIT;




INSERT INTO FUNCTII(functie_id, denumire, salariu_minim, salariu_maxim)
VALUES (SEQ_FUNCTII.nextval, 'Bibliotecar', 6000, 12000);
INSERT INTO FUNCTII(functie_id, denumire, salariu_minim, salariu_maxim)
VALUES (SEQ_FUNCTII.nextval, 'Pază', 1000, 5000);
INSERT INTO FUNCTII(functie_id, denumire, salariu_minim, salariu_maxim)
VALUES (SEQ_FUNCTII.nextval, 'Catalogare', 3000, 9000);
INSERT INTO FUNCTII(functie_id, denumire, salariu_minim, salariu_maxim)
VALUES (SEQ_FUNCTII.nextval, 'Consilier', 4000, 10000);
INSERT INTO FUNCTII(functie_id, denumire, salariu_minim, salariu_maxim)
VALUES (SEQ_FUNCTII.nextval, 'Marketing', 6000, 8000);

COMMIT;



INSERT INTO BIBLIOTECI(biblioteca_id, denumire, telefon, manager_id, adresa_id)
VALUES (SEQ_BIBLIOTECI.nextval, 'Biblioteca Ro?ie', '0773.245.664', null, 5);
INSERT INTO BIBLIOTECI(biblioteca_id, denumire, telefon, manager_id, adresa_id)
VALUES (SEQ_BIBLIOTECI.nextval, 'Biblioteca De Aur', '0773.236.918', null, 9);
INSERT INTO BIBLIOTECI(biblioteca_id, denumire, telefon, manager_id, adresa_id)
VALUES (SEQ_BIBLIOTECI.nextval, 'Biblioteca Mihai Eminescu', '0772.019.467', null, 2);
INSERT INTO BIBLIOTECI(biblioteca_id, denumire, telefon, manager_id, adresa_id)
VALUES (SEQ_BIBLIOTECI.nextval, 'Biblioteca Bacovia', '0772.162.250', null, 4);
INSERT INTO BIBLIOTECI(biblioteca_id, denumire, telefon, manager_id, adresa_id)
VALUES (SEQ_BIBLIOTECI.nextval, 'Biblioteca Ion Creangă', '0772.309.337', null, 5);

COMMIT;

INSERT INTO ANGAJATI(angajat_id, nume, prenume, cnp, telefon, email,
salariu, data_angajare, functie_id, biblioteca_id)
VALUES (SEQ_ANGAJATI.nextval, 'Petran', 'Teodor', '2476281827462',
'0772.124.547', 'PetranTeodor@gmail.com', 10000, '27/01/1944', 1, 4);

INSERT INTO ANGAJATI(angajat_id, nume, prenume, cnp, telefon, email,
salariu, data_angajare, functie_id, biblioteca_id)
VALUES (SEQ_ANGAJATI.nextval, 'Funar', 'Ioan', '1277364727462',
'0772.754.124', 'IoanFunar@gmail.com', 7000, '20/09/1985', 4, 3);

INSERT INTO ANGAJATI(angajat_id, nume, prenume, cnp, telefon, email,
salariu, data_angajare, functie_id, biblioteca_id)
VALUES (SEQ_ANGAJATI.nextval, 'David', 'Alexandru', '1007264727890',
'0772.493.992', 'DavidAlexandru@gmail.com', 6500, '08/06/1999', 5, 5);

INSERT INTO ANGAJATI(angajat_id, nume, prenume, cnp, telefon, email,
salariu, data_angajare, functie_id, biblioteca_id)
VALUES (SEQ_ANGAJATI.nextval, 'Ungur', 'Lucia', '1009805727890',
'0772.586.021', 'UngurLucia@gmail.com', 6000, '07/12/1987', 3, 1);

INSERT INTO ANGAJATI(angajat_id, nume, prenume, cnp, telefon, email,
salariu, data_angajare, functie_id, biblioteca_id)
VALUES (SEQ_ANGAJATI.nextval, 'Cojocaru', 'Virgil', '9992264773829',
'0772.235.754', 'CojocaruVirgil@gmail.com', 2500, '10/05/1980', 2, 2);

COMMIT;

UPDATE biblioteci
SET manager_id = biblioteca_id
where MOD(biblioteca_id, 2) = 0;

COMMIT;


INSERT INTO CITITORI(cititor_id, nume, prenume, cnp, telefon, email)
VALUES (SEQ_CITITORI.nextval, 'Lupu', 'Ligia', '1234567890123', '0772.938.856',
'LigiaLupu@gmail.com');
INSERT INTO CITITORI(cititor_id, nume, prenume, cnp, telefon, email)
VALUES (SEQ_CITITORI.nextval, 'Văduva', 'Adela', '1234554390123', '0772.845.584',
'VaduvaAdela@gmail.com');
INSERT INTO CITITORI(cititor_id, nume, prenume, cnp, telefon, email)
VALUES (SEQ_CITITORI.nextval, 'Vasile', 'Dorian', '1784567890123', '0772.125.797',
'DorianVasile@gmail.com');
INSERT INTO CITITORI(cititor_id, nume, prenume, cnp, telefon, email)
VALUES (SEQ_CITITORI.nextval, 'Solomon', 'Ivan', '1237777790123', '0772.999.856',
'SolomonIvan@gmail.com');
INSERT INTO CITITORI(cititor_id, nume, prenume, cnp, telefon, email)
VALUES (SEQ_CITITORI.nextval, 'Vasile', 'Andrada', '1876567658423', '0772.788.100',
'AndradaVasile@gmail.com');

COMMIT;

INSERT INTO AUTORI(autor_id, nume, prenume)
VALUES(SEQ_AUTORI.nextval, 'Morris', 'Nikolina');
INSERT INTO AUTORI(autor_id, nume, prenume)
VALUES(SEQ_AUTORI.nextval, 'Tatham', 'Aishwarya');
INSERT INTO AUTORI(autor_id, nume, prenume)
VALUES(SEQ_AUTORI.nextval, 'Brambilla', 'Shprintze');
INSERT INTO AUTORI(autor_id, nume, prenume)
VALUES(SEQ_AUTORI.nextval, 'Zając', 'Hayder');
INSERT INTO AUTORI(autor_id, nume, prenume)
VALUES(SEQ_AUTORI.nextval, 'Modugno', 'Loukianos');

COMMIT;

INSERT INTO EDITURI(editura_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_EDITURI.nextval, 'Editura Roll', '0773.244.533', 'EdituraRoll@gmail.com', 5);
INSERT INTO EDITURI(editura_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_EDITURI.nextval, 'Editura Sketch', '0770.214.654', 'EdituraSketch@gmail.com', 1);
INSERT INTO EDITURI(editura_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_EDITURI.nextval, 'Editura Lot', '0770.252.647', 'EdituraLot@gmail.com', 2);
INSERT INTO EDITURI(editura_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_EDITURI.nextval, 'Editura Thesis', '0770.241.447', 'EdituraThesis@gmail.com', 6);
INSERT INTO EDITURI(editura_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_EDITURI.nextval, 'Editura Arena', '0774.123.347', 'EdituraArena@gmail.com', 10);

COMMIT;


INSERT INTO FURNIZORI(furnizor_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_FURNIZORI.nextval, 'Turkey Cucumber', '0774.004.122', 'TurkeyCucumber@gmail.com', 7);
INSERT INTO FURNIZORI(furnizor_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_FURNIZORI.nextval, 'Tradition Spill', '0774.353.689', 'TraditionSpill@gmail.com', 1);
INSERT INTO FURNIZORI(furnizor_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_FURNIZORI.nextval, 'Mobile Feather', '0774.121.224', 'MobileFeather@gmail.com', 2);
INSERT INTO FURNIZORI(furnizor_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_FURNIZORI.nextval, 'Gallery Lion', '0774.233.646', 'GalleryLion@gmail.com', 8);
INSERT INTO FURNIZORI(furnizor_id, denumire, telefon, email, adresa_id)
VALUES (SEQ_FURNIZORI.nextval, 'Gold Page', '0774.241.366', 'GoldPage@gmail.com', 5);

COMMIT;

INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Animale');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Matematcă');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Fizică');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Muzică');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Artă');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Informatică');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Horror');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Drama');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Ac?iune');
INSERT INTO SUBTIPURI(subtip_id, denumire)
VALUES (SEQ_SUBTIPURI.nextval, 'Poli?iste');

COMMIT;

INSERT INTO CARTI(carte_id, titlu, editura_id, an_aparitie, autor_id, tip_carte)
VALUES (SEQ_CARTI.nextval, 'Cunoscutul', 5, 1800, 2, '?tiin?ific');
INSERT INTO CARTI(carte_id, titlu, editura_id, an_aparitie, autor_id, tip_carte)
VALUES (SEQ_CARTI.nextval, 'Animale terestre', 1, 1950, 5, 'Pentru copii');
INSERT INTO CARTI(carte_id, titlu, editura_id, an_aparitie, autor_id, tip_carte)
VALUES (SEQ_CARTI.nextval, 'Aventurile lui Ro?u', 4, 1877, 3, 'Pove?ti');
INSERT INTO CARTI(carte_id, titlu, editura_id, an_aparitie, autor_id, tip_carte)
VALUES (SEQ_CARTI.nextval, 'Matematică pentru începători', 2, 2000, 1, '?tiin?ific');
INSERT INTO CARTI(carte_id, titlu, editura_id, an_aparitie, autor_id, tip_carte)
VALUES (SEQ_CARTI.nextval, 'Poeziile naturi', 3, 1899, 4, 'Poezii');

COMMIT;



INSERT INTO COMENZI(comanda_id, furnizor_id, carte_id, biblioteca_id, nr_exemplare, pret_comanda)
VALUES(SEQ_COMENZI.nextval, 4, 1, 3, 10, 500);
INSERT INTO COMENZI(comanda_id, furnizor_id, carte_id, biblioteca_id, nr_exemplare, pret_comanda)
VALUES(SEQ_COMENZI.nextval, 1, 4, 5, 25, 2000);
INSERT INTO COMENZI(comanda_id, furnizor_id, carte_id, biblioteca_id, nr_exemplare, pret_comanda)
VALUES(SEQ_COMENZI.nextval, 3, 2, 2, 20, 1500);
INSERT INTO COMENZI(comanda_id, furnizor_id, carte_id, biblioteca_id, nr_exemplare, pret_comanda)
VALUES(SEQ_COMENZI.nextval, 5, 3, 4, 15, 1800);
INSERT INTO COMENZI(comanda_id, furnizor_id, carte_id, biblioteca_id, nr_exemplare, pret_comanda)
VALUES(SEQ_COMENZI.nextval, 2, 5, 1, 30, 4000);

COMMIT;


INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2000, 1, 3);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2010, 2, 5);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2001, 5, 2);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2018, 3, 1);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 1990, 4, 4);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2011, 3, 5);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2007, 4, 3);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2021, 2, 2);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2014, 1, 4);
INSERT INTO PERMIS_DE_INTRARE(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
VALUES (SEQ_PERMIS_DE_INTRARE.nextval, 2009, 1, 5);

COMMIT;

INSERT INTO LUCREAZA(editura_id, furnizor_id)
VALUES(1, 2);
INSERT INTO LUCREAZA(editura_id, furnizor_id)
VALUES(4, 4);
INSERT INTO LUCREAZA(editura_id, furnizor_id)
VALUES(2, 3);
INSERT INTO LUCREAZA(editura_id, furnizor_id)
VALUES(5, 1);
INSERT INTO LUCREAZA(editura_id, furnizor_id)
VALUES(3, 5);

INSERT INTO LUCREAZA(editura_id, furnizor_id)
SELECT ca.editura_id, co.furnizor_id
FROM carti ca, comenzi co
WHERE ca.carte_id = co.carte_id
AND (ca.editura_id, co.furnizor_id) not in (
SELECT editura_id, furnizor_id
FROM lucreaza
);

COMMIT;


INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 1, 1, 3, 1, '10/05/1980', '30/05/1980');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 2, 2, 5, 4, '01/09/1990', '11/09/1990');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 3, 5, 2, 2, '05/11/2000', '15/11/2000');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 4, 3, 1, 5, '29/09/2005', '06/10/2005');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 5, 4, 4, 3, '03/01/2010', '13/01/2010');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 6, 3, 5, 4, '09/11/2008', '19/11/2008');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 7, 4, 3, 1, '5/11/2000', '5/11/2000');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 8, 2, 2, 2, '01/09/1990', '11/09/1990');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 9, 1, 4, 3, '29/09/2005', '06/10/2005');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(SEQ_FISA_DE_LECTURA.nextval, 10, 1, 5, 4, '10/05/1980', '30/05/1980');


COMMIT;



INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(1, 2);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(1, 3);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(2, 1);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(2, 5);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(2, 4);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(3, 7);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(3, 8);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(3, 9);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(3, 10);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(4, 2);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(5, 1);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(5, 5);
INSERT INTO CATALOGARE(carte_id, subtip_id)
VALUES(5, 4);

COMMIT;


INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(1, 4);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(1, 9);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(2, 10);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(2, 3);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(3, 6);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(3, 7);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(4, 9);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(4, 1);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(5, 10);
INSERT INTO ADRESA_ANG(angajat_id, adresa_id)
VALUES(5, 8);

COMMIT;

INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(1, 7);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(1, 10);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(2, 1);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(2, 4);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(3, 6);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(3, 3);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(4, 9);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(4, 1);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(5, 8);
INSERT INTO ADRESA_CIT(cititor_id, adresa_id)
VALUES(5, 2);

COMMIT;

/*6. Sa se afiseze date despre toti cititori care au citit un numar mai mare sau egal cu media aritmetica a cartilor
citite de fiecare cititor si sa li se creeze un permis de intrare pentru biblioteca care are cei mai putini cititori.
In caz ca sunt mai multe biblioteci cu acelasi numar minim de cititori sa se creeze permisuri doar pentru una dintre ele.
Daca un cititor are deja un permis de intrare la biblioteca respectiva acesta nu va primi unul nou.
*/

create or replace procedure ex6 as
    type cititori_type is table of cititori%rowtype;
    type biblioteci_type is table of biblioteci%rowtype index by pls_integer;
    t_cititori cititori_type := cititori_type();
    t_biblioteci biblioteci_type;
    nr number;
    rand_nr pls_integer;
    v_cititor cititori%rowtype;
    v_biblioteca biblioteci%rowtype;
    v_an number;
    v_exists number;
begin
    
    select c.*
    bulk collect into t_cititori
    from cititori c, (select c.cititor_id, count(*) nr_carti_citite
                    from cititori c, fisa_de_lectura fl
                    where c.cititor_id = fl.cititor_id
                    group by c.cititor_id
                    having count(*) >= (select avg(nr_carti_citite)
                                                from (select c.cititor_id, count(*) nr_carti_citite
                                                        from cititori c, fisa_de_lectura fl
                                                        where c.cititor_id = fl.cititor_id
                                                        group by c.cititor_id))) t
    where c.cititor_id = t.cititor_id
    order by 1;
    
    dbms_output.put_line('Cititori cautati sunt:');
    for i in t_cititori.first..t_cititori.last loop
        v_cititor := t_cititori(i);
        dbms_output.put_line(v_cititor.nume || ' ' || v_cititor.prenume || ' ' || v_cititor.cnp ||
        ' ' || v_cititor.telefon || ' ' || v_cititor.email);
    end loop;
    dbms_output.put_line('');
    
    select b.*
    bulk collect into t_biblioteci
    from biblioteci b, (select biblioteca_id, count(*) nr_cititori
                        from permis_de_intrare
                        group by biblioteca_id
                        having count(*) = (select min(count(*)) nr_cititori
                                            from permis_de_intrare
                                            group by biblioteca_id)) t
    where b.biblioteca_id = t.biblioteca_id
    order by 1;
    
    
    nr := t_biblioteci.last;
    select dbms_random.value(1,nr)
    into rand_nr
    from dual;
    
    v_biblioteca := t_biblioteci(rand_nr);
    dbms_output.put_line('Biblioteca aleasa pentru crearea permiselor este '||v_biblioteca.denumire);
    
    v_an := extract(year from sysdate);    

    for i in t_cititori.first..t_cititori.last loop
        v_cititor := t_cititori(i);
        
        select count(*)
        into v_exists
        from permis_de_intrare
        where cititor_id = v_cititor.cititor_id
        and biblioteca_id = v_biblioteca.biblioteca_id;
        
        if v_exists != 0 then 
            continue;
        end if;
        
        insert into permis_de_intrare(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
        values(seq_permis_de_intrare.nextval, v_an, v_cititor.cititor_id, v_biblioteca.biblioteca_id);
    end loop;

exception
    when others then
        dbms_output.put_line('Ceva nu a mers bine!');
end ex6;
/

begin
    ex6;
end;
/

/*7. Sa li se mareasca salariul cu 10% tuturor angajatilor care lucreaza in bibliotecile cu cel mai mare numar de cititori inscrisi.
Daca salariul angajatului depaseste salariul maxim functiei respective, salariul lui va ramane egal cu salariul maxim.
Sa se afiseze numarul maxim de cititori inscrisi si bibliotecile care au acest numar maxim de cititori.
*/

create or replace procedure ex7 as
    type bibl_and_count_record is record (v_biblioteca_id biblioteci.biblioteca_id%type, v_count number);
    type biblioteci_and_count is table of bibl_and_count_record
    index by pls_integer;
    
    cursor c_angajati (v_biblioteca_id angajati.biblioteca_id%type) is
    select * from angajati where biblioteca_id = v_biblioteca_id;
    
    t_biblioteci biblioteci_and_count;
    
    v_biblioteca_id biblioteci.biblioteca_id%type;
    v_functie_id functii.functie_id%type;
    max_sal functii.salariu_maxim%type;
    old_sal angajati.salariu%type;
    new_sal angajati.salariu%type;
    
    v_denumire biblioteci.denumire%type;
    
begin
    select biblioteca_id, count(cititor_id)
    bulk collect into t_biblioteci
    from permis_de_intrare
    group by biblioteca_id
    having count(cititor_id) = (select max(count(cititor_id))
                                from permis_de_intrare
                                group by biblioteca_id);
    
    dbms_output.put_line('Numarul maxim de cititori inscrisi intr-o biblioteca este '||t_biblioteci(1).v_count);    
    dbms_output.put_line('');
    
    dbms_output.put_line('Iar aceste biblioteci sunt:');
    
    for i in t_biblioteci.first..t_biblioteci.last loop
        v_biblioteca_id := t_biblioteci(i).v_biblioteca_id;
        
        select denumire into v_denumire from biblioteci where biblioteca_id = v_biblioteca_id;
        dbms_output.put_line(v_denumire);
        
        for v_ang in c_angajati(v_biblioteca_id) loop
        
            select functie_id, salariu
            into v_functie_id, old_sal
            from angajati
            where angajat_id = v_ang.angajat_id;
        
            select salariu_maxim
            into max_sal
            from functii
            where functie_id = v_functie_id;
            
            new_sal := old_sal * 1.1;
            
            if new_sal > max_sal then
                new_sal := max_sal;
            end if;
            
            update angajati
            set salariu = new_sal
            where angajat_id = v_ang.angajat_id;
        
        end loop;
    end loop;
exception
    when others then
        dbms_output.put_line('Ceva nu a mers bine!');
    
end ex7;
/

begin
    ex7;
end;
/

/*8. Scrieți o funcție care primește ca parametru un șir de caractere și returnează numărul de exemplare pentru cărțile 
care conțin șirul dat ca parametru. Afișează pe ecran titlul și autorul cărților respective.
*/

create or replace function ex8 (sir varchar2) return number as
    v_carte_id carti.carte_id%type;
    v_res number;
    v_sir varchar2(200);
begin
    v_sir := '%'||lower(sir)||'%';
    
    select carte_id
    into v_carte_id
    from carti
    where lower(titlu) like v_sir;
    
    for carte in (select ca.titlu, a.nume, a.prenume, sum(co.nr_exemplare) nr_exemplare
                    from carti ca, comenzi co, autori a
                    where ca.autor_id = a.autor_id
                    and ca.carte_id = co.carte_id
                    and ca.carte_id = v_carte_id
                    group by ca.titlu, a.nume, a.prenume) loop
        v_res := carte.nr_exemplare;
        dbms_output.put_line('Cartea care contine subsirul cautat este: ' || carte.titlu ||' Autorul: ' || carte.nume || ' '
        || carte.prenume);
    end loop;
    
    return v_res;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista carti care contin subsirul cautat');
        return 0;
    when too_many_rows then
        v_res := 0;
        dbms_output.put_line('Cartile care contin subsirul cautat sunt:');
        dbms_output.put_line('');
        for carte in (select ca.titlu, a.nume, a.prenume, sum(co.nr_exemplare) nr_exemplare
                        from carti ca, comenzi co, autori a
                        where ca.autor_id = a.autor_id
                        and ca.carte_id = co.carte_id
                        and lower(ca.titlu) like v_sir
                        group by ca.titlu, a.nume, a.prenume) loop
            v_res := v_res + carte.nr_exemplare;
            dbms_output.put_line(carte.titlu ||' Autorul: ' || carte.nume || ' ' || carte.prenume);
        end loop;
        return v_res;
    when others then
        dbms_output.put_line('Ceva nu a mers bine');
        return -1;
end;
/

declare
    nr number;
begin
    nr := ex8('a');
    dbms_output.put_line('');
    dbms_output.put_line('Numarul de exemplare returnat este '||nr);
end;
/

/*9. Scrieți o procedura care primește ca parametru un șir de caractere si pentru cartile care contin sirul de caractere
in titlul lor sa se afiseze:
*/

create or replace procedure ex9 (sir varchar2) as
    v_carte_id carti.carte_id%type;
    v_sir varchar2(200);
begin
    v_sir := '%'||lower(sir)||'%';
    
    select carte_id
    into v_carte_id
    from carti
    where lower(titlu) like v_sir;
    
    dbms_output.put_line('Istoricul carti cautate este: ');
    dbms_output.put_line('');
    for carte in (select distinct ca.titlu, a.nume nume_autor, a.prenume prenume_autor, 
                    b.denumire biblioteca, ci.nume cititor_nume, ci.prenume cititor_prenume
                    from carti ca, fisa_de_lectura fl, cititori ci, biblioteci b, autori a
                    where a.autor_id = ca.autor_id
                    and ca.carte_id = fl.carte_id
                    and fl.cititor_id = ci.cititor_id
                    and fl.biblioteca_id = b.biblioteca_id
                    and ca.carte_id = v_carte_id
                    order by 1) loop
        dbms_output.put_line(carte.titlu || ' scrisa de ' || carte.nume_autor || ' ' || carte.prenume_autor ||
        ' citita de ' || carte.cititor_nume || ' ' || carte.cititor_prenume || ' la biblioteca ' || carte.biblioteca);
    end loop;
    
exception
    when no_data_found then
        dbms_output.put_line('Nu exista carti care contin subsirul cautat');
    when too_many_rows then
        dbms_output.put_line('Istoricul cartilor cautate este:');
        dbms_output.put_line('');
        for carte in (select distinct ca.titlu, a.nume nume_autor, a.prenume prenume_autor, 
                    b.denumire biblioteca, ci.nume cititor_nume, ci.prenume cititor_prenume
                    from carti ca, fisa_de_lectura fl, cititori ci, biblioteci b, autori a
                    where a.autor_id = ca.autor_id
                    and ca.carte_id = fl.carte_id
                    and fl.cititor_id = ci.cititor_id
                    and fl.biblioteca_id = b.biblioteca_id
                    and lower(ca.titlu) like v_sir
                    order by 1) loop
        dbms_output.put_line(carte.titlu || ' scrisa de ' || carte.nume_autor || ' ' || carte.prenume_autor ||
        ' citita de ' || carte.cititor_nume || ' ' || carte.cititor_prenume || ' la biblioteca ' || carte.biblioteca);
    end loop;
    when others then
        dbms_output.put_line('Ceva nu a mers bine');
end;
/

begin
    ex9('a');
end;
/

/*10. Definiti un trigger de tip LMD la nivel de comanda care permite inserarea, actualizarea si stergerea datelor
din tabela fisa de lectrura doar in intervalul orar 9-20 si care contorizeaza numarul de actiuni insert, update si delete
facute.
*/

create or replace package contor_iud as
    nr_insert number := 0;
    nr_update number := 0;
    nr_delete number := 0;
end contor_iud;
/
create or replace trigger trig_fisa
    before insert or update or delete on fisa_de_lectura
begin
    if to_char(sysdate, 'HH24') not between 9 and 20 then
        raise_application_error(-20001, 'Operatile asupra tabelului sunt permise doar in intervalul 9-20');
    else
        if updating then
            contor_iud.nr_update := contor_iud.nr_update + 1;
        elsif inserting then
            contor_iud.nr_insert := contor_iud.nr_insert + 1;
        else
            contor_iud.nr_delete := contor_iud.nr_delete + 1;
        end if;
    end if;
end;
/

INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(11, 1, 1, 3, 1, '11/02/2000', '25/02/2000');
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(12, 4, 3, 1, 2, '01/04/2005', '15/04/2005');

update fisa_de_lectura
set data_restituire = sysdate
where fisa_id > 10;

delete from fisa_de_lectura
where fisa_id = 5;

delete from fisa_de_lectura
where fisa_id = 1;

delete from fisa_de_lectura
where fisa_id = 11;

begin
    dbms_output.put_line('Asupra tabelului fisa_de_lectura s-au efectuat:');
    dbms_output.put_line(contor_iud.nr_insert || ' actiuni insert');
    dbms_output.put_line(contor_iud.nr_update || ' actiuni update');
    dbms_output.put_line(contor_iud.nr_delete || ' actiuni delete');
end;
/

delete from fisa_de_lectura
where fisa_id = 1;

rollback;
/
/*11. Definiți un trigger LMD la nivel de linie care verifică corectitudinea datelor introduse în tabelul fisa_de_lectura.
*/

create or replace trigger trig_fisa2
    before insert or update on fisa_de_lectura
    for each row
declare
    v_permis_exists number;
    v_carte_exists number;
begin
    v_permis_exists := 0;
    v_carte_exists := 0;
    select count(*)
    into v_permis_exists
    from permis_de_intrare
    where permis_id = :new.permis_id
    and cititor_id = :new.cititor_id
    and biblioteca_id = :new.biblioteca_id;
    
    select count(*)
    into v_carte_exists
    from comenzi
    where carte_id = :new.carte_id
    and biblioteca_id = :new.biblioteca_id;
    
    if v_permis_exists = 0 or v_carte_exists = 0 then
        raise_application_error(-20001, 'Datele au fost introduse gresit');
    end if;
end;
/
rollback;
INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(11, 1, 1, 3, 1, '01/04/2005', '15/04/2005');

delete from fisa_de_lectura
where fisa_id = 11;

INSERT INTO FISA_DE_LECTURA
(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
data_imprumut, data_restituire)
VALUES(12, 4, 1, 3, 1, '01/04/2005', '15/04/2005');
/
/*12. Definiți un trigger de tip LDD care interzice acțiunile de tip LDD în a doua jumătate a zilei 
și memorează în tabelul istoric_LDD istoricul acțiunilor de tip LDD realizate.
*/
create table istoric_LDD(
    username varchar2(50),
    nume_bd varchar2(50),
    eveniment varchar2(50),
    nume_obiect varchar2(50),
    data TIMESTAMP
);

create or replace trigger trig_LDD
    before create or alter or drop on schema
begin
    if to_char(sysdate, 'HH24') >= 12 then
        raise_application_error(-20001, 'Nu sunt permise instructiuni de tip LDD dupa ora 12');
    else
        insert into istoric_LDD
        values (sys.login_user, sys.database_name, sys.sysevent, sys.dictionary_obj_name, sysdate);
    end if;
    
end;
/

drop trigger trig_LDD;

create table test(test number);
alter table test add test2 varchar2(20);
drop table test;





create table test2(test2 number);



--Ex 13:

create or replace package ex13 as
    procedure p_ex6;
    procedure p_ex7;
    function f_ex8 (sir varchar2) return number;
    procedure p_ex9 (sir varchar2);
end ex13;
/

create or replace package body ex13 as

procedure p_ex6 as
    type cititori_type is table of cititori%rowtype;
    type biblioteci_type is table of biblioteci%rowtype index by pls_integer;
    t_cititori cititori_type := cititori_type();
    t_biblioteci biblioteci_type;
    nr number;
    rand_nr pls_integer;
    v_cititor cititori%rowtype;
    v_biblioteca biblioteci%rowtype;
    v_an number;
    v_exists number;
begin
    
    select c.*
    bulk collect into t_cititori
    from cititori c, (select c.cititor_id, count(*) nr_carti_citite
                    from cititori c, fisa_de_lectura fl
                    where c.cititor_id = fl.cititor_id
                    group by c.cititor_id
                    having count(*) >= (select avg(nr_carti_citite)
                                                from (select c.cititor_id, count(*) nr_carti_citite
                                                        from cititori c, fisa_de_lectura fl
                                                        where c.cititor_id = fl.cititor_id
                                                        group by c.cititor_id))) t
    where c.cititor_id = t.cititor_id
    order by 1;
    
    dbms_output.put_line('Cititori cautati sunt:');
    for i in t_cititori.first..t_cititori.last loop
        v_cititor := t_cititori(i);
        dbms_output.put_line(v_cititor.nume || ' ' || v_cititor.prenume || ' ' || v_cititor.cnp ||
        ' ' || v_cititor.telefon || ' ' || v_cititor.email);
    end loop;
    dbms_output.put_line('');
    
    select b.*
    bulk collect into t_biblioteci
    from biblioteci b, (select biblioteca_id, count(*) nr_cititori
                        from permis_de_intrare
                        group by biblioteca_id
                        having count(*) = (select min(count(*)) nr_cititori
                                            from permis_de_intrare
                                            group by biblioteca_id)) t
    where b.biblioteca_id = t.biblioteca_id
    order by 1;
    
    
    nr := t_biblioteci.last;
    select dbms_random.value(1,nr)
    into rand_nr
    from dual;
    
    v_biblioteca := t_biblioteci(rand_nr);
    dbms_output.put_line('Biblioteca aleasa pentru crearea permiselor este '||v_biblioteca.denumire);
    
    v_an := extract(year from sysdate);    

    for i in t_cititori.first..t_cititori.last loop
        v_cititor := t_cititori(i);
        
        select count(*)
        into v_exists
        from permis_de_intrare
        where cititor_id = v_cititor.cititor_id
        and biblioteca_id = v_biblioteca.biblioteca_id;
        
        if v_exists != 0 then 
            continue;
        end if;
        
        insert into permis_de_intrare(permis_id, anul_inscrieri, cititor_id, biblioteca_id)
        values(seq_permis_de_intrare.nextval, v_an, v_cititor.cititor_id, v_biblioteca.biblioteca_id);
    end loop;

exception
    when others then
        dbms_output.put_line('Ceva nu a mers bine!');
end p_ex6;


procedure p_ex7 as
    type bibl_and_count_record is record (v_biblioteca_id biblioteci.biblioteca_id%type, v_count number);
    type biblioteci_and_count is table of bibl_and_count_record
    index by pls_integer;
    
    cursor c_angajati (v_biblioteca_id angajati.biblioteca_id%type) is
    select * from angajati where biblioteca_id = v_biblioteca_id;
    
    t_biblioteci biblioteci_and_count;
    
    v_biblioteca_id biblioteci.biblioteca_id%type;
    v_functie_id functii.functie_id%type;
    max_sal functii.salariu_maxim%type;
    old_sal angajati.salariu%type;
    new_sal angajati.salariu%type;
    
    v_denumire biblioteci.denumire%type;
    
begin
    select biblioteca_id, count(cititor_id)
    bulk collect into t_biblioteci
    from permis_de_intrare
    group by biblioteca_id
    having count(cititor_id) = (select max(count(cititor_id))
                                from permis_de_intrare
                                group by biblioteca_id);
    
    dbms_output.put_line('Numarul maxim de cititori inscrisi intr-o biblioteca este '||t_biblioteci(1).v_count);    
    dbms_output.put_line('');
    
    dbms_output.put_line('Iar aceste biblioteci sunt:');
    
    for i in t_biblioteci.first..t_biblioteci.last loop
        v_biblioteca_id := t_biblioteci(i).v_biblioteca_id;
        
        select denumire into v_denumire from biblioteci where biblioteca_id = v_biblioteca_id;
        dbms_output.put_line(v_denumire);
        
        for v_ang in c_angajati(v_biblioteca_id) loop
        
            select functie_id, salariu
            into v_functie_id, old_sal
            from angajati
            where angajat_id = v_ang.angajat_id;
        
            select salariu_maxim
            into max_sal
            from functii
            where functie_id = v_functie_id;
            
            new_sal := old_sal * 1.1;
            
            if new_sal > max_sal then
                new_sal := max_sal;
            end if;
            
            update angajati
            set salariu = new_sal
            where angajat_id = v_ang.angajat_id;
        
        end loop;
    end loop;
exception
    when others then
        dbms_output.put_line('Ceva nu a mers bine!');
    
end p_ex7;


function f_ex8 (sir varchar2) return number as
    v_carte_id carti.carte_id%type;
    v_res number;
    v_sir varchar2(200);
begin
    v_sir := '%'||lower(sir)||'%';
    
    select carte_id
    into v_carte_id
    from carti
    where lower(titlu) like v_sir;
    
    for carte in (select ca.titlu, a.nume, a.prenume, sum(co.nr_exemplare) nr_exemplare
                    from carti ca, comenzi co, autori a
                    where ca.autor_id = a.autor_id
                    and ca.carte_id = co.carte_id
                    and ca.carte_id = v_carte_id
                    group by ca.titlu, a.nume, a.prenume) loop
        v_res := carte.nr_exemplare;
        dbms_output.put_line('Cartea care contine subsirul cautat este: ' || carte.titlu ||' Autorul: ' || carte.nume || ' '
        || carte.prenume);
    end loop;
    
    return v_res;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista carti care contin subsirul cautat');
        return 0;
    when too_many_rows then
        v_res := 0;
        dbms_output.put_line('Cartile care contin subsirul cautat sunt:');
        dbms_output.put_line('');
        for carte in (select ca.titlu, a.nume, a.prenume, sum(co.nr_exemplare) nr_exemplare
                        from carti ca, comenzi co, autori a
                        where ca.autor_id = a.autor_id
                        and ca.carte_id = co.carte_id
                        and lower(ca.titlu) like v_sir
                        group by ca.titlu, a.nume, a.prenume) loop
            v_res := v_res + carte.nr_exemplare;
            dbms_output.put_line(carte.titlu ||' Autorul: ' || carte.nume || ' ' || carte.prenume);
        end loop;
        return v_res;
    when others then
        dbms_output.put_line('Ceva nu a mers bine');
        return -1;
end f_ex8;


procedure p_ex9 (sir varchar2) as
    v_carte_id carti.carte_id%type;
    v_sir varchar2(200);
begin
    v_sir := '%'||lower(sir)||'%';
    
    select carte_id
    into v_carte_id
    from carti
    where lower(titlu) like v_sir;
    
    dbms_output.put_line('Istoricul carti cautate este: ');
    dbms_output.put_line('');
    for carte in (select distinct ca.titlu, a.nume nume_autor, a.prenume prenume_autor, 
                    b.denumire biblioteca, ci.nume cititor_nume, ci.prenume cititor_prenume
                    from carti ca, fisa_de_lectura fl, cititori ci, biblioteci b, autori a
                    where a.autor_id = ca.autor_id
                    and ca.carte_id = fl.carte_id
                    and fl.cititor_id = ci.cititor_id
                    and fl.biblioteca_id = b.biblioteca_id
                    and ca.carte_id = v_carte_id
                    order by 1) loop
        dbms_output.put_line(carte.titlu || ' scrisa de ' || carte.nume_autor || ' ' || carte.prenume_autor ||
        ' citita de ' || carte.cititor_nume || ' ' || carte.cititor_prenume || ' la biblioteca ' || carte.biblioteca);
    end loop;
    
exception
    when no_data_found then
        dbms_output.put_line('Nu exista carti care contin subsirul cautat');
    when too_many_rows then
        dbms_output.put_line('Istoricul cartilor cautate este:');
        dbms_output.put_line('');
        for carte in (select distinct ca.titlu, a.nume nume_autor, a.prenume prenume_autor, 
                    b.denumire biblioteca, ci.nume cititor_nume, ci.prenume cititor_prenume
                    from carti ca, fisa_de_lectura fl, cititori ci, biblioteci b, autori a
                    where a.autor_id = ca.autor_id
                    and ca.carte_id = fl.carte_id
                    and fl.cititor_id = ci.cititor_id
                    and fl.biblioteca_id = b.biblioteca_id
                    and lower(ca.titlu) like v_sir
                    order by 1) loop
        dbms_output.put_line(carte.titlu || ' scrisa de ' || carte.nume_autor || ' ' || carte.prenume_autor ||
        ' citita de ' || carte.cititor_nume || ' ' || carte.cititor_prenume || ' la biblioteca ' || carte.biblioteca);
    end loop;
    when others then
        dbms_output.put_line('Ceva nu a mers bine');
end p_ex9;


end ex13;
/

execute ex13.p_ex9('ani');


--Ex 14:

create or replace package ex14 as

    cursor c_subtip (v_id carti.carte_id%type) return subtipuri%rowtype;

    function f_cititor_id (v_nume cititori.nume%type, v_prenume cititori.prenume%type)
    return number;
    
    function f_carte_id (v_titlu carti.titlu%type) return number;
    
    function f_biblioteca_id(v_denumire biblioteci.denumire%type) return number;
    
    function f_permis_id (v_cititor_id cititori.cititor_id%type, v_biblioteca_id biblioteci.biblioteca_id%type)
    return number;
    
    procedure p_insert_fisa (v_nume cititori.nume%type, v_prenume cititori.prenume%type, v_titlu carti.titlu%type,
                             v_biblioteca biblioteci.denumire%type);
    
    procedure p_afiseaza_carti(v_titlu carti.titlu%type);

end ex14;
/

create or replace package body ex14 as

    cursor c_subtip (v_id carti.carte_id%type) return subtipuri%rowtype is
    select s.*
    from subtipuri s, catalogare c
    where s.subtip_id = c.subtip_id
    and c.carte_id = v_id;

    function f_cititor_id (v_nume cititori.nume%type, v_prenume cititori.prenume%type)
    return number as
        v_id cititori.cititor_id%type;
        v_nume_aux varchar2(100);
        v_prenume_aux varchar2(100);
    begin 
        v_nume_aux := '%'||lower(v_nume)||'%';
        v_prenume_aux := '%'||lower(v_prenume)||'%';
        
        select cititor_id
        into v_id
        from cititori
        where lower(nume) like v_nume_aux
        and lower(prenume) like v_prenume_aux;
        
        return v_id;
    exception
        when no_data_found then
            raise_application_error(-20001, 'Nu exista cititori cu numele si prenumele dat!');
        when too_many_rows then
            raise_application_error(-20002, 'Exista mai multi cititori cu numele si prenumele dat!');
        when others then
            raise_application_error(-20003, 'Ceva nu a mers bine!');
    end f_cititor_id;
    
    
    function f_carte_id (v_titlu carti.titlu%type) return number as
        v_id carti.carte_id%type;
        v_titlu_aux varchar2(100);
    begin
        v_titlu_aux := '%'||lower(v_titlu)||'%';
        
        select carte_id into v_id
        from carti
        where lower(titlu) like v_titlu_aux;
        
        return v_id;
    exception
        when no_data_found then
            raise_application_error(-20001, 'Nu exista carti cu titlul dat!');
        when too_many_rows then
            raise_application_error(-20002, 'Exista mai multe carti cu titlul dat!');
        when others then
            raise_application_error(-20003, 'Ceva nu a mers bine!');
    end f_carte_id;
    
    
    function f_biblioteca_id(v_denumire biblioteci.denumire%type) return number as
        v_id biblioteci.biblioteca_id%type;
        v_denumire_aux varchar2(100);
    begin
    
        v_denumire_aux := '%'||lower(v_denumire)||'%';
        
        select biblioteca_id into v_id
        from biblioteci
        where lower(denumire) like v_denumire_aux;
        
        return v_id;
    exception
        when no_data_found then
            raise_application_error(-20001, 'Nu exista biblioteci cu denumirea data!');
        when too_many_rows then
            raise_application_error(-20002, 'Exista mai multe biblioteci cu denumirea data!');
        when others then
            raise_application_error(-20003, 'Ceva nu a mers bine!');
    end f_biblioteca_id;
    
    function f_permis_id (v_cititor_id cititori.cititor_id%type, v_biblioteca_id biblioteci.biblioteca_id%type)
    return number as
        v_id permis_de_intrare.permis_id%type;
    begin
        select permis_id
        into v_id
        from permis_de_intrare
        where cititor_id = v_cititor_id
        and biblioteca_id = v_biblioteca_id;
        
        return v_id;
    exception
        when no_data_found then
            raise_application_error(-20001, 'Nu exista permisul cautat!');
        when others then
            raise_application_error(-20003, 'Ceva nu a mers bine!');
    end f_permis_id;
    
    procedure p_insert_fisa (v_nume cititori.nume%type, v_prenume cititori.prenume%type, v_titlu carti.titlu%type,
                             v_biblioteca biblioteci.denumire%type) as
        v_cititor_id cititori.cititor_id%type;
        v_carte_id carti.carte_id%type;
        v_biblioteca_id biblioteci.biblioteca_id%type;
        v_permis_id permis_de_intrare.permis_id%type;
        v_data_imprumut date;
        v_data_restituire date;
    begin
        v_cititor_id := f_cititor_id(v_nume, v_prenume);
        v_carte_id := f_carte_id(v_titlu);
        v_biblioteca_id := f_biblioteca_id(v_biblioteca);
        v_permis_id := f_permis_id(v_cititor_id, v_biblioteca_id);
        
        v_data_imprumut := sysdate;
        v_data_restituire := v_data_imprumut + interval '14' day;
        
        insert into fisa_de_lectura(fisa_id, permis_id, cititor_id, biblioteca_id, carte_id, 
                                    data_imprumut, data_restituire)
        values(seq_fisa_de_lectura.nextval, v_permis_id, v_cititor_id, v_biblioteca_id, v_carte_id,
               v_data_imprumut, v_data_restituire);
    end p_insert_fisa;
    
    procedure p_afiseaza_carti(v_titlu carti.titlu%type) as
        type carti_type is table of carti%rowtype index by pls_integer;
        type carte_autor_editura is record(editura edituri.denumire%type, nume_autor autori.nume%type,
                                           prenume_autor autori.prenume%type);
        t_carti carti_type;
        v_titlu_aux varchar2(100);
        v_carte carti%rowtype;
        v_cae carte_autor_editura;
    begin
        v_titlu_aux := '%' || lower(v_titlu) || '%';
    
        select * 
        bulk collect into t_carti
        from carti
        where lower(titlu) like v_titlu_aux;
        
        if t_carti.count = 0 then
            raise no_data_found;
        end if;
        
        for i in t_carti.first..t_carti.last loop
            v_carte := t_carti(i);
            select e.denumire, a.nume, a.prenume
            into v_cae
            from carti c, autori a, edituri e
            where c.autor_id = a.autor_id
            and c.editura_id = e.editura_id
            and c.carte_id = v_carte.carte_id;
            
            dbms_output.put_line('Titlul: ' || v_carte.titlu);
            dbms_output.put_line('Editura: ' || v_cae.editura);
            dbms_output.put_line('An aparitie: '||v_carte.an_aparitie);
            dbms_output.put_line('Autorul: '||v_cae.nume_autor||' '||v_cae.prenume_autor);
            dbms_output.put_line('Tipul: '||v_carte.tip_carte);
            dbms_output.put('Subtipurile: ');
            
            for subtip in c_subtip(v_carte.carte_id) loop
                dbms_output.put(subtip.denumire||' ');
            end loop;
            dbms_output.new_line;
            dbms_output.put_line('');
        end loop;
    exception
        when no_data_found then
            dbms_output.put_line('Nu am gasit carti');
        when others then
            dbms_output.put_line('Ceva nu a mers bine');
    end p_afiseaza_carti;
    
end ex14;
/

execute ex14.p_insert_fisa('a', 'a', 'Cunoscutul', 'Biblioteca Mihai Eminescu');

execute ex14.p_insert_fisa('Lupu', 'Ligia', 'a', 'Biblioteca Mihai Eminescu');


execute ex14.p_insert_fisa('Lupu', 'Ligia', 'Cunoscutul', 'a');


execute ex14.p_insert_fisa('Lupu', 'Ligia', 'Cunoscutul', 'Biblioteca Roșie');

execute ex14.p_insert_fisa('Lupu', 'Ligia', 'Cunoscutul', 'Biblioteca Bacovia');


execute ex14.p_insert_fisa('Lupu', 'Ligia', 'Cunoscutul', 'Biblioteca Mihai Eminescu');

execute ex14.p_afiseaza_carti('x');

execute ex14.p_afiseaza_carti('le');

rollback;
