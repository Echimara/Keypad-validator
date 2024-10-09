-- Author: Chi
-- This sql script uses IF-ELSE logic to see if a certain character you input maps to a character found on a '60s-era keypad e.g you type 4 which would be found on phone pads

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



/*
    Here is what the typical '60s-era keypad might look like: 


     1       2       3
            ABC     DEF

     4       5       6
    GHI     JKL     MNO

     7       8       9
    PRS     TUV     WXY

     *       0       #

     As you can see, it lacked 'Q' and also 'Z', meaning we couldn't spell "pizza" back then!

     The above PostgreSQL transaction block declares an uppercase letter as CHAR(1) and maps that letter
     to its corresponding digit on the old keypad.

     If the defined CHAR(1) isn't one of the letters you see above, there is an error code output '$'.
*/
