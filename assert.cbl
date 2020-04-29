       identification division.
         program-id.  assert.
         author. Luca Piccinelli.
         date-written. 26.04.2020.
       environment division.
       configuration section.
       special-names.
       input-output section.
       file-control.
       data division.
       file section.
       working-storage section.
       copy "definitions.cpy"
           replacing ==!MAX-PARAMS-NUM== by ==4==.

       78  VALUE-DIMENSION value 2048.
       78  DESCRIPTION-DIMENSION value 2048.

       77  w-operator pic x(16) value EQ.
       77  w-expected pic x(VALUE-DIMENSION) value spaces.
       77  w-value pic x(VALUE-DIMENSION) value spaces.
       77  w-description pic x(DESCRIPTION-DIMENSION)
           value "empty description".

       77  w-return-value pic 9(02) value 0.
       77  w-display-decription pic x(256) value spaces.
       77  w-string-pointer pic 9(18) value 0.

       linkage section.
       77  l-operator pic x(MAX-LINKAGE).
       77  l-expected pic x(MAX-LINKAGE).
       77  l-value pic x(MAX-LINKAGE).
       77  l-description pic x(MAX-LINKAGE).

       procedure division using
           l-operator
           l-expected
           l-value
           l-description
           .
           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==operator==
               ==!N== by ==1==.
           copy "catchx.pdv" replacing
               ==!W== by ==expected==
               ==!N== by ==2==.
           copy "catchx.pdv" replacing
               ==!W== by ==value==
               ==!N== by ==3==.
           copy "catchx.pdv" replacing
               ==!W== by ==description==
               ==!N== by ==4==.

           call "assert-logic"
              using w-operator w-expected w-value
              giving w-return-value.

           initialize w-display-decription
           move 1 to w-string-pointer.
           if w-return-value = OK
              string
                 "OK -- "
                 into w-display-decription
                 pointer w-string-pointer
              end-string
           else
              string
                 "KO -- "
                 into w-display-decription
                 pointer w-string-pointer
              end-string
           end-if.

           string
              w-description
              delimited by STRING-LIMIT
              into w-display-decription
              pointer w-string-pointer
           end-string.

           if w-return-value = KO
              string
                 " -- Expected "
                 w-expected
                 ". It was instead "
                 w-value
                 delimited by STRING-LIMIT
                 into w-display-decription
                 pointer w-string-pointer
              end-string
           end-if.

           display w-display-decription upon console.

           goback giving w-return-value.
