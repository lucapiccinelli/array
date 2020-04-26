       REPLACE
           ==$CATCHPARAMS== by
           ==
           call "c$narg" using w-narg end-call

           perform varying w-param-ind
              from 1 by 1 until w-param-ind > w-narg

              call "c$paramsize"
                 using w-param-ind
                 giving w-args-size(w-param-ind)
           end-perform
           ==.