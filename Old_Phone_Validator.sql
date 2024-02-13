-- DATE: 2/5/2024
-- Uses IF-ELSE logic
-- What it does do? Checks to see if a certain character or alphabet maps to a number of the phone pad 📱 

    DO $GO$
    DECLARE
        lvLetter CHAR(1) := 'J'; -- character being checked
        lvDigit INT;  -- hold button number
    BEGIN
        IF lvLetter NOT IN
                (   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                    'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', '*','0','#')
        THEN RAISE NOTICE E'\n************************************************\n  \033[1mErrcode $: % is not one of the letters on the pad. \033[0m\n\n', lvLetter; -- that may be our error message
        -- Better to put it in a variable.
        END IF;

        /* Number key 2*/
        IF lvLetter IN ('A', 'B', 'C')
        THEN lvDigit := 2;
        RAISE NOTICE E'\n*************************************\n \033[1mThe letter % maps to % on the pad.\033[0m\n\n', lvLetter, lvDigit;
        END IF;

        /* Number key 3*/
        IF lvLetter IN ('D', 'E', 'F')
        THEN lvDigit := 3;
        RAISE NOTICE E'\n*************************************\n \033[1mThe letter % maps to % on the pad.\033[0m\n\n', lvLetter, lvDigit;
        END IF;        

        /* Number key 4*/
        IF lvLetter IN ('G', 'H', 'I')
        THEN lvDigit := 4;
        RAISE NOTICE E'\n*************************************\n \033[1mThe letter % maps to % on the pad.\033[0m\n\n', lvLetter, lvDigit;
        END IF;

        /* Number key 5*/
        IF lvLetter IN ('J', 'K', 'L')
        THEN lvDigit := 5;
        RAISE NOTICE E'\n*************************************\n \033[1mThe letter % maps to % on the pad.\033[0m\n\n', lvLetter, lvDigit;
        END IF;      
      
        /* Number key 6*/
        IF lvLetter IN ('M', 'N', 'O')
        THEN lvDigit := 6;
        RAISE NOTICE E'\n*************************************\n \033[1mThe letter % maps to % on the pad.\033[0m\n\n', lvLetter, lvDigit;
        END IF;   
     
        /* Number key 7*/  -- skips 'Q'
        IF lvLetter IN ('P', 'R', 'S')
        THEN lvDigit := 7;
        RAISE NOTICE E'\n*************************************\n \033[1mThe letter % maps to % on the pad.\033[0m\n\n', lvLetter, lvDigit;
        END IF;

       /* Number key 8*/
        IF lvLetter IN ('T', 'U', 'V')
        THEN lvDigit := 8;
        RAISE NOTICE E'\n*************************************\n \033[1mThe letter % maps to % on the pad.\033[0m\n\n', lvLetter, lvDigit;
        END IF;

       /* Number key 9*/  -- skips 'Z'
        IF lvLetter IN ('W', 'X', 'Y')
        THEN lvDigit := 9;
        RAISE NOTICE E'\n*************************************\n \033[1mThe letter % maps to % on the pad.\033[0m\n\n', lvLetter, lvDigit;
        END IF;

  
    RAISE NOTICE E'\n \033[1mAnonymous program complete. \033[0m\n\n';
    END $GO$;



--* RUBRIC *--

/*
    This is an old, tried & true, programming problem out of the stone ages.  When I was young,
    I had to *walk* to school... two miles!  And my telephone didn't do text.  When we finally
    advanced to digital dialing, the keypad looked like this:


     1       2       3
            ABC     DEF

     4       5       6
    GHI     JKL     MNO

     7       8       9
    PRS     TUV     WXY

     *       0       #

     As you can see, it lacked 'Q'.  We could have lived with that; however, it also lacked 'Z',
     so we couldn't spell "pizza"!

     We have since fixed that issue, but *this* assignment will use the old, '60s-era keypad.

     We will write a PostgreSQL transaction block (or "execution block", or "annonymous program";
     they're the same) that will declare an uppercase letter as CHAR(1) and will map that letter
     to its corresponding digit on my old keypad.

     If the defined CHAR(1) isn't one of the letters you see above, output a '$' as an error code.

     Some requirements: You must use "IF" logic.  *Any* D.B. programmer would drop the values into
     a table and write a SELECT statement... but this program is about "IF" logic.  Do not use the
     CASE statement (in C, the switch() logic).  Also, don't use ASCII arithmetic, either.  The
     assignment is to demonstrate clean "IF" logic.
*/

/*
    Now, *that* is brutal! I am using 27 comparisons!  Even worse, I keep searching
    after I find it.  Your assignment is to do it using fewer comparisons.

        IF lvLetter = 'A' OR lvLetter = 'B' OR lvLetter = 'C'

    ... is three comparisons.  Although, we will count:

        IF lvInput NOT IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                           'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y')

    ... as one comparison.  (Likely, it's more... probably a minimum of three is my
    guess.)  Counting the SQL "IN" as one, you can stay within 4 or fewer comparisons
    (and I don't think "fewer" than 4 is possible.)

    Hint: there are eight values in the range... all sorted.  Use a simple binary approach.

    Some advice: there are four relational operators: '<', '>', '<=', '>=' choose one
    and stick with it.  Trying to use ELSIF will be tricky because there isn't
    anything like "THENIF", so your tree will have non-symmetric syntax.

    If you cannot get it running using binary logic, you may use ladder logic
    to solve in seven comparisons (eight, counting validation.)  More comparisons will
    reduce the grade.

    The output should be of the form:

    RAISE NOTICE E'\nThe letter % maps to % on the pad.\n\n', lvLetter, lvDigit;

    (It may vary some, but that's a general idea.)
*/
