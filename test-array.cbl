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

       01  w-expected-array-str-tbl value spaces.
           05 w-expected-array-str-arr pic x(STR-EL-SZ) occurs 100.


       linkage section.

       procedure division.
           call "array".

           move STR-EL-SZ to w-expected-array-element-sz.
           move 0 to w-expected-array-length.
           move 2 to w-expected-array-capacity.
           call "array:new" using w-array length of w-str-element.
           call "assert"
              using EQ
                    w-expected-array-data
                    w-array-data
                    "array should be allocated as expected".


           move "bla" to w-expected-array-str-arr(1).
           call "array:append" using w-array "bla".
           call "assert"
              using ARRAY-EQ
                    w-expected-array-str-tbl
                    w-array
                    "after appending, array should contain a new element
      -             "".
           move 1 to w-expected-array-length.
           call "assert" using EQ w-expected-array-length w-array-length
              "after appending, array length should increment".

           cancel "array".
           goback.
