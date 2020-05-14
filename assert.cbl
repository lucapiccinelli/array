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
       77  w-actual pic x(VALUE-DIMENSION) value spaces.
       77  w-description pic x(DESCRIPTION-DIMENSION)
           value "empty description".

       77  w-return-value pic 9(02) value 0.
       77  w-display-decription pic x(256) value spaces.
       77  w-string-pointer pic 9(18) value 0.

       77  w-total-number-of-tests pic 9(09) value 0.
       77  z-total-number-of-tests pic z(04)9.

       77  w-success-number-of-tests pic 9(09) value 0.
       77  z-success-number-of-tests pic z(04)9.

       77  w-failed-number-of-tests pic 9(09) value 0.
       77  z-failed-number-of-tests pic z(04)9.

       77  w-verify-str pic x(256) value spaces.

       linkage section.
       77  l-operator pic x(MAX-LINKAGE).
       77  l-expected pic x(MAX-LINKAGE).
       77  l-actual pic x(MAX-LINKAGE).
       77  l-description pic x(MAX-LINKAGE).

       procedure division using
           l-operator
           l-expected
           l-actual
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
               ==!W== by ==actual==
               ==!N== by ==3==.
           copy "catchx.pdv" replacing
               ==!W== by ==description==
               ==!N== by ==4==.

           if w-operator = VERIFY
              perform run-verify thru run-verify-ex
              goback giving 0
           end-if.

           call "assert-logic"
              using w-operator w-expected w-actual
              giving w-return-value.

           add 1 to w-total-number-of-tests.

           initialize w-display-decription
           move 1 to w-string-pointer.
           if w-return-value = OK
              add 1 to w-success-number-of-tests
              string
                 "OK -- "
                 into w-display-decription
                 pointer w-string-pointer
              end-string
           else
              add 1 to w-failed-number-of-tests
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
                 w-actual
                 delimited by low-value
                 into w-display-decription
                 pointer w-string-pointer
              end-string
           end-if.

           display w-display-decription upon console.

           goback giving w-return-value.

       run-verify.
           move w-total-number-of-tests to z-total-number-of-tests.
           move w-success-number-of-tests to z-success-number-of-tests.
           move w-failed-number-of-tests to z-failed-number-of-tests.
           initialize w-verify-str.
           string
              "RESULTS:"
              z-total-number-of-tests
              " were executed."
              z-success-number-of-tests
              " were OK."
              z-failed-number-of-tests
              " were KO."
              into w-verify-str
           end-string.

           display w-verify-str upon console.
           if w-failed-number-of-tests = 0
              display "Test is OK" upon console
           else
              display "Test is KO" upon console
           end-if.
       run-verify-ex.
           exit.

