# This file is part of power-ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

NAME = power-ranger
VERSION = $(shell grep -m 1 -o '[0-9][0-9.]\+\S*' README.md)
NAME_RIFLE = rifle
VERSION_RIFLE = $(VERSION)
SNAPSHOT_NAME ?= $(NAME)-$(VERSION)-$(shell git rev-parse HEAD | cut -b 1-8).tar.gz
# Find suitable python version (need python >= 2.6 or 3.1):
PYTHON ?= $(shell \
	     (python -c 'import sys; sys.exit(sys.version < "2.6")' && \
	      which python) \
	     || (which python3) \
	     || (python2 -c 'import sys; sys.exit(sys.version < "2.6")' && \
	         which python2) \
	   )
ifeq ($(PYTHON),)
  $(error No suitable python found.)
endif
SETUPOPTS ?= '--record=install_log.txt'
DOCDIR ?= doc/pydoc
DESTDIR ?= /
PYOPTIMIZE ?= 1
FILTER ?= .

CWD = $(shell pwd)

default: test compile
	@echo 'Run `make options` for a list of all options'

options: help
	@echo
	@echo 'Options:'
	@echo 'PYTHON = $(PYTHON)'
	@echo 'PYOPTIMIZE = $(PYOPTIMIZE)'
	@echo 'DOCDIR = $(DOCDIR)'
	@echo 'DESTDIR = $(DESTDIR)'

help:
	@echo 'make:              Test and compile power-ranger.'
	@echo 'make install:      Install $(NAME)'
	@echo 'make pypi_sdist:   Release a new sdist to PyPI'
	@echo 'make clean:        Remove the compiled files (*.pyc, *.pyo)'
	@echo 'make doc:          Create the pydoc documentation'
	@echo 'make cleandoc:     Remove the pydoc documentation'
	@echo 'make man:          Compile the manpage with "pod2man"'
	@echo 'make manhtml:      Compile the html manpage with "pod2html"'
	@echo 'make snapshot:     Create a tar.gz of the current git revision'
	@echo 'make test:         Test everything'
	@echo 'make test_pylint:  Test using pylint'
	@echo 'make test_flake8:  Test using flake8'
	@echo 'make test_doctest: Test using doctest'
	@echo 'make test_pytest:  Test using pytest'
	@echo 'make todo:         Look for TODO and XXX markers in the source code'

install:
	$(PYTHON) setup.py install $(SETUPOPTS) \
		'--root=$(DESTDIR)' --optimize=$(PYOPTIMIZE)

compile: clean
	PYTHONOPTIMIZE=$(PYOPTIMIZE) $(PYTHON) -m compileall -q power-ranger

clean:
	find power-ranger -regex .\*\.py[co]\$$ -delete
	find power-ranger -depth -name __pycache__ -type d -exec rm -r -- {} \;

doc: cleandoc
	mkdir -p $(DOCDIR)
	cd $(DOCDIR); \
		$(PYTHON) -c 'import pydoc, sys; \
		sys.path[0] = "$(CWD)"; \
		pydoc.writedocs("$(CWD)")'
	find . -name \*.html -exec sed -i 's|'"$(CWD)"'|../..|g' -- {} \;

TEST_PATHS_MAIN = \
	$(shell find ./power-ranger -mindepth 1 -maxdepth 1 -type d \
		! -name '__pycache__' \
		! -path './power-ranger/config' \
		! -path './power-ranger/data' \
	) \
	./power-ranger/__init__.py \
	$(shell find ./doc/tools ./examples -type f -name '*.py') \
	./power-ranger.py \
	./setup.py \
	./tests
TEST_PATH_CONFIG = ./power-ranger/config

test_pylint:
	@echo "Running pylint..."
	pylint $(TEST_PATHS_MAIN)
	pylint --rcfile=$(TEST_PATH_CONFIG)/.pylintrc $(TEST_PATH_CONFIG)

test_flake8:
	@echo "Running flake8..."
	flake8 $(TEST_PATHS_MAIN) $(TEST_PATH_CONFIG)

test_doctest:
	@echo "Running doctests..."
	@for FILE in $(shell grep -IHm 1 doctest -r power-ranger | grep $(FILTER) | cut -d: -f1); do \
		echo "Testing $$FILE..."; \
		RANGER_DOCTEST=1 PYTHONPATH=".:"$$PYTHONPATH ${PYTHON} $$FILE; \
	done

test_pytest:
	@echo "Running py.test tests..."
	py.test tests

test_other:
	@echo "Checking completeness of man page..."
	@tests/manpage_completion_test.py

test: test_pylint test_flake8 test_doctest test_pytest test_other
	@echo "Finished testing: All tests passed!"

man:
	pod2man --stderr --center='power-ranger manual' --date='$(NAME)-$(VERSION)' \
		--release=$(shell date +%x) doc/power-ranger.pod doc/power-ranger.1
	pod2man --stderr --center='rifle manual' --date='$(NAME_RIFLE)-$(VERSION_RIFLE)' \
		--release=$(shell date +%x) doc/rifle.pod doc/rifle.1

manhtml:
	pod2html doc/power-ranger.pod --outfile=doc/power-ranger.1.html

cleandoc:
	test -d $(DOCDIR) && rm -- $(DOCDIR)/*.html || true

snapshot:
	git archive --prefix='$(NAME)-$(VERSION)/' --format=tar HEAD | gzip > $(SNAPSHOT_NAME)

dist: snapshot

todo:
	@grep --color -Ion '\(TODO\|XXX\).*' -r power-ranger

.PHONY: clean cleandoc compile default dist doc help install man manhtml \
	options snapshot test test_pylint test_flake8 test_doctest test_pytest \
	test_other todo pypi_sdist
