-- DATE: 2/12/2024
-- Creating A Working Procedure in SQL


-- RUBRIC --
/*
Write a procedure named proc_oddval(INTEGER, INTEGER, INTEGER, *INOUT* SMALLINT)
The first three are IN. The last is INOUT. (This is very common!)
It will test the first three parameters to see if two are equal to
each other and one is different. If so, return zero in the fourth parameter.
If any of the first three parameters are NULL, return 1 in the fourth parameter;
If all three are unique, return 2 in the fourth parameter;
if all three are equal, return 3 in the fourth parameter;
-- I am not telling you what to name the parameters.
-- Let's adopt that we will prepend: "parm_" (like my example.)
*/

/*
Your procedure does no output! If any of the first three parameters are NULL,
set the fourth parameter to one. If the first three are all unique, set it to
two. If all three are equal, set it to three... else, it's zero
*/

/*
Using the above criteria, below is a table of outcomes:
--------------------------------------------------
| parm_p1 | parm_p2 | parm_p3 | parm_p4 (returns) |
|---------|---------|---------|-------------------|
| equal   | equal   | diff.   | 0                 |
| equal   | diff.   | equal   | 0                 |
| diff.   | equal   | equal   | 0                 |
| ANYnull | ANYnull | ANYnull | 1                 |
| uniq    | uniq    | uniq    | 2                 |
| equal   | equal   | equal   | 3                 |
---------------------------------------------------
*/

-- Create and set schemata
CREATE SCHEMA IF NOT EXISTS oddval;
SET SEARCH_PATH TO oddval;

-- Drop proc_oddval procedure if it already exists
DROP PROCEDURE IF EXISTS proc_oddval;

-- Create procedure named proc_oddval(INTEGER, INTEGER, INTEGER, *INOUT* SMALLINT)
CREATE OR REPLACE PROCEDURE proc_oddval(
    IN parm_p1 INTEGER,
    IN parm_p2 INTEGER,
    IN parm_p3 INTEGER,
    OUT parm_errlvl SMALLINT
)
-- Specify language to PL/pgSQL
LANGUAGE plpgsql
-- Set execution privilege to script author
SECURITY DEFINER

-- Anonymous code block for procedure
AS $GO$
BEGIN
    -- Ladder logic
    IF parm_p1 IS NULL OR parm_p2 IS NULL OR parm_p3 IS NULL 
    THEN parm_errlvl := 1; -- 1 or more NULL
    ELSIF parm_p1 <> parm_p2 AND parm_p2 <> parm_p3 AND parm_p1 <> parm_p3 
        THEN parm_errlvl := 2; -- All 3 unique
        ELSIF parm_p1 = parm_p2 AND parm_p2 = parm_p3 
            THEN parm_errlvl := 3; -- All 3 equal
            ELSE parm_errlvl := 0; -- 2 equal, 1 different
    END IF;
END $GO$;

-- Consider a table:
DROP TABLE IF EXISTS tbl_values;

CREATE TABLE tbl_values (
    fld_id_pk INTEGER,
    fld_a INTEGER,
    fld_b INTEGER,
    fld_c INTEGER,
    CONSTRAINT values_pk PRIMARY KEY(fld_id_pk)
);

INSERT INTO tbl_values(fld_id_pk, fld_a, fld_b, fld_c)
VALUES 
    (1, 1, 1, 2),    -- 0
    (2, 1, 2, 1),    -- 0
    (3, -13, 101, -13),  -- 0
    (4, NULL, 1, 2),    -- 1
    (5, 1, 2, 3),    -- 2
    (6, 1, -13, 256),    -- 2
    (7, 1, 1, 1);    -- 3

-- Anonymous code block for output
DO $GO$
DECLARE
    lv_a INTEGER;
    lv_b INTEGER;
    lv_c INTEGER;
    lv_id INTEGER := 3; -- choose 1 .. 7
    lv_errlvl SMALLINT;
BEGIN
    SELECT fld_a, fld_b, fld_c INTO lv_a, lv_b, lv_c
    FROM tbl_values
    WHERE fld_id_pk = lv_id;
    
    CALL proc_oddval(lv_a, lv_b, lv_c, lv_errlvl);
    
    IF lv_errlvl = 3 THEN
        RAISE INFO E'\n\n%, %, % All Equal.\n\n', lv_a, lv_b, lv_c ;
    ELSIF lv_errlvl = 2 THEN
        RAISE INFO E'\n\n%, %, % All Different.\n\n', lv_a, lv_b, lv_c ;
    ELSIF lv_errlvl = 1 THEN
        RAISE INFO E'\n\n%, %, % NULL Parameter.\n\n', lv_a, lv_b, lv_c ;
    ELSE
        RAISE INFO E'\n\n%, %, % Valid Data.\n\n', lv_a, lv_b, lv_c ;
    END IF;
END $GO$;

-- Anonymous code block for output
DO $GO$
DECLARE
    lv_a INTEGER;
    lv_b INTEGER;
    lv_c INTEGER;
    lv_id INTEGER;
    lv_errlvl SMALLINT;
BEGIN
    FOR lv_id IN 1 .. 7 LOOP
        SELECT fld_a, fld_b, fld_c INTO lv_a, lv_b, lv_c
        FROM tbl_values
        WHERE fld_id_pk = lv_id;
        
        CALL proc_oddval(lv_a, lv_b, lv_c, lv_errlvl);
        
        IF lv_errlvl = 3 THEN
            RAISE INFO E'\n\n%, %, % All Equal.\n\n', lv_a, lv_b, lv_c ;
        ELSIF lv_errlvl = 2 THEN
            RAISE INFO E'\n\n%, %, % All Different.\n\n', lv_a, lv_b, lv_c ;
        ELSIF lv_errlvl = 1 THEN
            RAISE INFO E'\n\n%, %, % NULL Parameter.\n\n', lv_a, lv_b, lv_c ;
        ELSE
            RAISE INFO E'\n\n%, %, % Valid Data.\n\n', lv_a, lv_b, lv_c ;
        END IF;
    END LOOP;
END $GO$;

RESET SEARCH_PATH;
DROP SCHEMA oddval CASCADE;
