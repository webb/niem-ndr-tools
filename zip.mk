
SHELL = /bin/bash -o pipefail -o nounset -o errexit

# Copyright 2015 Georgia Tech Research Corporation (GTRC). All rights reserved.

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.

# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

release = ${shell git describe --tags 2> /dev/null}

#HELP:Set variable 'release' to define the name of the zip file
ifeq (${release},)
dist_name = niem-ndr-tools-LATEST
else
dist_name = ${release}
endif

.SECONDARY:

root_dir = tmp/${dist_name}
override root_dir_abs = ${shell mkdir -p ${root_dir} && cd ${root_dir} && pwd}

# building some packages requires other packages, so the pile goes on the path, and order matters
PATH := ${root_dir_abs}/bin:${PATH}

repos_dir= tmp/repos
tokens_dir = tmp/tokens

# stages are:
#  * sync
#  * install

#HELP:Set variable "packages" to narrow the focus to specific child packages
# order matters here
packages = \
	wrtools_core \
	saxon_cli \
	xalan_cli \
	schematron_cli \
	xml_schema_validator \
	self \

saxon_cli_repo            = https://github.com/webb/saxon-cli.git
schematron_cli_repo       = https://github.com/webb/schematron-cli.git
wrtools_core_repo         = https://github.com/webb/wrtools-core.git
xalan_cli_repo            = https://github.com/webb/xalan-cli.git
xml_schema_validator_repo = https://github.com/webb/xml-schema-validator.git

#HELP:The default target is "zip". Other targets include:

.PHONY: zip #  create zip file
zip: ${packages:%=${tokens_dir}/install/%}
	${RM} tmp/${dist_name}.zip
	cd tmp && zip -9r ${dist_name}.zip ${dist_name}

# install phase needs to put stuff into ${root_dir}
.PHONY: install #  Put stuff in zip dir
install: ${packages:%=${tokens_dir}/install/%}

.PHONY: sync #  Make sure stuff has been fetched from git repos
sync: ${packages:%=${tokens_dir}/sync/%}

.PHONY: clean #  Clean up build products, but don't erase saved repos
clean:
	find tmp -mindepth 1 -maxdepth 1 ! -path ${repos_dir} -print0 | xargs -0 rm -rf

.PHONY: distclean #  Clean up all build products
distclean:
	rm -rf tmp

.PHONY: help #  print this help
help:
	@ sed -e '/^\.PHONY:/s/^\.PHONY: *\([^ #]*\) *\#\( *\)\([^ ].*\)/\2\1: \3/p;/^[^#]*#HELP:/s/[^#]*#HELP:\(.*\)/\1/p;d' zip.mk

#############################################################################
# self

${tokens_dir}/sync/self:
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/install/self:
	stow --no-folding --dir=.. --target=${root_dir} --stow ${shell basename ${PWD}}
	mkdir -p ${dir $@} && touch $@

#############################################################################
# wrtools_core

${tokens_dir}/install/wrtools_core: ${tokens_dir}/sync/wrtools_core
	stow --no-folding --dir=${repos_dir} --target=${root_dir} --stow wrtools_core
	mkdir -p ${dir $@} && touch $@

#############################################################################
# schematron-cli

${tokens_dir}/install/schematron_cli: ${tokens_dir}/sync/schematron_cli
	stow --no-folding --dir=${repos_dir} --target=${root_dir} --stow schematron_cli
	mkdir -p ${dir $@} && touch $@

#############################################################################
# defaults

${tokens_dir}/sync/%:
	if [[ -d ${repos_dir}/$* ]]; \
	then cd ${repos_dir}/$* && git pull; \
	else mkdir -p ${repos_dir} \
	     && cd ${repos_dir} \
	     && git clone ${$*_repo} $*; \
	fi
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/configure/%: ${tokens_dir}/sync/%
	cd ${repos_dir}/$* && ./configure --prefix=${root_dir_abs}
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/make/%: ${tokens_dir}/configure/%
	make -C ${repos_dir}/$*
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/install/%: ${tokens_dir}/make/%
	make -C ${repos_dir}/$* install
	mkdir -p ${dir $@} && touch $@


