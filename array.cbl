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
       77  w-capacity   pic 9(09) value 0.
       77  w-old-capacity   pic 9(09) value 0.
       77  w-offset-ptr usage pointer value 0.
       77  w-tmp-ptr usage pointer value 0.

       linkage section.
       copy "array.cpy" replacing ==!PREFIX!== by ==l-==.
       77  l-element-sz pic 9(09).
       77  l-element pic x(MAX-LINKAGE).

       77  d-array pic x(MAX-LINKAGE).

       procedure division using
           d-array
           .
           goback giving 0.

       entry "array:new" using l-array l-element-sz.
           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           copy "catch9.pdv" replacing
               ==!W== by ==element-sz==
               ==!N== by ==2==.

           move w-element-sz to w-array-element-sz.
           move INITIAL-CAPACITY to w-array-capacity.
           perform alloc thru alloc-ex.

           move 0 to w-array-length.

           copy "movex.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           $RETURN.

       entry "array:free" using l-array.
           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.

           call "m$free" using w-array-ptr.
           initialize w-array.

           copy "movex.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           $RETURN.


       entry "array:append" using l-array l-element.
           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.

           if w-array-length = w-array-capacity
              perform realloc thru realloc-ex
           end-if.
           compute w-offset-ptr =
              w-array-ptr + (w-array-element-sz * w-array-length).
           set address of d-array to w-offset-ptr.
           move l-element(1:w-args-size(2))
              to d-array(1:w-array-element-sz).
           add 1 to w-array-length.

           copy "movex.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           $RETURN.

       post-process.
           goback.

       alloc.
           compute w-capacity = w-array-capacity * w-element-sz.
           call "m$alloc" using w-capacity w-array-ptr.
       alloc-ex.
           exit.

       realloc.
           compute w-old-capacity = w-array-capacity * w-element-sz.
           multiply w-array-capacity by 2 giving w-array-capacity.
           move w-array-ptr to w-tmp-ptr.
           perform alloc thru alloc-ex.
           call "m$copy" using w-array-ptr w-tmp-ptr w-old-capacity.
           call "m$free" using w-tmp-ptr.
           initialize w-tmp-ptr.
       realloc-ex.
           exit.


