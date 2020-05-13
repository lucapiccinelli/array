       identification division.
         program-id.  testcomparator.
         author. Luca Piccinelli.
         date-written. 13.05.2020.
       environment division.
       configuration section.
       special-names.
       input-output section.
       file-control.
       data division.
       file section.
       working-storage section.
       copy "definitions.cpy"
           replacing ==!MAX-PARAMS-NUM== by ==3==
           .
       77  w-first pic x(25).
       77  w-second pic x(25).
       copy "array.cpy" replacing ==!PREFIX!== by ==w-==.


       linkage section.
       77  l-first pic x(MAX-LINKAGE).
       77  l-second pic x(MAX-LINKAGE).
       copy "array.cpy" replacing ==!PREFIX!== by ==l-==.

       procedure division using l-first l-second l-array.
           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==first==
               ==!N== by ==1==.
           copy "catchx.pdv" replacing
               ==!W== by ==second==
               ==!N== by ==2==.
           copy "catchx.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==3==.

           if w-first = w-second goback giving 0.

           if w-first = "first" goback giving -1.
           if w-first = "second" and w-second <> "first"
              goback giving -1
           end-if.

           if w-first = "third"
              and w-second <> "first"
              and w-second <> "second"
              goback giving -1
           end-if.

           if w-second = "first" goback giving 1.
           if w-second = "second" and w-first <> "first"
              goback giving 1
           end-if.

           if w-second = "third"
              and w-first <> "first"
              and w-first <> "second"
              goback giving 1
           end-if.

           if w-first < w-second goback giving -1.
           goback giving 1.
