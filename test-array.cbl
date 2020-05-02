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
       77  w-actual pic x(2048).
       77  w-expected pic x(2048).

       copy "array.cpy" replacing ==!PREFIX!== by ==w-==.
       copy "array.cpy" replacing ==!PREFIX!== by ==w-expected-==.

       01  w-expected-array-str-tbl value spaces.
           05 w-expected-array-str-arr pic x(STR-EL-SZ) occurs 100.


       linkage section.
       01  d-array-str-tbl value spaces.
           05 d-array-str-arr
           pic x(STR-EL-SZ)
           occurs 200000000
           depending on w-array-length.

       procedure division using

           d-array-str-tbl
           .
           call "array".

           perform test-allocation
              thru test-allocation-ex.
           perform test-append1
              thru test-append1-ex.

           call "array:free" using w-array.
           perform test-append-many
              thru test-append-many-ex.

           perform test-element-overflow
              thru test-element-overflow-ex.

           perform test-get-of-an-element
              thru test-get-of-an-element-ex.

           perform test-insert
              thru test-insert-ex.

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

       test-element-overflow.
           call "array:new" using w-array length of w-str-element.
           initialize w-expected-array-str-tbl.
           move "0123456789" to w-expected-array-str-tbl.
           call "array:append" using w-array "01234567891".
           call "assert"
              using ARRAY-EQ
                    w-expected-array-str-tbl
                    w-array
                    "when you append an element that exceeds the element
      -             "size, it should be truncated".

           call "array:free" using w-array.
       test-element-overflow-ex.
           exit.

       test-get-of-an-element.
           call "array:new" using w-array length of w-str-element.
           move "test" to w-expected.
           initialize w-actual.
           call "array:append" using w-array w-expected.
           call "array:get" using w-array w-actual 0.

           call "assert"
              using EQ
                    w-expected
                    w-actual
                    "it should be possible to read an element with 0 bas
      -             "ed indexing system".

           move "test2" to w-expected.
           initialize w-actual.
           call "array:append" using w-array w-expected.
           call "array:get" using w-array w-actual 1.

           call "assert"
              using EQ
                    w-expected
                    w-actual
                    "it should be possible to read elements with 0 based
      -             "indexing system".

           move "test3" to w-expected.
           initialize w-actual.
           call "array:append" using w-array w-expected.
           call "array:get" using w-array w-actual 2.

           call "assert"
              using EQ
                    w-expected
                    w-actual
                    "it should be possible to read elements with 0 based
      -             "indexing system".

           set address of d-array-str-tbl to w-array-ptr.
           call "assert"
              using EQ
                    w-expected
                    d-array-str-arr(3)
                    "it should be possible to read elements dereferencin
      -             "g the array with a linkage table".

           call "array:free" using w-array.
       test-get-of-an-element-ex.
           exit.

       test-insert.
           call "array:new" using w-array length of w-str-element.
           initialize w-expected-array-str-tbl.
           move "bla" to w-expected-array-str-arr(1).
           move "bla3" to w-expected-array-str-arr(2).
           move "bla2" to w-expected-array-str-arr(3).
           call "array:append" using w-array "bla".
           call "array:append" using w-array "bla2".
           call "array:insert" using w-array "bla3" 1.
           call "assert"
              using ARRAY-EQ
                    w-expected-array-str-tbl
                    w-array
                    "after insert, array should contain a new element in
      -             "the right position".
           move 3 to w-expected-array-length.
           call "assert" using EQ w-expected-array-length w-array-length
              "after inserting, array length should increment".

           call "array:insert" using w-array "bla4" 3.
           call "assert"
              using ARRAY-EQ
                    w-expected-array-str-tbl
                    w-array
                    "after inserting in a position that is greater than
      -             "current maximum index, it should stay invariate"
           move 3 to w-expected-array-length.
           call "assert" using EQ w-expected-array-length w-array-length
              "after inserting in a position that is greater than curren
      -       "t maximum index, it should stay invariate also in length"
              .

           call "array:free" using w-array.
       test-insert-ex.
           exit.
