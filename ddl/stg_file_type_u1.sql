/*

    stg_file_type_c1.sql
    Create unizque constraint for stg_file_type table.sql

    Just a unique constraint, not a PK.
    
    Implementation
    ---------------

    psql -d barchart -f stg_file_type_u1.sql

*/

\echo DROP CONSTRINT - stg_file_type_u1
ALTER TABLE stg_file_type DROP CONSTRAINT stg_file_type_u1;

\echo --------------------------------------------
\echo CREATE CONSTRINT - stg_file_type_u1
ALTER TABLE stg_file_type ADD CONSTRAINT stg_file_type_u1 UNIQUE(csv_file);
 