
this_makefile = ${lastword ${MAKEFILE_LIST}}

tokens_dir = tmp/tokens
repos_dir = tmp/repos
niem_ndr_artifacts_repo_dir = ${repos_dir}/niem-ndr-artifacts
niem_ndr_artifacts_repo = https://github.com/webb/niem-ndr-artifacts.git

niem_ndr_artifacts_share_dir = share/niem-ndr-artifacts
niem_ndr_artifacts_v3_dir = ${niem_ndr_artifacts_share_dir}/niem-ndr-3-latest

source_sch = ${wildcard ${niem_ndr_artifacts_v3_dir}/*.sch}
dest_xsl = ${source_sch:%.sch=%.sch.xsl}

#HELP:The default target is "all".
#HELP:Targets:

.PHONY: all #    Do all steps. Steps include:
all:
	${MAKE} clean
	${MAKE} sync
	${MAKE} export
	${MAKE} compile

.PHONY: clean #        Remove build products, omitting out git repos
clean:
	find tmp -mindepth 1 -maxdepth 1 ! -path ${repos_dir} -print0 | xargs -0 rm -rf
	rm -rf share/niem-ndr-artifacts

.PHONY: sync #        Clone or synchronize git repositories
sync:
	if [[ -d ${niem_ndr_artifacts_repo_dir} ]]; \
	then git -C ${niem_ndr_artifacts_repo_dir} pull; \
	else mkdir -p ${repos_dir} \
	    && git clone ${niem_ndr_artifacts_repo} ${niem_ndr_artifacts_repo_dir}; \
	fi

.PHONY: export #        Export NDR artifacts into share directory
export:
	rm -rf ${niem_ndr_artifacts_share_dir}
	mkdir -p ${niem_ndr_artifacts_v3_dir}
	git -C ${niem_ndr_artifacts_repo_dir} archive --format=tar \
	    --prefix=${niem_ndr_artifacts_v3_dir}/ origin/niem-ndr-3-latest \
	  | tar xvf -

.PHONY: compile #        Compile Schematron files into XSLT
compile: ${dest_xsl}

#HELP:Additional targets include:

.PHONY: distclean #    Remove all build products
clean: clean
	rm -rf tmp

.PHONY: help #    Print this help
help:
	@ sed -e '/^\.PHONY:/s/^\.PHONY: *\([^ #]*\) *\#\( *\)\([^ ].*\)/\2\1: \3/p;/^[^#]*#HELP:/s/[^#]*#HELP:\(.*\)/\1/p;d' ${this_makefile}

#############################################################################

%.sch.xsl: %.sch
	schematron-compile --output-file=$@ $<

