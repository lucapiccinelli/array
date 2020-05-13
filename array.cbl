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
           replacing ==!MAX-PARAMS-NUM== by ==4==
           .

       78  INITIAL-CAPACITY value 2.

       copy "array.cpy" replacing ==!PREFIX!== by ==w-==.
       77  w-element-sz pic 9(09) value 0.
       77  w-capacity   pic 9(09) value 0.
       77  w-old-capacity  pic 9(09) value 0.
       77  w-bytes-to-shift  pic 9(09) value 0.
       77  w-offset-ptr usage pointer value 0.
       77  w-where-to-move-ptr usage pointer value 0.
       77  w-tmp-ptr usage pointer value 0.
       77  w-index pic 9(MAX-NUMBER-SIZE).
       77  w-out-element pic x(2048).

       01  w-qsort-stack-tbl value zeros.
           03  w-qsort-stack occurs 100.
               05 w-qsort-stack-from pic 9(09).
               05 w-qsort-stack-to   pic 9(09).

       77  w-qsort-stack-idx pic  9(09) value 0.
       77  w-qsort-pivot-idx pic s9(09) value 0.
       77  w-from pic 9(09) value 0.
       77  w-to   pic 9(09) value 0.
       77  w-from-tmp pic 9(09) value 0.
       77  w-to-tmp   pic 9(09) value 0.
       77  i      pic 9(09) value 0.
       77  j      pic 9(09) value 0.
       77  w-swap-idx1 pic 9(09) value 0.
       77  w-swap-idx2 pic 9(09) value 0.
       77  w-step pic 9(09) value 0.
       77  w-store-idx pic 9(09) value 0.

       77  w-swap-tmp-ptr usage pointer value 0.
       77  w-array-compare-ptr usage pointer value 0.
       77  w-pivot-value-ptr usage pointer value 0.
       77  w-double-step pic 9(09) value 0.
       77  w-partition-size pic 9(09) value 0.
       77  w-compare-offset pic 9(09).
       77  w-compare-sz pic 9(09).
       77  w-comparator pic x(50) value spaces.

       77  w-compare-result pic s9 value 0.

       linkage section.
       copy "array.cpy" replacing ==!PREFIX!== by ==l-==.
       77  l-element-sz pic 9(09).
       77  l-element pic x(MAX-LINKAGE).
       77  l-out-element pic x(MAX-LINKAGE).
       77  l-index pic 9(MAX-NUMBER-SIZE).
       77  l-compare-offset pic 9(09).
       77  l-compare-sz pic 9(09).
       77  l-comparator pic x(MAX-LINKAGE).

       77  d-array pic x(MAX-LINKAGE).
       77  d-array-compare pic x(MAX-LINKAGE).
       77  d-swap-tmp pic x(MAX-LINKAGE).
       77  d-pivot-value pic x(MAX-LINKAGE).

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

           if w-array-ptr = 0
              $RETURN
           end-if.

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

           perform realloc thru realloc-ex.
           compute w-offset-ptr =
              w-array-ptr + (w-array-element-sz * w-array-length).
           perform move-linkage-value-to-the-array
              thru move-linkage-value-to-the-array-ex.

           copy "movex.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           $RETURN.

       entry "array:insert" using l-array l-element l-index.
           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           copy "catch9.pdv" replacing
               ==!W== by ==index==
               ==!N== by ==3==.

           if w-index >= w-array-length
              $RETURN
           end-if.
           perform realloc thru realloc-ex.
           perform shift-the-array thru shift-the-array-ex.
           perform move-linkage-value-to-the-array
              thru move-linkage-value-to-the-array-ex.

           copy "movex.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           $RETURN.


       entry "array:get" using l-array l-out-element l-index.
           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           copy "catch9.pdv" replacing
               ==!W== by ==index==
               ==!N== by ==3==.

           compute w-offset-ptr =
              w-array-ptr + (w-array-element-sz * w-index).
           set address of d-array to w-offset-ptr.
           move d-array(1:w-array-element-sz)
              to l-out-element(1:w-args-size(2)).

           $RETURN.

       post-process.
           goback.

       entry "array:sort" using
           l-array
           l-compare-offset
           l-compare-sz
           l-comparator
           .

           $CATCHPARAMS.
           copy "catchx.pdv" replacing
               ==!W== by ==array==
               ==!N== by ==1==.
           move 0 to w-compare-offset.
           copy "catch9.pdv" replacing
               ==!W== by ==compare-offset==
               ==!N== by ==2==.
           move w-array-element-sz to w-compare-sz.
           copy "catch9.pdv" replacing
               ==!W== by ==compare-sz==
               ==!N== by ==3==.
           move spaces to w-comparator.
           copy "catchx.pdv" replacing
               ==!W== by ==comparator==
               ==!N== by ==4==.

           perform initialize-sort
              thru initialize-sort-ex.

           perform initialize-stack
              thru initialize-stack-ex.

           perform until w-qsort-stack-idx <= 0
              perform pop-stack

              subtract w-from from w-to giving w-partition-size
              if w-from >= w-to or (w-partition-size < w-step)
                 exit perform cycle
              end-if

              perform compute-pivot
              perform qpartition
              perform push-left-partition
              perform push-right-partition
           end-perform.

           call "m$free" using w-pivot-value-ptr.
           call "m$free" using w-swap-tmp-ptr.

           $RETURN.

       qpartition.
           if w-partition-size = 0
              exit paragraph
           end-if.
           if w-partition-size = w-step
              perform partition-only-two-elements
              exit paragraph
           end-if.

           move d-array-compare(w-qsort-pivot-idx:w-compare-sz)
              to d-pivot-value(1:w-compare-sz).

           move w-qsort-pivot-idx to w-swap-idx1.
           move w-to to w-swap-idx2.
           perform swap.

           move w-from to w-store-idx.
           perform varying i from w-from by w-step
              until i >= w-to

              perform compare-with-pivot

              if w-compare-result < 0
                 move i to w-swap-idx1
                 move w-store-idx to w-swap-idx2
                 perform swap
                 add w-step to w-store-idx
              end-if

           end-perform.
           move w-to to w-swap-idx1.
           move w-store-idx to w-swap-idx2.
           perform swap.

           move w-store-idx to w-qsort-pivot-idx.
       qpartition-ex.
           exit.

       compare-with-pivot.
           if w-comparator <> spaces
              call w-comparator
                 using d-array-compare(i:w-compare-sz)
                       d-pivot-value(1:w-compare-sz)
                       w-array
                 giving w-compare-result
              exit paragraph
           end-if.

           if d-array-compare(i:w-compare-sz) <
              d-pivot-value(1:w-compare-sz)

              move -1 to w-compare-result
           else
              move 1 to w-compare-result
           end-if.
       compare-with-pivot-ex.
           exit.

       compare-array-elements.
           if w-comparator <> spaces
              call w-comparator
                 using d-array-compare(w-from:w-compare-sz)
                       d-array-compare(w-to:w-compare-sz)
                       w-array
                 giving w-compare-result
              exit paragraph
           end-if.

           if d-array-compare(w-from:w-compare-sz) <
              d-array-compare(w-to:w-compare-sz)

              move -1 to w-compare-result
           else
              move 1 to w-compare-result
           end-if.
       compare-array-elements-ex.
           exit.

       partition-only-two-elements.
           perform compare-array-elements.
           if w-compare-result > 0
              move w-from to w-swap-idx1
              move w-to to w-swap-idx2
              perform swap thru swap-ex
              move w-from to w-qsort-pivot-idx
           else
              move w-to to w-qsort-pivot-idx
           end-if.
       partition-only-two-elements-ex.
           exit.

       swap.
           if w-swap-idx1 = w-swap-idx2
              exit paragraph
           end-if.

           move d-array(w-swap-idx1:w-array-element-sz)
              to d-swap-tmp(1:w-array-element-sz).
           move d-array(w-swap-idx2:w-array-element-sz)
              to d-array(w-swap-idx1:w-array-element-sz).
           move d-swap-tmp(1:w-array-element-sz)
              to d-array(w-swap-idx2:w-array-element-sz).
       swap-ex.
           exit.

       alloc.
           compute w-capacity = w-array-capacity * w-element-sz.
           call "m$alloc" using w-capacity w-array-ptr.
       alloc-ex.
           exit.

       realloc.
           if w-array-length < w-array-capacity
              exit paragraph
           end-if

           compute w-old-capacity = w-array-capacity * w-element-sz.
           multiply w-array-capacity by 2 giving w-array-capacity.
           move w-array-ptr to w-tmp-ptr.
           perform alloc thru alloc-ex.
           call "m$copy" using w-array-ptr w-tmp-ptr w-old-capacity.
           call "m$free" using w-tmp-ptr.
           initialize w-tmp-ptr.
       realloc-ex.
           exit.

       compute-shift-params.
           compute w-offset-ptr =
              w-array-ptr + (w-array-element-sz * w-index).
           add w-array-element-sz to w-offset-ptr
              giving w-where-to-move-ptr.
           compute w-bytes-to-shift =
              (w-array-length - w-index) * w-array-element-sz
           end-compute.

       compute-shift-params-ex.
           exit.

       shift-the-array.
           perform compute-shift-params thru compute-shift-params-ex.
           call "m$copy"
              using w-where-to-move-ptr
                    w-offset-ptr
                    w-bytes-to-shift.

       shift-the-array-ex.
           exit.

       move-linkage-value-to-the-array.
           set address of d-array to w-offset-ptr.
           move l-element(1:w-args-size(2))
              to d-array(1:w-array-element-sz).
           add 1 to w-array-length.

       move-linkage-value-to-the-array-ex.
           exit.

       pop-stack.
           move w-qsort-stack-from(w-qsort-stack-idx) to w-from.
           move w-qsort-stack-to(w-qsort-stack-idx) to w-to.
           subtract 1 from w-qsort-stack-idx.
       pop-stack-ex.
           exit.

       push-right-partition.
           add w-step to w-qsort-pivot-idx giving w-from-tmp.
           if w-from-tmp >= w-to
              exit paragraph
           end-if.

           add 1 to w-qsort-stack-idx.
           move w-from-tmp to w-qsort-stack-from(w-qsort-stack-idx).
           move w-to to w-qsort-stack-to(w-qsort-stack-idx).
       push-right-partition-ex.
           exit.

       push-left-partition.
           subtract w-step from w-qsort-pivot-idx giving w-to-tmp.
           if w-from >= w-to-tmp
              exit paragraph
           end-if.

           add 1 to w-qsort-stack-idx.
           move w-from to w-qsort-stack-from(w-qsort-stack-idx).
           move w-to-tmp to w-qsort-stack-to(w-qsort-stack-idx).
       push-left-partition-ex.
           exit.

       initialize-sort.
           call "m$alloc" using w-compare-sz w-pivot-value-ptr.
           call "m$alloc" using w-array-element-sz w-swap-tmp-ptr.
           set address of d-pivot-value to w-pivot-value-ptr.
           set address of d-swap-tmp to w-swap-tmp-ptr.
           set address of d-array to w-array-ptr.
           add w-compare-offset to w-array-ptr
              giving w-array-compare-ptr.
           set address of d-array-compare to w-array-compare-ptr.
           move zeros to w-qsort-stack-tbl.
           move w-element-sz to w-step.
           multiply w-step by 2 giving w-double-step.
       initialize-sort-ex.
           exit.

       initialize-stack.
           move 1 to w-qsort-stack-idx.
           move 1 to w-qsort-stack-from(w-qsort-stack-idx).
           compute w-qsort-stack-to(w-qsort-stack-idx) =
              ((w-array-length - 1) * w-array-element-sz) + 1
           end-compute.
       initialize-stack-ex.
           exit.

       compute-pivot.
           compute w-qsort-pivot-idx = w-from +
              function integer-part(w-partition-size / w-double-step)
              * w-step
           end-compute.
       compute-pivot-ex.
           exit.













