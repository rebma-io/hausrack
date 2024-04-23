.PHONY: serve build install

install:
	poetry install --no-root

build:
	poetry run mkdocs build

ghdocs:
	poetry run gh-deploy --force

serve: build
	poetry run mkdocs serve

clean:
	rm -rf site/
