       01  !PREFIX!array.
           05 !PREFIX!array-ptr usage pointer.
           05 !PREFIX!array-version pic 9(05).
           05 !PREFIX!array-data.
              07 !PREFIX!array-element-sz pic 9(09) usage comp-4.
              07 !PREFIX!array-length pic 9(09) usage comp-4.
              07 !PREFIX!array-capacity pic 9(09) usage comp-4.
              07 !PREFIX!array-type pic x(32).
                 88 !PREFIX!NUMERIC-ARRAY-TYPE value TNUMERIC.
                 88 !PREFIX!ALPHANUMERIC-ARRAY-TYPE value TALPHANUMERIC.
           05 filler pic x(100).