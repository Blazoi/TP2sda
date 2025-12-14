-- ============
-- 🧩 Étape 1
-- ============
-- Setup
alter session set container = cdb$root;

create pluggable database hopital_db_jad
   admin user hopital_admin_jad identified by oracle
      file_name_convert = ( '/opt/oracle/oradata/FREE/pdbseed','/opt/oracle/oradata/FREE/hopital_db_jad' );
alter pluggable database hopital_db_jad open;

alter session set container = hopital_db_jad;
-- Créer le tablespace USERS au besoin
create tablespace users
   datafile '/opt/oracle/oradata/FREE/hopital_db_jad/users01.dbf' size 100M
   autoextend on next 10M maxsize unlimited;

-- Créer le schéma
create user hopital_schema_jad identified by oracle
   default tablespace users
   temporary tablespace temp;
-- Privilèges
grant connect, resource to hopital_schema_jad;
alter user hopital_schema_jad
   quota unlimited on users;

-- ===============
-- 🧩 Partie 2
-- Dans le schéma hopital_schema_jad
-- ===============

-- ===========================
-- 🧩 Création des tables
-- ===========================
create table patients_jad (
   patient_id     number(6) primary key,
   nom            varchar2(30) not null,
   prenom         varchar2(30) not null,
   sexe           char(1) check ( sexe in ( 'M',
                                  'F' ) ) not null,
   date_naissance date,
   adresse        varchar2(100),
   num_secu       varchar2(20) unique,
   diagnostic     varchar2(4000),
   traitement     varchar2(4000)
);
create table medecins_jad (
   medecin_id number(6) primary key,
   nom        varchar2(30) not null,
   specialite varchar2(50),
   email      varchar2(100) unique
);
create table consultations_jad (
   consultation_id   number(6) primary key,
   patient_id        number(6),
   medecin_id        number(6),
   date_consultation date default sysdate,
   rapport           varchar2(4000),
   cout              number(8,2),
   constraint fk_patient foreign key ( patient_id )
      references patients_jad ( patient_id )
         on delete cascade,
   constraint fk_medecin foreign key ( medecin_id )
      references medecins_jad ( medecin_id )
         on delete cascade
);

-- ===========================
-- 🧩 Peuplement des tables
-- ===========================
insert into patients_jad (
   patient_id,
   nom,
   prenom,
   sexe,
   date_naissance,
   adresse,
   num_secu,
   diagnostic,
   traitement
) values ( 101,
           'Dupont',
           'Marie',
           'F',
           to_date('1988-05-14','YYYY-MM-DD'),
           '123 Rue des Fleurs, Montréal',
           'QC19880514',
           'Grippe saisonnière',
           'Repos et paracétamol' );

insert into patients_jad (
   patient_id,
   nom,
   prenom,
   sexe,
   date_naissance,
   adresse,
   num_secu,
   diagnostic,
   traitement
) values ( 102,
           'Nguyen',
           'Alex',
           'M',
           to_date('1995-09-30','YYYY-MM-DD'),
           '456 Avenue du Parc, Laval',
           'QC19950930',
           'Hypertension',
           'Régime alimentaire + suivi' );

insert into patients_jad (
   patient_id,
   nom,
   prenom,
   sexe,
   date_naissance,
   adresse,
   num_secu,
   diagnostic,
   traitement
) values ( 103,
           'Smith',
           'Emma',
           'F',
           to_date('1979-02-10','YYYY-MM-DD'),
           '789 Boulevard Saint-Laurent, Montréal',
           'QC19790210',
           'Diabète de type 2',
           'Metformine 500mg/jour' );

insert into patients_jad (
   patient_id,
   nom,
   prenom,
   sexe,
   date_naissance,
   adresse,
   num_secu,
   diagnostic,
   traitement
) values ( 104,
           'Benali',
           'Karim',
           'M',
           to_date('2001-11-22','YYYY-MM-DD'),
           '22 Rue Sherbrooke, Longueuil',
           'QC20011122',
           'Allergie saisonnière',
           'Antihistaminiques' );



insert into medecins_jad (
   medecin_id,
   nom,
   specialite,
   email
) values ( 201,
           'Tremblay',
           'Généraliste',
           'tremblay.medecin@hopital.ca' );

insert into medecins_jad (
   medecin_id,
   nom,
   specialite,
   email
) values ( 202,
           'Gauthier',
           'Cardiologue',
           'gauthier.cardio@hopital.ca' );

insert into medecins_jad (
   medecin_id,
   nom,
   specialite,
   email
) values ( 203,
           'Lefebvre',
           'Endocrinologue',
           'lefebvre.endo@hopital.ca' );

insert into medecins_jad (
   medecin_id,
   nom,
   specialite,
   email
) values ( 204,
           'Dubois',
           'Allergologue',
           'dubois.allergie@hopital.ca' );

 
insert into consultations_jad (
   consultation_id,
   patient_id,
   medecin_id,
   date_consultation,
   rapport,
   cout
) values ( 301,
           101,
           201,
           to_date('2025-10-01','YYYY-MM-DD'),
           'Consultation pour fièvre persistante',
           80.00 );

insert into consultations_jad (
   consultation_id,
   patient_id,
   medecin_id,
   date_consultation,
   rapport,
   cout
) values ( 302,
           102,
           202,
           to_date('2025-10-05','YYYY-MM-DD'),
           'Suivi tension artérielle',
           120.00 );

insert into consultations_jad (
   consultation_id,
   patient_id,
   medecin_id,
   date_consultation,
   rapport,
   cout
) values ( 303,
           103,
           203,
           to_date('2025-10-10','YYYY-MM-DD'),
           'Réglage posologie du traitement diabétique',
           150.00 );

insert into consultations_jad (
   consultation_id,
   patient_id,
   medecin_id,
   date_consultation,
   rapport,
   cout
) values ( 304,
           104,
           204,
           to_date('2025-10-20','YYYY-MM-DD'),
           'Consultation allergie automnale',
           95.00 );

commit;

-- ===========
-- 🧩 Partie 3
-- Avec SYS
-- ===========

-- =============================
-- 🧩 Configuration de l'audit
-- =============================

-- Activation de l'audit global
alter system set audit_trail = db scope = spfile;

-- Auditer les connexions échouées et réussies
audit connect;

-- Auditer l'attribution de privilèges et rôles
audit privilege;

-- Auditer la table patients
create audit policy operations_patients_jad
	actions insert, update, delete
    on hopital_schema_jad.patients_jad;
audit policy operations_patients_jad;

-- Auditer la table consultations
create audit policy operations_consultations_jad
	actions insert, update, delete on hopital_schema_jad.consultations_jad;
audit policy operations_consultations_jad;

-- ===============
-- 🧩 Partie 4
-- ===============

-- =============================
-- Table d’audit personnalisée
-- =============================
create table audit_action_jad (
   audit_id    number generated by default as identity primary key,
   username    varchar2(30),
   action      varchar2(100),
   objet       varchar2(1000),
   date_action timestamp default systimestamp
);


-- Trigger d’audit sur la table Patients
create or replace trigger trigger_modif_patients_jad before
   insert or update or delete on patients_jad
   for each row
declare
   v_user varchar2(100);
begin
   v_user := sys_context(
      'userenv',
      'session_user'
   );
   if inserting then
      insert into audit_action_jad (
         username,
         action,
         objet,
         date_action
      ) values ( v_user,
                 'INSERT ',
                 'id : '
                 || :new.patient_id
                 || ', nom : '
                 || :new.nom
                 || ', prenom : '
                 || :new.prenom
                 || ', sexe : '
                 || :new.sexe
                 || ', date_naissance : '
                 || :new.date_naissance
                 || ', adresse : '
                 || :new.adresse
                 || ', num_secu : '
                 || :new.num_secu
                 || ', diagnostic : '
                 || :new.diagnostic
                 || ', traitement : '
                 || :new.traitement,
                 current_timestamp );
   elsif updating then
      insert into audit_action_jad (
         username,
         action,
         objet,
         date_action
      ) values ( v_user,
      'UPDATE ',
      'id : '
      || :old.patient_id
      || ' -> '
      || :new.patient_id
      || ', nom : '
      || :old.nom
      || ' -> '
      || :new.nom
      || ', prenom : '
      || :old.prenom
      || ' -> '
      || :new.prenom
      || ', sexe : '
      || :old.sexe
      || ' -> '
      || :new.sexe
      || ', date_naissance : '
      || :old.date_naissance
      || ' -> '
      || :new.date_naissance
      || ', adresse : '
      || :old.adresse
      || ' -> '
      || :new.adresse
      || ', num_secu : '
      || :old.num_secu
      || ' -> '
      || :new.num_secu
      || ', diagnostic : '
      || :old.diagnostic
      || ' -> '
      || :new.diagnostic
      || ', traitement : '
      || :old.traitement
      || ' -> '
      || :new.traitement,
      current_timestamp );
   elsif deleting then
      insert into audit_action_jad (
         username,
         action,
         objet,
         date_action
      ) values ( v_user,
      'DELETE ',
      'id : '
      || :old.patient_id
      || ', nom : '
      || :old.nom
      || ', prenom  :'
      || :old.prenom
      || ', sexe : '
      || :old.sexe
      || ', date_naissance : '
      || :old.date_naissance
      || ', adresse : '
      || :old.adresse
      || ', num_secu : '
      || :old.num_secu
      || ', diagnostic : '
      || :old.diagnostic
      || ', traitement : '
      || :old.traitement,
      current_timestamp );
   end if;
end;
/
-- ==============================
-- ✅ Validation des insertions
-- ==============================

-- Vérification rapide || :
select *
  from patients_jad;
select *
  from medecins_jad;
select *
  from consultations_jad;