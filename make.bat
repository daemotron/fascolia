@ECHO OFF

REM Command file for fascolia Development

if "%1" == "" goto help

if "%1" == "help" (
    :help
    echo.Please use `make ^<target^>` where ^<target^> is one of
    echo.  clean       to clean up stale compiler files
    echo.  virtualenv  to set up the virtual environment
    echo.  test        to run unit tests
    echo.  update      to update local skynet installation
    echo.  docker      to build docker image
    echo.  dist        to build Python package
    echo.  dist-upload to upload Python package to pypi
    goto end
)

if "%1" == "clean" (
	del /q /s *.pyc *.pyo
	goto end
)

if "%1" == "virtualenv" (
    python.exe -m venv venv
	venv\Scripts\pip install -r requirements\development.txt
	venv\Scripts\python setup.py develop
    copy config\pip.ini venv
	echo.
	echo.VirtualENV Setup Complete. Now run: venv\Scripts\activate.bat
	echo
    goto end
)

if "%1" == "test" (
    python -m pytest -v	--cov=skynet --cov-report=term --cov-report=html:coverage-report tests\
    goto end
)

if "%1" == "update" (
    venv\Scripts\python setup.py develop
)

if "%1" == "docker" (
    make.bat clean
    docker build -t skynet:latest .
    goto end
)

if "%1" == "dist" (
    make.bat clean
	for /d %%i in (dist\*) do rmdir /q /s %%i
    del /q /s dist\*
	python setup.py sdist
	python setup.py bdist_wheel
    goto end
)

if "%1" == "dist-upload" (
	twine upload dist\*
    goto end
)

:end