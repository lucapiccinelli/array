       78  MAX-LINKAGE value 2000000000.
       78  OK value 0.
       78  KO value 1.

       78  EQ value "eq".

       78  w78-max-params-num value !MAX-PARAMS-NUM.
       77  w-param-ind pic 9(02) usage comp-1 value 0.
       77  w-param-ind-x-err pic x(02) value spaces.
       77  w-narg pic 9(02) usage comp-1  value 0.
       01  w-args-size-map.
           05 w-args-size pic 9(09) occurs w78-max-params-num.

       copy "macros.cpy".