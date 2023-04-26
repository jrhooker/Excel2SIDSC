set PATHTOPROJECT=Source
set FILENAME=tgpll_registers.xls.xml
set DITAMAPNAME=tgpll_registers.ditamap
cd ..\

set WORKINGDIR=%CD%

cd %WORKINGDIR%\batchfiles

rd /s /q %WORKINGDIR%\out\

#REM java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar   -o:%WORKINGDIR%\out\%DITAMAPNAME% %WORKINGDIR%\%PATHTOPROJECT%\%FILENAME% %WORKINGDIR%\depend\xslt\generate-ditamap.xsl first-row="4"

java -jar %WORKINGDIR%\saxonhe9-3-0-4j\saxon9he.jar   -o:%WORKINGDIR%\out\temp.txt %WORKINGDIR%\%PATHTOPROJECT%\%FILENAME% %WORKINGDIR%\depend\xslt\generate-topics.xsl first-row="4"

cd %WORKINGDIR%\batchfiles