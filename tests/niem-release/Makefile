
TOOLS_DIR = ../..
BIN_DIR = $(TOOLS_DIR)/bin
NIEM_RELEASE_DIR = $(TOOLS_DIR)/pkg/niem-release
SCHEMA_DIR = $(NIEM_RELEASE_DIR)/niem
XML_CATALOG = $(NIEM_RELEASE_DIR)/xml-catalog.xml
SCHEMAS = $(shell find $(SCHEMA_DIR) -type f -name '*.xsd' -print)
TEMP_DIR = $(TOOLS_DIR)/tmp
REF_DIR = $(TEMP_DIR)/niem-release-ref-reports
SET_DIR = $(TEMP_DIR)/niem-release-set-reports
REF_REPORTS = $(patsubst $(SCHEMA_DIR)/%,$(REF_DIR)/%,$(SCHEMAS))
SET_REPORTS = $(patsubst $(SCHEMA_DIR)/%,$(SET_DIR)/%,$(SCHEMAS))
REPORTS =$(REF_REPORTS) $(SET_REPORTS)

QUICK_REPORTS = $(REF_DIR)/niem-core/3.0/niem-core.xsd

GET_TEST_REPORT = $(BIN_DIR)/get-test-report

COMMON_DEPENDENCIES = $(TOOLS_DIR)/ndr-functions.xsl $(TOOLS_DIR)/ndr-functions-interface.xsl
REF_DEPENDENCIES =  $(COMMON_DEPENDENCIES) \
	$(TOOLS_DIR)/ndr-rules-conformance-target-ref.sch 
SET_DEPENDENCIES =  $(COMMON_DEPENDENCIES) \
	$(TOOLS_DIR)/ndr-rules-conformance-target-set.sch \
	$(SCHEMAS) \
	$(XML_CATALOG)

help:
	@echo "Pick a target:"
	@echo "  omit: generate report-omit.txt, which omits known reports & asserts"

default: report

reports: $(REF_REPORTS) $(SET_REPORTS)

set: $(SET_REPORTS)

$(REF_DIR)/appinfo/3.0/appinfo.xsd:
	@ mkdir -p $(dir $@)
	> $@

$(REF_DIR)/conformanceTargets/3.0/conformanceTargets.xsd:
	@ mkdir -p $(dir $@)
	> $@

$(REF_DIR)/localTerminology/3.0/localTerminology.xsd:
	@ mkdir -p $(dir $@)
	> $@

$(REF_DIR)/structures/3.0/structures.xsd:
	@ mkdir -p $(dir $@)
	> $@

$(REF_DIR)/external/%:
	@ mkdir -p $(dir $@)
	> $@

ref-nc: 
	rm -f $(REF_DIR)/niem-core/3.0/niem-core.xsd
	$(MAKE) $(REF_DIR)/niem-core/3.0/niem-core.xsd
	cat $(REF_DIR)/niem-core/3.0/niem-core.xsd

$(REF_DIR)/%: $(SCHEMA_DIR)/% $(REF_DEPENDENCIES)
	@ mkdir -p $(dir $@)
	$(GET_TEST_REPORT) --rules=ref $< 2> $@.stderr | sed -e 's!^!$<:!' > $@

$(SET_DIR)/%: $(SCHEMA_DIR)/% $(SET_DEPENDENCIES)
	@ mkdir -p $(dir $@)
	$(GET_TEST_REPORT) --rules=set --xml-catalog=$(XML_CATALOG) $< 2> $@.stderr | sed -e 's!^!$<:!' > $@

clean:
	$(RM) -r $(REF_DIR) $(SET_DIR)
	$(RM) exceptions.sed

report: report.txt

report.txt: $(REPORTS)
	cat $(REPORTS) > $@
	printf '# Local ''Variables:\n' >> $@
	printf '# mode: grep\n' >> $@
	printf '# End:\n' >> $@

omit: report-omit.txt

report-omit.txt: report.txt exceptions.sed
	sed -f exceptions.sed $< > $@

reomit:
	$(RM) -f report-omit.txt
	$(MAKE) report-omit.txt

exceptions.sed: exceptions.txt reported-errors.txt unreported-errors.txt
	rm -f $@
	cat $^ | sed -e 's!/!\\/!g' -e 's!^!/!' -e 's!$$!/d!' > $@
	chmod -w $@

.PHONY: quick
quick: rm-quick quick.txt

rm-quick:
	$(RM) quick.txt

quick.txt: $(QUICK_REPORTS) exceptions.sed
	cat $(QUICK_REPORTS) | sed -f exceptions.sed > $@
	printf '# Local ''Variables:\n' >> $@
	printf '# mode: grep\n' >> $@
	printf '# End:\n' >> $@
