function help() {
    Write-Output "Please use `make <target>` where <target> is one of"
    Write-Output "  clean       to clean up stale compiler files"
    Write-Output "  virtualenv  to set up the virtual environment"
    Write-Output "  test        to run unit tests"
    Write-Output "  update      to update local skynet installation"
    Write-Output "  docker      to build docker image"
    Write-Output "  dist        to build Python package"
    Write-Output "  dist-upload to upload Python package to pypi"
}

function clean() {
    Get-ChildItem * -Include ('*.pyc', '*.pyo') -Recurse  | Remove-Item
}

function virtualenv() {
    python.exe -m venv venv
	.\venv\Scripts\pip.exe install -r requirements-dev.txt
	.\venv\Scripts\python.exe .\setup.py develop
    Copy-Item ".\config\pip.ini" - Destination ".\venv"
	Write-Output ""
	Write-Output "VirtualENV Setup Complete. Now run: venv\Scripts\Activate.ps1"
	Write-Output ""
}

function test() {
    .\venv\Scripts\python.exe -m pytest -v	--cov=skynet --cov-report=term --cov-report=html:coverage-report .\tests
}

function update() {
    .\venv\Scripts\python .\setup.py develop
}

function docker() {
    clean
    docker build -t skynet:latest \.
}

function dist() {
    clean
    if (Test-Path .\dist) {
        Remove-Item .\dist\* -Recurse
    }
    .\venv\Scripts\python.exe .\setup.py sdist
    .\venv\Scripts\python.exe .\setup.py bdist_wheel
}

function distupload() {
    twine upload .\dist\*
}

if ($args[0] -eq 'clean') {
    clean
}
elseif ($args[0] -eq 'virtualenv') {
    virtualenv
}
elseif ($args[0] -eq 'test') {
    test
}
elseif ($args[0] -eq 'update') {
    update
}
elseif ($args[0] -eq 'docker') {
    docker
}
elseif ($args[0] -eq 'dist') {
    dist
}
elseif ($args[0] -eq 'dist-upload') {
    distupload
}
else {
    help
}