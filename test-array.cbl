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

           perform test-allocation
              thru test-allocation-ex.
           perform test-append1
              thru test-append1-ex.

           call "array:free" using w-array.
           perform test-append-many
              thru test-append-many-ex.


           cancel "array".
           goback.

       test-allocation.
           move STR-EL-SZ to w-expected-array-element-sz.
           move 0 to w-expected-array-length.
           move 2 to w-expected-array-capacity.
           call "array:new" using w-array length of w-str-element.
           call "assert"
              using EQ
                    w-expected-array-data
                    w-array-data
                    "array should be allocated as expected".
       test-allocation-ex.
           exit.

       test-append1.
           initialize w-expected-array-str-tbl.
           move "bla" to w-expected-array-str-arr(1).
           move "bla2" to w-expected-array-str-arr(2).
           call "array:append" using w-array "bla".
           call "array:append" using w-array "bla2".
           call "assert"
              using ARRAY-EQ
                    w-expected-array-str-tbl
                    w-array
                    "after appending, array should contain a new element
      -             "".
           move 2 to w-expected-array-length.
           call "assert" using EQ w-expected-array-length w-array-length
              "after appending, array length should increment".
       test-append1-ex.
           exit.

       test-append-many.
           call "array:new" using w-array length of w-str-element.
           initialize w-expected-array-str-tbl.
           move "xx" to w-expected-array-str-arr(1).
           move "yyyy" to w-expected-array-str-arr(2).
           move "zzzzzz" to w-expected-array-str-arr(3).
           call "array:append" using w-array "xx".
           call "array:append" using w-array "yyyy".
           call "array:append" using w-array "zzzzzz".
           call "assert"
              using ARRAY-EQ
                    w-expected-array-str-tbl
                    w-array
                    "it should continue to append also when it excedees
      -             "the initial capacity".
           move 3 to w-expected-array-length.
           call "assert" using EQ w-expected-array-length w-array-length
              "after appending, array length should increment".

           call "array:free" using w-array.
       test-append-many-ex.
           exit.


