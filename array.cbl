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

      *{LINKAGE}
      *{STRUCTURE}

       linkage section.

       procedure division.
           display "hello world".

       post-process.
           stop run
