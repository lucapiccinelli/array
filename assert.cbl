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

       78  MEMBERS-DIMENSION value 2048.
       78  DESCRIPTION-DIMENSION value 2048.

       77  w-operator pic x(16) value EQ.
       77  w-expected pic x(MEMBERS-DIMENSION) value spaces.
       77  w-value pic x(MEMBERS-DIMENSION) value spaces.
       77  w-description pic x(DESCRIPTION-DIMENSION)
           value "empty description".

       77  w-return-value pic 9(02) value 0.

       linkage section.
       77  l-operator pic x(MAX-LINKAGE).
       77  l-expected pic x(MEMBERS-DIMENSION).
       77  l-value pic x(MEMBERS-DIMENSION).
       77  l-description pic x(DESCRIPTION-DIMENSION).

       procedure division.
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

           goback giving w-return-value.
