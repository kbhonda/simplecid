for %%i in (00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19) do (
   for %%j in (00,01,02,03) do (
      ppltotf scid.pl scid%%i-%%j.tfm 
      perl mk.pl %%i %%j > scid%%i-%%j.vpl
      ovp2ovf scid%%i-%%j.vpl scid%%i-%%j.vf
   )
   ppltotf scid-raw.pl scid%%i-raw.tfm
)

del *.vpl
del *.ofm