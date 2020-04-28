       identification division.
         program-id.  array.
         author. Luca Piccinelli.
         date-written. 24.04.2020.
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

       78  INITIAL-CAPACITY value 2.

       copy "array.cpy" replacing ==!PREFIX!== by ==w-==.
       77  w-element-sz pic 9(09) value 0.

       linkage section.
       copy "array.cpy" replacing ==!PREFIX!== by ==l-==.
       77  l-element-sz pic 9(09) value 0.

       procedure division.
           goback giving 0.

       entry "array:new" using l-array l-element-sz.
           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           copy "catch9.pdv" replacing
               ==!W== by ==element-sz==
               ==!N== by ==2==.

           call "m$alloc" using w-element-sz w-array-ptr .

           move w-element-sz to w-array-element-sz.
           move INITIAL-CAPACITY to w-array-capacity.
           move 0 to w-array-length.

           $RETURN.

       post-process.
           goback.

