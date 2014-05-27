
update-subset: 
	rm -rf niem wantlist.xml xml-catalog.xml
	find $(HOME)/Downloads/Subset\ *.zip | sort | tail -n 1 | xargs -d $$'\n' unzip


update:
	rm -rf subset
	mkdir subset
	find $(HOME)/Downloads/Subset\ *.zip | sort | tail -n 1 | xargs -d $$'\n' unzip -d subset


