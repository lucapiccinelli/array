       identification division.
         program-id.  assert-logic.
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

       77  w-operator pic x(16) value EQ.
       77  w-expected pic x(MEMBERS-DIMENSION) value spaces.
       77  w-value pic x(MEMBERS-DIMENSION) value spaces.

       linkage section.
       77  l-operator pic x(MAX-LINKAGE).
       77  l-expected pic x(MEMBERS-DIMENSION).
       77  l-value pic x(MEMBERS-DIMENSION).

       procedure division using
           l-operator
           l-expected
           l-value.

       main.
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

           evaluate w-operator
              when EQ perform equality thru equality-ex
           end-evaluate.

           goback giving KO.

       equality.
           if w-value = w-expected
              goback giving OK
           else
              goback giving KO
           end-if.
       equality-ex.
           exit.
