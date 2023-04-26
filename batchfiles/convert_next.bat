set PATHTOPROJECT=Source
set FILENAME=ddrc_phy_cscb_registers_test.xml
set DITAMAPNAME=ddrc_phy_cscb_registers.ditamap
cd ..\

set WORKINGDIR=%CD%

cd %WORKINGDIR%\batchfiles

rd /s /q %WORKINGDIR%\out\

#REM java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar   -o:%WORKINGDIR%\out\%DITAMAPNAME% %WORKINGDIR%\%PATHTOPROJECT%\%FILENAME% %WORKINGDIR%\depend\xslt\generate-ditamap.xsl

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar   -o:%WORKINGDIR%\out\temp.txt %WORKINGDIR%\%PATHTOPROJECT%\%FILENAME% %WORKINGDIR%\depend\xslt\generate-topics.xsl

cd %WORKINGDIR%\batchfiles