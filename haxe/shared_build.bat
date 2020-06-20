//call shared_test.bat
cd ./projects
haxe ./hxml/shared.hxml
if errorlevel 1 (
    echo Can't build
	pause
	exit 1
) else (
	echo Build OK
)

xcopy /Y .\shared\bin\java\src\shared\shared.jar ..\..\jaicf\libs\shared.jar
pause