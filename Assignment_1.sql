    -- COURSE: CSCE 4355.400
    -- NAME: Chimara Okeke
    -- EUID: ceo0079
    
    
    CREATE SCHEMA IF NOT EXISTS rps;
    SET SEARCH_PATH TO rps;

-- Drop tables from the parent up
    DROP TABLE IF EXISTS tbl_rounds; -- grandchild
    DROP TABLE IF EXISTS tbl_games; -- child
    DROP TABLE IF EXISTS tbl_players;  -- ultimate parent

-- Dropping tbl_errata can happen in any order
    DROP TABLE IF EXISTS tbl_errata; -- no keys


-- Create tables from the parent down

    CREATE TABLE tbl_errata
        (
            fld_err_doc    TIMESTAMP DEFAULT NOW(),
            fld_sqlstate CHAR(5), 
            fld_sqlerrm  TEXT
        );

    CREATE TABLE tbl_players
    (
        fld_p_id_pk     CHAR(16), -- user ID that shall be required and unique
        fld_p_doc       DATE    DEFAULT NOW(), --  date of creation (doc)
       --
        CONSTRAINT players_pk PRIMARY KEY(fld_p_id_pk)
    );

    CREATE TABLE tbl_games
    (
        fld_g_id_pk     BIGINT, -- required and unique integer 
        fld_g_doc       DATE    DEFAULT NOW(), --  date of creation (doc)
        fld_g_P1_id_fk  CHAR(16) , -- foreign key 1 from players table
        fld_g_P2_id_fk  CHAR(16), -- foreign key 2 from players table
        --
        CONSTRAINT games_pk PRIMARY KEY(fld_g_id_pk),
        CONSTRAINT unique_players_pair UNIQUE(fld_g_P1_id_fk, fld_g_P2_id_fk),
        CONSTRAINT check_players_order CHECK(fld_g_P1_id_fk < fld_g_P2_id_fk),
        -- Foreign key constraints:
        CONSTRAINT fk_games_player1 FOREIGN KEY (fld_g_P1_id_fk) REFERENCES tbl_players(fld_p_id_pk),
        CONSTRAINT fk_games_player2 FOREIGN KEY (fld_g_P2_id_fk) REFERENCES tbl_players(fld_p_id_pk),
        CONSTRAINT null_player CHECK (fld_g_P1_id_fk IS NOT NULL AND  fld_g_P2_id_fk IS NOT NULL)
    );

    CREATE TABLE tbl_rounds
    (
        fld_r_id_pk     BIGINT, -- unique & required BIGINT 
        fld_g_id_fk     BIGINT, -- a required game ID referencing the games table
        fld_r_doc       DATE, --  date of creation (doc)
        fld_r_p1token   CHAR(1), --  game tokens that must be 'R', 'P', or 'S' exclusively... (means NOT NULL).
        fld_r_p2token   CHAR(1), --  game tokens that must be 'R', 'P', or 'S' exclusively... (means NOT NULL).
        --
        CONSTRAINT rounds_pk PRIMARY KEY(fld_r_id_pk),
        CONSTRAINT valid_tokens CHECK( fld_r_p1token IN ('R', 'P', 'S') AND fld_r_p2token IN ('R', 'P', 'S') ),
        -- NOT NULL Constraints
        CONSTRAINT tokens_not_null CHECK (fld_r_p1token IS NOT NULL AND fld_r_p2token IS NOT NULL),
        CONSTRAINT child_no_orphans CHECK(fld_g_id_fk IS NOT NULL),
        CONSTRAINT rounds_fk FOREIGN KEY (fld_g_id_fk) REFERENCES tbl_games(fld_g_id_pk)
    );
   

-- TESTING TRANSACTION BLOCKS --
DO $outside$
BEGIN 
    DO $in_1$
    BEGIN
    --
     CREATE TABLE tbl_players
    (
        fld_p_id_pk     CHAR(16), -- user ID that shall be required and unique
        fld_p_doc       DATE    DEFAULT NOW(), --  date of creation (doc)
       --
        CONSTRAINT players_pk PRIMARY KEY(fld_p_id_pk)
    );

    EXCEPTION   
        WHEN OTHERS THEN 
            -- RAISE EXCEPTION USING 'Block 1 (players) failed' USING ERRCODE = 'P0030'; 
            -- 'P' followed by 4 digits is a user-defined error code
            -- Uncomment RAISE EXCEPTION to test
    END $in_1$;
 
 -------------------------------------------------------------------------------
    DO $in_2$
    BEGIN
    --
    CREATE TABLE tbl_games
    (
        fld_g_id_pk     BIGINT, -- required and unique integer 
        fld_g_doc       DATE    DEFAULT NOW(), --  date of creation (doc)
        fld_g_P1_id_fk  CHAR(16) , -- foreign key 1 from players table
        fld_g_P2_id_fk  CHAR(16), -- foreign key 2 from players table
        --
        CONSTRAINT games_pk PRIMARY KEY(fld_g_id_pk),
        CONSTRAINT unique_players_pair UNIQUE(fld_g_P1_id_fk, fld_g_P2_id_fk),
        CONSTRAINT check_players_order CHECK(fld_g_P1_id_fk < fld_g_P2_id_fk),
        -- Foreign key constraints:
        CONSTRAINT fk_games_player1 FOREIGN KEY (fld_g_P1_id_fk) REFERENCES tbl_players(fld_p_id_pk),
        CONSTRAINT fk_games_player2 FOREIGN KEY (fld_g_P2_id_fk) REFERENCES tbl_players(fld_p_id_pk),
        CONSTRAINT null_player CHECK (fld_g_P1_id_fk IS NOT NULL AND  fld_g_P2_id_fk IS NOT NULL)
    );
    EXCEPTION   
        WHEN OTHERS THEN 
            -- RAISE EXCEPTION USING 'Block 2 (games) failed' USING ERRCODE = 'P0040';
            -- Uncomment RAISE EXCEPTION to test            
    END $in_2$;

 -------------------------------------------------------------------------------
    DO $in_3$
    BEGIN
    --
    CREATE TABLE tbl_rounds
    (
        fld_r_id_pk     BIGINT, -- unique & required BIGINT 
        fld_g_id_fk   BIGINT, -- a required game ID referencing the games table
        fld_r_doc       DATE, --  date of creation (doc)
        fld_r_p1token CHAR(1), --  game tokens that must be 'R', 'P', or 'S' exclusively... (means NOT NULL).
        fld_r_p2token CHAR(1), --  game tokens that must be 'R', 'P', or 'S' exclusively... (means NOT NULL).
        --
        CONSTRAINT rounds_pk PRIMARY KEY(fld_r_id_pk),
        CONSTRAINT valid_tokens CHECK( fld_r_p1token IN ('R', 'P', 'S') AND fld_r_p2token IN ('R', 'P', 'S') ),
        -- NOT NULL Constraints
        CONSTRAINT tokens_not_null CHECK (fld_r_p1token IS NOT NULL AND fld_r_p2token IS NOT NULL),
        CONSTRAINT child_no_orphans CHECK(fld_g_id_fk IS NOT NULL),
        CONSTRAINT rounds_fk FOREIGN KEY (fld_g_id_fk) REFERENCES tbl_games(fld_g_id_pk)
    );
    EXCEPTION
        WHEN OTHERS THEN 
            -- RAISE EXCEPTION USING 'Block 3 (round) failed' USING ERRCODE = 'P0050'; 
            -- Uncomment RAISE EXCEPTION to test
    END $in_3$;

 -------------------------------------------------------------------------------
    DO $in_4$
    BEGIN
    --
    CREATE TABLE tbl_errata
   (
        fld_err_doc    TIMESTAMP DEFAULT NOW(),
        fld_sqlstate CHAR(5), 
        fld_sqlerrm  TEXT
    );   
    EXCEPTION
        WHEN OTHERS THEN 
            -- RAISE EXCEPTION USING 'Block 4 (errata) failed' USING ERRCODE = 'P0060'; -- placeholder
            -- Uncomment RAISE EXCEPTION to test
    END $in_4$;

 -------------------------------------------------------------------------------
        RAISE INFO E'\n\n\n**************************************\n\n *Transaction Blocks OK. SUCCESSFUL!*\n\n**************************************\n\n\n';
    EXCEPTION
        WHEN SQLSTATE 'P0030' THEN
            RAISE WARNING E'\n\n\n\n\nBlock 1 (players block) failed.';
        WHEN SQLSTATE 'P0040' THEN
            RAISE WARNING E'\n\n\n\n\nBlock 2 (games block) failed.';
        WHEN SQLSTATE 'P0050' THEN
            RAISE WARNING E'\n\n\n\n\nBlock 3 (rounds block) failed.';
        WHEN SQLSTATE 'P0060' THEN
            RAISE WARNING E'\n\n\n\n\nBlock 4 (errata block) failed.';
    -- something unexpected happened
        WHEN OTHERS THEN
            RAISE WARNING E'\n\n\nError: sqlstate = %, sqlerrm = %.\n\n\n', SQLSTATE, SQLERRM;
END $outside$;