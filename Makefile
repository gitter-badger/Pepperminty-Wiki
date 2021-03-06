.DEFAULT_GOAL := peppermint

.PHONY: setupApiDoc peppermint docs gh-pages

ApiDocPresent := $(shell sh -c apidoc --help 1\>/dev/null && rm -rf doc/)

peppermint:
	@echo [peppermint/build] Rebuilding Pepperminty Wiki
	php build.php

docs: setupApiDoc
	@echo [peppermint/docs] Building docs
	apidoc -o './RestApiDocs/' --config apidoc.json -f '.*\.php' -e index.php
	rm -rf doc/

setupApiDoc:
	@echo [peppermint] Checking for apiDoc
ifndef ApiDocPresent
	@echo [peppermint] Attempting to install ApiDoc, since it wasn't detected in your PATH
	@echo [peppermint] Note that you may need to be root, and you'll need npm installed.
	npm install apidoc --global
endif
	@echo [peppermint] Check complete

gh-pages:
	@echo [peppermint/gh-pages] Syncing master branch with gh-pages branch.
	@echo [peppermint/gh-pages] Making sure the working directory is clean.
	# From http://unix.stackexchange.com/a/155077/64687
	git diff --exit-code
	git diff --cached --exit-code
	
	git checkout gh-pages
	git rebase master
	git push origin gh-pages
	git checkout master
	@echo '[peppermint/gh-pages] Sync complete.'
