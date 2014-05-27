
SHELL = /bin/bash

default:
	@printf "Use target:\n"
	@printf "  update: update the subset from the latest in ~/Downloads\n"

update:
	rm -rf subset
	mkdir subset
	find $(HOME)/Downloads/Subset\ *.zip | sort | tail -n 1 | xargs -d $$'\n' unzip -d subset


