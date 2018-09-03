.PHONY: clean virtualenv test update docker dist dist-upload

clean:
	find . -name '*.py[co]' -delete

virtualenv:
	python -m venv venv
	venv/bin/pip install -r requirements/development.txt
	venv/bin/python setup.py develop
	cp config/pip.ini venv/pip.conf
	@echo
	@echo "VirtualENV Setup Complete. Now run: source venv/bin/activate"
	@echo

test:
	python -m pytest \
		-v \
		--cov=skynet \
		--cov-report=term \
		--cov-report=html:coverage-report \
		tests/

update:
	venv/bin/python setup.py develop

docker: clean
	docker build -t skynet:latest .

dist: clean
	rm -rf dist/*
	python setup.py sdist
	python setup.py bdist_wheel

dist-upload:
	twine upload dist/*
