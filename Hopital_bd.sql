-- -- ** UTILISATEUR SYS ** --
-- -- Se placer dans le conteneur racine
-- alter session set container = cdb$root;
-- -- Créer la base de données hopital_db
-- create pluggable database hopital_db
--    admin user hopital_admin identified by oracle
--       file_name_convert = ( '/opt/oracle/oradata/FREE/pdbseed/','/opt/oracle/oradata/FREE/hopital_db/' );

-- -- Ouvrir la base de données
-- alter session set container = hopital_db;
-- alter pluggable database hopital_db open;

-- -- Créer l'utilisateur hopital_schema
-- create user hopital_schema identified by oracle;
-- grant connect,resource to hopital_schema;
-- alter user hopital_schema quota unlimited on users;


-- -- ** UTILISATEUR HOPITAL_SCHEMA ** --
-- Créer les tables

create table patients (
   patient_id number primary key,
   nom        varchar2(100) not null,
   prenom     varchar2(100) not null,
    -- Cette ligne s'assure que le sexe est soit 'M' pour masculin, soit 'F' pour féminin
   sexe       char(1) check ( sexe in ( 'M',
                                  'F' ) ) not null
);

create table medecins (
   medecin_id number primary key,
   nom        varchar2(100) not null,
   prenom     varchar2(100) not null,
   specialite varchar2(100) not null
);

create table consultations (
   consultation_id   number primary key,
    -- ON DELETE CASCADE pour éviter les problèmes lors des tests de suppression
    -- La consultation sera supprimée si le patient ou le médecin associé est supprimé
   patient_id        number
      references patients ( patient_id )
         on delete cascade,
   medecin_id        number
      references medecins ( medecin_id )
         on delete cascade,
   date_consultation date not null
);

-- Insérer des patients
insert into patients (
   patient_id,
   nom,
   prenom,
   sexe
) values ( 1,
           'Dupont',
           'Jean',
           'M' );
insert into patients (
   patient_id,
   nom,
   prenom,
   sexe
) values ( 2,
           'Martin',
           'Sophie',
           'F' );
insert into patients (
   patient_id,
   nom,
   prenom,
   sexe
) values ( 3,
           'Bernard',
           'Luc',
           'M' );
insert into patients (
   patient_id,
   nom,
   prenom,
   sexe
) values ( 4,
           'Petit',
           'Emma',
           'F' );

-- Insérer des médecins
insert into medecins (
   medecin_id,
   nom,
   prenom,
   specialite
) values ( 1,
           'Durand',
           'Pierre',
           'Cardiologie' );
insert into medecins (
   medecin_id,
   nom,
   prenom,
   specialite
) values ( 2,
           'Lefevre',
           'Marie',
           'Pédiatrie' );
insert into medecins (
   medecin_id,
   nom,
   prenom,
   specialite
) values ( 3,
           'Moreau',
           'Jacques',
           'Dermatologie' );
insert into medecins (
   medecin_id,
   nom,
   prenom,
   specialite
) values ( 4,
           'Simon',
           'Isabelle',
           'Neurologie' );

-- Insérer des consultations
insert into consultations (
   consultation_id,
   patient_id,
   medecin_id,
   date_consultation
) values ( 1,
           1,
           1,
           to_date('2024-01-01','YYYY-MM-DD') );
insert into consultations (
   consultation_id,
   patient_id,
   medecin_id,
   date_consultation
) values ( 2,
           2,
           2,
           to_date('2024-02-02','YYYY-MM-DD') );
insert into consultations (
   consultation_id,
   patient_id,
   medecin_id,
   date_consultation
) values ( 3,
           3,
           3,
           to_date('2024-03-03','YYYY-MM-DD') );
insert into consultations (
   consultation_id,
   patient_id,
   medecin_id,
   date_consultation
) values ( 4,
           4,
           4,
           to_date('2024-04-04','YYYY-MM-DD') );

commit;