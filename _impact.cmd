setMode -bs
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 1 -file "Z:/Desktop/github/ponggame/ponggame.bit"
assignFile -p 2 -file "Z:/Desktop/github/ponggame/ponggamerom.mcs"
setAttribute -position 2 -attr packageName -value ""
Program -p 2 -e -v 
setMode -bs
setMode -bs
deleteDevice -position 1
deleteDevice -position 1
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
