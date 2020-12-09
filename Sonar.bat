@ECHO OFF
cls
SETLOCAL EnableDelayedExpansion
@CHCP 65001 >NUL
cls
echo.

echo.
echo     _____                        _____                                 
echo    / ___/____  ____  ____ ______/ ___/_________ _____  ____  ___  _____
echo    \__ \/ __ \/ __ \/ __ `/ ___/\__ \/ ___/ __ `/ __ \/ __ \/ _ \/ ___/
echo   ___/ / /_/ / / / / /_/ / /   ___/ / /__/ /_/ / / / / / / /  __/ /    
echo  /____/\____/_/ /_/\__,_/_/   /____/\___/\__,_/_/ /_/_/ /_/\___/_/     
echo.
echo #######################################################################
echo Command Args 									 
echo Sonar.bat "Path" "Solution/ProjectName" "Type" "Version"
echo.
echo Type
echo core    -- NetCore 2.0 to 3.1
echo fw      -- framework 4.0 to 4.8
echo php     -- PHP5 to PHP7
echo Angular -- AngularV4 to AngularV6
echo React   -- React Native with NodeJS 
echo #######################################################################
echo.
REM Configurações do Sonar
SET PathSonar=C:\SonarScanner
SET PathMSBuild=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin
SET PathNuget=C:\SonarScanner\
SET SonarLogin=admin
SET SonarPassword=admin
SET SonarHost=http://localhost:9000
echo.
"%PathNuget%\nuget.exe" config -configFile %PathNuget%\nuget.config
echo.
set ProjectPath=%1
set ProjectName=%2
set ProjectCore=%3
set ProjectVersion=%4
echo Solution (.sln)
echo.
set ProjectCore = "fw"
IF [%1]==[]	set /p ProjectPath="Path of Solution: " else set ProjectPath=%1
IF [%2]==[] set /p ProjectName="Solution Name (Project Name): " else set ProjectName=%2
IF [%3]==[] set /p ProjectCore="Type of Solution (Core/FW/PHP/Angular/React): " else set ProjectCore=%3
IF [%4]==[] set /p ProjectVersion="Version (INC/CRD/MASTER): " else set ProjectVersion=%4
echo.
REM Remover o espaços e acentuações do ProjectKey
REM var com_acento = "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝŔÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŕ";
REM var sem_acento = "AAAAAAACEEEEIIIIDNOOOOOOUUUUYRsBaaaaaaaceeeeiiiionoooooouuuuybyr";
set ProjectKey1=%ProjectName: =_%
set ProjectKey2=%ProjectKey1:ç=c%
set ProjectKey3=%ProjectKey2:ã=a%
set ProjectKey4=%ProjectKey3:é=e%
set ProjectKey=%ProjectKey4:õ=o%
REM Exibir as informações na tela
echo Path: %ProjectPath%
echo Solution: %ProjectName%
echo Type of Solution: %ProjectCore%
echo Version: %ProjectVersion%
echo Project Key: %ProjectKey%
echo.

IF "%ProjectCore%" == "fw" GOTO PROCFW 
IF "%ProjectCore%" == "FW" GOTO PROCFW 
IF "%ProjectCore%" == "Fw" GOTO PROCFW 
IF "%ProjectCore%" == "fW" GOTO PROCFW 

IF "%ProjectCore%" == "core" GOTO PROCCORE 
IF "%ProjectCore%" == "Core" GOTO PROCCORE 
IF "%ProjectCore%" == "CORE" GOTO PROCCORE 


IF "%ProjectCore%" == "PHP" GOTO PROCPHP 
IF "%ProjectCore%" == "php" GOTO PROCPHP 
IF "%ProjectCore%" == "Php" GOTO PROCPHP 

IF "%ProjectCore%" == "Angular" GOTO PROCTS 
IF "%ProjectCore%" == "angular" GOTO PROCTS 
IF "%ProjectCore%" == "ANGULAR" GOTO PROCTS 

IF "%ProjectCore%" == "React" GOTO PROCREACT 
IF "%ProjectCore%" == "react" GOTO PROCREACT 
IF "%ProjectCore%" == "REACT" GOTO PROCREACT 
IF "%ProjectCore%" == "Native" GOTO PROCREACT 
IF "%ProjectCore%" == "native" GOTO PROCREACT 
IF "%ProjectCore%" == "NATIVE" GOTO PROCREACT 
IF "%ProjectCore%" == "React Native" GOTO PROCREACT 
IF "%ProjectCore%" == "react native" GOTO PROCREACT 
IF "%ProjectCore%" == "REACT NATIVE" GOTO PROCREACT 

GOTO FIM

:PROCCORE
	SET PathSonar="%PathSonar%\netcore"
	SET OLDPATH = %PATH%
	SET PATH = %PATH%;%PathMSBuild%;%PathSonar%;
	dotnet restore --configfile %PathNuget%\nuget.config --ignore-failed-sources
	dotnet restore  "%ProjectPath%\%ProjectName%"
	echo.
	echo SonarQube.Scanner Begin
	dotnet %PathSonar%\SonarScanner.MSBuild.dll begin /k:"%ProjectKey%" /n:"%ProjectKey%" /v:"%ProjectVersion%" /s:%PathSonar%\SonarQube.Analysis.xml /d:sonar.scm.provider=git /d:sonar.host.url=%SonarHost% /d:sonar.login=%SonarLogin% /d:sonar.password=%SonarPassword% 
	echo.
	echo dotnet (2.2) - Build this project %ProjectName%
	dotnet build "%ProjectPath%\%ProjectName%" --verbosity minimal --no-incremental --ignore-failed-sources
	echo.
	echo SonarQube.Scanner End
	dotnet %PathSonar%\SonarScanner.MSBuild.dll end /d:sonar.login=%SonarLogin% /d:sonar.password=%SonarPassword% 
	echo.
	GOTO FIM
:PROCFW
	set PathSonar="%PathSonar%\FW"
	SET OLDPATH = %PATH%
	SET PATH = %PATH%;%PathMSBuild%;%PathSonar%;
	echo Nuget restore
	"%PathNuget%\nuget.exe" restore "%ProjectPath%\%ProjectName%"
	echo.
	echo.
	echo SonarQube.Scanner Begin
	"%PathSonar%\SonarScanner.MSBuild.exe" begin /k:"%ProjectKey%" /n:"%ProjectKey%" /v:"%ProjectVersion%" /s:%PathSonar%\SonarQube.Analysis.xml /d:sonar.scm.provider=git /d:sonar.host.url=%SonarHost% /d:sonar.login=%SonarLogin% /d:sonar.password=%SonarPassword% 
	echo.
	echo MSBuild 16+ (VS2019) - Build this project %ProjectName%
	"%PathMSBuild%\MSBuild.exe" "%ProjectPath%\%ProjectName%" -t:Build -v:minimal -ignoreprojectextensions:isproj
	echo.
	echo SonarQube.Scanner End
	"%PathSonar%\SonarScanner.MSBuild.exe" end  /d:sonar.login=%SonarLogin% /d:sonar.password=%SonarPassword% 
	echo.
	GOTO FIM
:PROCPHP
	set PathSonar="%PathSonar%\sonar-scanner-4.1.0.1829"
	SET OLDPATH = %PATH%
	SET PATH = %PATH%;%PathMSBuild%;%PathSonar%;
	set MYFILE="%ProjectPath%\sonar-%ProjectName%.properties"
	IF EXIST %MYFILE% DEL /F %MYFILE%
	echo.
	echo Create a config file in %MYFILE%
	@echo sonar.host.url=%SonarHost%> %MYFILE%
	@echo sonar.login=%SonarLogin% >> %MYFILE%
	@echo sonar.password=%SonarPassword% >> %MYFILE%
	@echo sonar.sourceEncoding=UTF-8 >> %MYFILE%
	@echo sonar.projectKey=%ProjectKey% >> %MYFILE%
	@echo sonar.projectName=%ProjectName% >> %MYFILE%
	@echo sonar.projectVersion=%ProjectVersion% >> %MYFILE%
	@echo sonar.sources=. >> %MYFILE%
	@echo sonar.scm.provider=git >> %MYFILE%
	echo.
	echo File create %MYFILE%
	cd \
	cd %ProjectPath%
	echo.
	echo Execute SonarScanner
	%PathSonar%\bin\sonar-scanner.bat -Dproject.settings=%MYFILE%
	echo.
	IF EXIST %MYFILE% DEL /F %MYFILE%
	echo.
	GOTO FIM
:PROCTS
	set PathSonar="%PathSonar%\sonar-scanner-4.1.0.1829"
	SET OLDPATH = %PATH%
	SET PATH = %PATH%;%PathMSBuild%;%PathSonar%;
	set MYFILE="%ProjectPath%\sonar-%ProjectName%.properties"
	IF EXIST %MYFILE% DEL /F %MYFILE%
	echo.
	echo Create a config file in %MYFILE%
	@echo sonar.host.url=%SonarHost%> %MYFILE%
	@echo sonar.login=%SonarLogin% >> %MYFILE%
	@echo sonar.password=%SonarPassword% >> %MYFILE%
	@echo sonar.sourceEncoding=UTF-8 >> %MYFILE%
	@echo sonar.projectKey=%ProjectKey% >> %MYFILE%
	@echo sonar.projectName=%ProjectName% >> %MYFILE%
	@echo sonar.projectVersion=%ProjectVersion% >> %MYFILE%
	@echo sonar.sources=src >> %MYFILE%
	@echo sonar.exclusions=**/node_modules/**,**/node_modules/**/*,**/*.spec.ts,**/*.symlink >> %MYFILE%
	@echo sonar.tests=src >> %MYFILE%
	@echo sonar.test.inclusions=**/*.spec.ts >> %MYFILE%
	@echo sonar.ts.tslintconfigpath=tslint.json >> %MYFILE%
	@echo sonar.scm.provider=git >> %MYFILE%
	echo.
	echo File create %MYFILE%
	cd \
	cd %ProjectPath%
	echo.
	echo Execute SonarScanner
	%PathSonar%\bin\sonar-scanner.bat -Dproject.settings=%MYFILE%
	echo.
	IF EXIST %MYFILE% DEL /F %MYFILE%
	echo.
	GOTO FIM
:PROCREACT
	set PathSonar="%PathSonar%\sonar-scanner-4.1.0.1829"
	SET OLDPATH = %PATH%
	SET PATH = %PATH%;%PathMSBuild%;%PathSonar%;
	set MYFILE="%ProjectPath%\sonar-%ProjectName%.properties"
	IF EXIST %MYFILE% DEL /F %MYFILE%
	echo.
	echo Create a config file in %MYFILE%
	@echo sonar.host.url=%SonarHost%> %MYFILE%
	@echo sonar.login=%SonarLogin% >> %MYFILE%
	@echo sonar.password=%SonarPassword% >> %MYFILE%
	@echo sonar.sourceEncoding=UTF-8 >> %MYFILE%
	@echo sonar.projectKey=%ProjectKey% >> %MYFILE%
	@echo sonar.projectName=%ProjectName% >> %MYFILE%
	@echo sonar.projectVersion=%ProjectVersion% >> %MYFILE%
	@echo sonar.sources=App >> %MYFILE%
	@echo sonar.javascript.file.suffixes=.js,.jsx >> %MYFILE%
	@echo sonar.exclusions=**/android/**,**/ios/**,**/android/**/*,**/ios/**/*,**/*.java,**/*.h,**/*.symlink >> %MYFILE%
	@echo sonar.scm.provider=git >> %MYFILE%
	echo.
	echo File create %MYFILE%
	cd \
	cd %ProjectPath%
	echo.
	echo Execute SonarScanner
	%PathSonar%\bin\sonar-scanner.bat -Dproject.settings=%MYFILE%
	echo.
	IF EXIST %MYFILE% DEL /F %MYFILE%
	echo.
	GOTO FIM
:FIM
echo.
SET PATH = %OLDPATH%
echo Processo de analise finalizado
echo.
pause