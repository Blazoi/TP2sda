-- ========================================================================
-- ⚠️ Exécuter chaque étape individuellement selon les instructions du TP
-- ⚠️ Ne pas exécuter ce script en entièreté
-- ========================================================================

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

create user hopital_schema_jad identified by oracle
   default tablespace users
   temporary tablespace temp;
grant connect,resource to hopital_schema_jad;
alter user hopital_schema_jad
   quota unlimited on users;


-- ============
-- 🧩 Étape 3
-- ============
-- Audits
create audit policy operations_patients_jad
   actions
      insert
   on hopital_schema_jad.patients_jad,
      update
   on hopital_schema_jad.patients_jad,
      delete
   on hopital_schema_jad.patients_jad;

audit policy operations_patients_jad;

create audit policy operations_consultations_jad
   actions
      insert
   on hopital_schema_jad.consultations_jad,
      update
   on hopital_schema_jad.consultations_jad,
      delete
   on hopital_schema_jad.consultations_jad;

audit policy operations_consultations_jad;

-- ============
-- 🧩 Étape 5
-- ============
-- Encryption
grant execute on dbms_crypto to hopital_schema_jad;

show con_name;