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
       78  NUM-EL-SZ value 9.
       77  w-str-element pic x(STR-EL-SZ).
       77  w-num-element pic 9(NUM-EL-SZ) value 0.
       77  w-num-element2 pic 9(NUM-EL-SZ) value 0.
       77  w-max-elements pic 9(NUM-EL-SZ) value 0.
       77  j pic 9(NUM-EL-SZ) value 0.
       77  i pic 9(NUM-EL-SZ) value 0.
       77  i-d redefines i pic 9v99999999.
       77  w-actual pic x(2048).
       77  w-actual-num pic 9(NUM-EL-SZ).
       77  w-expected pic x(2048).
       77  w-expected-num pic 9(NUM-EL-SZ).


       copy "array.cpy" replacing ==!PREFIX!== by ==w-==.
       copy "array.cpy" replacing ==!PREFIX!== by ==w-expected-==.

       01  w-expected-array-str-tbl value spaces.
           05 w-expected-array-str-arr pic x(STR-EL-SZ) occurs 100.

       01  w-expected-array-num-tbl value zeros.
           05 w-expected-array-num-arr pic 9(NUM-EL-SZ) occurs 100.

       01  w-expected-array-stt-tbl.
           03 w-expected-array-stt-arr occurs 100.
              05 w-expected-array-stt-arr-x pic x(25).
              05 w-expected-array-stt-arr-9 pic 9(08).

       01  w-stt.
           05 w-stt-x pic x(25) value spaces.
           05 w-stt-9 pic 9(08) value zeros.
       78  STT-SZ value length of w-stt.

       linkage section.
       01  d-array-str-tbl value spaces.
           05 d-array-str-arr
           pic x(STR-EL-SZ)
           occurs 200000000
           depending on w-array-length.

       01  d-array-num-tbl value spaces.
           05 d-array-num-arr
           pic x(NUM-EL-SZ)
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

           perform test-append-and-get-of-a-numeric-value
              thru test-append-and-get-of-a-numeric-value-ex.

           perform test-sortingx
              thru test-sortingx-ex.
           perform test-sortingn
              thru test-sortingn-ex.
           perform test-sorting
              thru test-sorting-ex.
           perform test-sortingn-parts-of-data-structures
              thru test-sortingn-parts-of-data-structures-ex.
           perform test-sorting-comparators
              thru test-sorting-comparators-ex.

           call "assert" using VERIFY.

           cancel "array".
           cancel "assert".
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
      -             " the right position".
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

       test-append-and-get-of-a-numeric-value.
           call "array:new" using w-array length of w-num-element.
           move 42 to w-num-element
           call "array:append" using w-array w-num-element.
           move 43 to w-expected-num
           call "array:append" using w-array w-expected-num.
           move 44 to w-num-element
           call "array:append" using w-array w-num-element.

           call "array:get" using w-array w-actual-num 1

           call "assert"
              using EQ
                    w-expected-num
                    w-actual-num
                    "array works also with numbers".
           call "array:free" using w-array.
       test-append-and-get-of-a-numeric-value-ex.
           exit.

       test-sorting.
           call "array:new" using w-array length of i.
           move 10000 to w-max-elements.
           perform fill-the-array-with-random-numbers
              thru fill-the-array-with-random-numbers-ex.

           call "array:sort" using w-array
           initialize i.

           perform check-that-array-is-sorted
              thru check-that-array-is-sorted-ex

           call "assert"
              using EQ
                    w-max-elements
                    i
                    "big array is sorted".

           call "array:free" using w-array.
       test-sorting-ex.
           exit.

       test-sortingx.
           call "array:new" using w-array length of w-str-element.
           move "aaaaaaaaaa" to w-expected-array-str-arr(1).
           move "bbbbbbbbbb" to w-expected-array-str-arr(2).
           move "cccccccccc" to w-expected-array-str-arr(3).
           move "dddddddddd" to w-expected-array-str-arr(4).
           move "eeeeeeeeee" to w-expected-array-str-arr(5).

           call "array:append" using w-array "bbbbbbbbbb".
           call "array:append" using w-array "aaaaaaaaaa".
           call "array:append" using w-array "eeeeeeeeee".
           call "array:append" using w-array "dddddddddd".
           call "array:append" using w-array "cccccccccc".
           call "array:sort" using w-array.

           call "assert"
              using ARRAY-EQ
                    w-expected-array-str-tbl
                    w-array
                    "array of strings is sorted".

           call "array:free" using w-array.
       test-sortingx-ex.
           exit.

       test-sortingn.
           call "array:new" using w-array length of w-num-element.
           move 1  to w-expected-array-num-arr(1).
           move 1  to w-expected-array-num-arr(2).
           move 2  to w-expected-array-num-arr(3).
           move 3  to w-expected-array-num-arr(4).
           move 4  to w-expected-array-num-arr(5).
           move 5  to w-expected-array-num-arr(6).
           move 11 to w-expected-array-num-arr(7).

           move 3 to w-num-element.
           call "array:append" using w-array w-num-element.
           move 2 to w-num-element.
           call "array:append" using w-array w-num-element.
           move 1 to w-num-element.
           call "array:append" using w-array w-num-element.
           move 4 to w-num-element.
           call "array:append" using w-array w-num-element.
           move 1 to w-num-element.
           call "array:append" using w-array w-num-element.
           move 11 to w-num-element.
           call "array:append" using w-array w-num-element.
           move 5 to w-num-element.
           call "array:append" using w-array w-num-element.

           call "array:sort" using w-array.

           call "assert"
              using ARRAY-EQ
                    w-expected-array-num-tbl
                    w-array
                    "array of numbers is sorted".

           call "array:free" using w-array.
       test-sortingn-ex.
           exit.

       test-sortingn-parts-of-data-structures.
           call "array:new" using w-array length of w-stt.
           move  1  to w-expected-array-stt-arr-9(1).
           move "z" to w-expected-array-stt-arr-x(1).
           move  2  to w-expected-array-stt-arr-9(2).
           move "v" to w-expected-array-stt-arr-x(2).
           move  3  to w-expected-array-stt-arr-9(3).
           move "u" to w-expected-array-stt-arr-x(3).
           move  4  to w-expected-array-stt-arr-9(4).
           move "t" to w-expected-array-stt-arr-x(4).
           move  5  to w-expected-array-stt-arr-9(5).
           move "s" to w-expected-array-stt-arr-x(5).
           move  11 to w-expected-array-stt-arr-9(6).
           move "r" to w-expected-array-stt-arr-x(6).

           call "array:append"
              using w-array w-expected-array-stt-arr(5).
           call "array:append"
              using w-array w-expected-array-stt-arr(3).
           call "array:append"
              using w-array w-expected-array-stt-arr(2).
           call "array:append"
              using w-array w-expected-array-stt-arr(4).
           call "array:append"
              using w-array w-expected-array-stt-arr(6).
           call "array:append"
              using w-array w-expected-array-stt-arr(1).

           call "array:sort"
              using w-array
                    record-position of w-stt-9
                    length of w-stt-9
                    .

           call "assert"
              using ARRAY-EQ
                    w-expected-array-stt-tbl
                    w-array
                    "array of data structure is sorted with rules on par
      -             "t of the structure".

           call "array:free" using w-array.
       test-sortingn-parts-of-data-structures-ex.
           exit.

       test-sorting-comparators.
           call "array:new" using w-array length of w-str-element.
           move "first"  to w-expected-array-str-arr(1).
           move "second" to w-expected-array-str-arr(2).
           move "third"  to w-expected-array-str-arr(3).
           move "apple"  to w-expected-array-str-arr(4).
           move "banana" to w-expected-array-str-arr(5).

           call "array:append"
              using w-array w-expected-array-str-arr(2).
           call "array:append"
              using w-array w-expected-array-str-arr(5).
           call "array:append"
              using w-array w-expected-array-str-arr(3).
           call "array:append"
              using w-array w-expected-array-str-arr(1).
           call "array:append"
              using w-array w-expected-array-str-arr(4).

           call "array:sort"
              using w-array
                    0
                    length of w-str-element
                    "testcomparator"
                    .

           call "assert"
              using ARRAY-EQ
                    w-expected-array-str-tbl
                    w-array
                    "array is sorted with test comparator".

           call "array:free" using w-array.
       test-sorting-comparators-ex.
           exit.


       fill-the-array-with-random-numbers.
           perform w-max-elements times
              move function random() to i-d
              call "array:append" using w-array i
           end-perform.
       fill-the-array-with-random-numbers-ex.
           exit.


       check-that-array-is-sorted.
           perform varying i from 1 by 1 until i >= w-max-elements
              subtract 1 from i giving j
              call "array:get" using w-array w-num-element j
              call "array:get" using w-array w-num-element2 i

              if w-num-element > w-num-element2
                 exit perform
              end-if
           end-perform.
       check-that-array-is-sorted-ex.
           exit.


