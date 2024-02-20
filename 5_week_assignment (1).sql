/*
    I think this is Assignment 3:
    
    Run the script given in the file    5_week_notes_rps pt1.sql  (Either the anonymous
    transaction or the procedural version should produce the same tables.)
    This creates the rps schema we will use.

    Using my example from   5_week_notes_rps pt2.sql, We will write two procedures:

    proc_insert_player( CHAR(16) )     this is the parent table

    and

    proc_insert_game( CHAR(16, CHAR(16) )   this is the child

    I recommend going in order through the table constraints.

    tbl_players has only two constraints... actually, three because a PK
    cannot be null and must be unique.  The other checks zero length.


    proc_insert_game is more complicated; some points:
        You don't have to check the PK because it defaults to a sequence.
        You don't have to use my suggested error codes... whatever, be
        sure to document them!

            check that the first parameter is less than the second.
            (*I* would make that errlvl 1)

            Then, check each parameters for NULL.  errlvl 2 & 3

            Then check that each one is in tbl_players. errlvl 4 & 5

        Then

        Finally, check for a unique pair.  You have examples of everything else,
        so I'll give you a hint:
            I will assume the parameters to insert_game are named parm_p_id1 and parm_p_id2:

            ELSIF EXISTS ( SELECT *
                           FROM tbl_games
                           WHERE fld_p_id1_fk=parm_p_id1 AND fld_p_id2_fk=parm_p_id2 )
                THEN
                    -- The pair are already in the table. code it!
                ELSE
                    INSERT ...



        It's simple ladder logic; you have 6 constraints to check.

        You don't have to check zero length on the parameters to proc_insert_games
        because we're already checking that each are in tbl_players and zero-length
        primary key is constrained there.

        Document your error codes like I did mine in the examples.

        Test your procedures like I did mine in the examples.

        Grading:
            Do your procedures run? + 30%
            Do you cover all constraints? + 10%
            Format & naming convention: + 10%
            Does your test code cover all cases? + 30%  Total 80%

            Challenge:  20%

        A Programming Challenge:

        And, as always, here is a challenge... would you allow a challenge to go unanswered?
        Yes, it's graded!

        IF parm_p_id1 > parm_p_id2 (Would be errlvl 1 if you're using my suggestions)
        THEN <swap them>

        That's simple, but it raises another check: what if they're equal?  The
        table constraint says CHECK(p1<p2) which rules out equality, but swapping
        them doesn't help that.

        I would have two local variables and I'd immediately copy the parameters
        into these, switching them if they're out of order.  Then proceed using
        the local variables instead of the parameters.

        Most languages implement IN vs. INOUT parameters.  These are called, respectively,
        *value* parameters (where the formal parameter is a copy of the actual parameter's
        value) and *reference* parameters where the formal parameter is a pointer to the
        actual parameter.  Some platforms will copy the parameters in, then copy any changes
        back out; these platforms will usually implement an OUT (only) parameter, thus
        avoiding the cost of copying the initial value in.
*/
        CREATE PROCEDURE proc_insert_game( IN parm_p_id1 CHAR(16), IN parm_p_id2 CHAR(16)...
        DECLARE
            lv_temp CHAR(16);
        BEGIN
            IF parm_p_id1 > parm_p_id2
            THEN    lv_temp := parm_p_id1; -- swap the parameters
                    parm_p_id1 := parm_p_id2;
                    parm_p_id2 := lv_temp;
            END IF;
        [...]
/*
        Most variants of PSQL won't compile this because it's changing an input (only)
        parameter.  (PostgreSQL will compile; however, since most won't, we will adopt
        the convention of not changing the parameters... because this class is intended
        to apply to *all* database products and not exclusively PostgreSQL.

        Also, the parameters could still be equal, and that would violate a table constraint.

        (I bet you never thought Rock, Paper, Scissors could be *this* complicated, huh?
         You ain't seen *nuthin'* yet!)

         Here is how I would approach this problem:
         (You don't have to match my identifiers; however, mine meet convention.)
*/
        CREATE PROCEDURE proc_insert_game( IN parm_p_id1 CHAR(16), IN parm_p_id2 CHAR(16)...
        DECLARE
            lv_p_id1 CHAR(16);
            lv_p_id2 CHAR(16);
        BEGIN
            IF parm_p_id1 = parm_p_id2

            THEN -- it's an error, set parm_errlvl to the appropriate code and we're done!

            ELSE
                parm_errlvl := 0; -- optimistic!

                -- Copy the parameters into the local variables
                IF parm_p_id1 < parm_p_id2 -- Order OK
                THEN
                    lv_p_id1 := parm_p_id1;
                    lv_p_id2 := parm_p_id2;
                ELSE                        -- They're reversed, swap
                    lv_p_id1 := parm_p_id2;
                    lv_p_id2 := parm_p_id1;
                END IF;

                /*
                Now, your local variables have the parameter values in the correct order
                and you have eliminated equality.  Notice that we're in the ELSE-block
                of the initial IF; stay inside of that.  The rest of your logic will use
                the local variables.  If we get here, then lv_p_id1 < lv_p_id2 and we
                don't need to worry about *that* constraint any further.

                Somebody might CALL proc_insert_game('Bob', 'Al', ... where a game with
                'Al' as p1 and 'Bob' as p2 would be valid.  This logic accepts that and
                simply reverses them.

                The rest is simple ladder logic; INSERT goes in here, also.
                */


            END IF;
        END -- of procedure

/*
    You don't have to use my logic; however, if you implement it carefully, it will work!
    
    For testing:
*/
    DO $GO$
    DECLARE
        lv_errlvl SMALLINT;
    BEGIN
        CALL proc_insert_game('Bob', 'Al', lv_errlvl);
        RAISE INFO E'\nError level = %./n', lv_errlvl;
    END $GO$;
/*
    Assumptions: 'Al' and 'Bob' exist in tbl_players and are not already in a game.
    
    If you implemented the 20% challenge, that will INSERT 'Al', 'Bob' and return errlvl 0.
    
    If you chose the easier route, then it will be rejected as errlvl 1.
*/
