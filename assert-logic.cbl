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
       77  w-actual pic x(MEMBERS-DIMENSION) value spaces.

       77  w-array-data-length pic 9(09) value 0.
       copy "array.cpy"
           replacing ==!PREFIX!== by ==w-==.

       linkage section.
       77  l-operator pic x(MAX-LINKAGE).
       77  l-expected pic x(MAX-LINKAGE).
       77  l-actual pic x(MAX-LINKAGE).

       77  d-array-data pic x(MAX-LINKAGE).

       procedure division using
           l-operator
           l-expected
           l-actual

           d-array-data
           .

       main.
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

           evaluate w-operator
              when EQ
                 perform equality thru equality-ex
              when ARRAY-EQ
                 perform array-equality thru array-equality-ex
           end-evaluate.

           goback giving KO.

       equality.
           if w-actual = w-expected
              goback giving OK
           else
              goback giving KO
           end-if.
       equality-ex.
           exit.

       array-equality.
           move w-actual to w-array.
           compute w-array-data-length =
              w-array-length * w-array-element-sz
           end-compute.
           set address of d-array-data to w-array-ptr.

           move d-array-data(1:w-array-data-length) to w-actual
           move low-value to w-actual(w-array-data-length + 1:1)
           copy "movex.pdv" replacing
               ==!W== by ==actual==
               ==!N== by ==3==..

           move w-expected(1:w-array-data-length) to w-expected
           move low-value to w-expected(w-array-data-length + 1:1)
           copy "movex.pdv" replacing
               ==!W== by ==expected==
               ==!N== by ==2==..

           if d-array-data(1:w-array-data-length) =
              w-expected(1:w-array-data-length)
              goback giving OK
           else
              goback giving KO
           end-if.
       array-equality-ex.
           exit.
