       identification division.
         program-id.  usage-example.
       environment division.
       working-storage section.

       copy "definitions.cpy".

       copy "array.cpy" replacing ==!PREFIX!== by ==w-==.
       77  w-element pic x(25) value spaces.

       linkage section.
       01 d-array-tbl.
           03 d-array-element pic x(25)
           occurs 20000000 | use a number big enough but the total must be less then 2GB
           depending on w-array-lenth
           ascending key is d-array-element | this enables the usage of search all keyword
           .

       procedure division.
           call "array".
           |each array element is going to be 25 bytes in size
           call "array:new" using w-array length of w-element.
           call "array:append" using w-array "new element".
           call "array:append" using w-array "new element 2".
           call "array:append" using w-array "banana".

           | always set the address after all the appends. Append operation can change the pointer.
           | So every time you append something you have to set address of linkage again
           set address of d-array-tbl to w-array-ptr.
           move d-array-element(1) to w-element. | use it... this is 1 based index, as a usual table

           call "array:free" using w-array.

           goback.
