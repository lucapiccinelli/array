       identification division.
         program-id.  test-array.
         author. Studiofarma nome autore.
         date-written. Data.
       environment division.
       configuration section.
       special-names.
       input-output section.
       file-control.
       data division.
       file section.
       working-storage section.
       copy "definitions.cpy".

       78  STR-EL-SZ value 10.
       77  w-str-element pic x(STR-EL-SZ).

       copy "array.cpy" replacing ==!PREFIX!== by ==w-==.
       copy "array.cpy" replacing ==!PREFIX!== by ==w-expected-==.


       linkage section.

       procedure division.
           call "array".

           move STR-EL-SZ to w-expected-array-element-sz.
           move 2 to w-expected-array-length.
           move 0 to w-expected-array-capacity.
           call "array:new" using w-array length of w-str-element.
           call "assert"
              using EQ
                    w-expected-array-data
                    w-array-data
                    "array should be allocated as expected".

           cancel "array".
           goback.
