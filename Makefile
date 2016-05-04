
SHELL = /bin/bash

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

ifeq (${release},)
dist_name = niem-ndr-tools-LATEST
else
dist_name = ${release}
endif

.SECONDARY:

zip_dir = tmp/zip
root_dir = ${zip_dir}/${dist_name}
override root_dir_abs = ${shell mkdir -p ${root_dir} && cd ${root_dir} && pwd}
stow_dir = ${root_dir}/stow

# building some packages requires other packages, so the pile goes on the path, and order matters
PATH := ${root_dir_abs}/bin:${PATH}

stow = stow -v --no-folding

repos_dir= ${zip_dir}/repos
tokens_dir = ${zip_dir}/token

phases = sync configure make install

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

.PHONY: all # build all products (the default target)
all: ${packages:%=${tokens_dir}/install/%}

.PHONY: sync # make sure stuff has been gotten from git repos
sync: ${packages:%=${tokens_dir}/sync/%}

.PHONY: resync # force getting stuff from git repositories
resync:
	${RM} -r ${tokens_dir}/sync
	${MAKE} -f unconfigured.mk sync

.PHONY: install # put stuff in zip dir
install: ${packages:%=${tokens_dir}/install/%}

.PHONY: clean # clean up build products
clean:
	${RM} -r ${zip_dir}

.PHONY: zip # create zip file
zip: ${packages:%=${tokens_dir}/install/%}
	${RM} ${zip_dir}/${dist_name}.zip
	cd ${zip_dir} \
	  && find -L ${dist_name} ! -path "${dist_name}"'/stow/*' -type f -print0 \
	       | xargs -0 zip -9r ${dist_name}.zip

.PHONY: help # print this help
help:
	@ echo Established targets:
	@ sed -e 's/^.PHONY: *\([^ #]*\) *\# *\(.*\)$$/  \1: \2/p;d' zip.mk
	@ echo set variable 'release' to define name of zip

#############################################################################
# packages, in order
#############################################################################
# wrtools-core

.PHONY: wrtools-core
wrtools-core: ${phases:%=${tokens_dir}/%/wrtools_core}

${tokens_dir}/sync/wrtools_core:
	if [[ -d ${stow_dir}/wrtools-core ]]; \
	then cd ${stow_dir}/wrtools-core && git pull; \
	else mkdir -p ${stow_dir} \
	     && cd ${stow_dir} \
	     && git clone ${wrtools_core_repo} wrtools-core; \
	fi
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/configure/wrtools_core: ${tokens_dir}/sync/wrtools_core
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/make/wrtools_core: ${tokens_dir}/configure/wrtools_core
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/install/wrtools_core: ${tokens_dir}/make/wrtools_core
	mkdir -p ${stow_dir} && cd ${stow_dir} && ${stow} --stow wrtools-core
	mkdir -p ${dir $@} && touch $@

#############################################################################
# self

.PHONY: self
self: ${phases:%=${tokens_dir}/%/self}

${tokens_dir}/sync/self:
	rm -rf ${stow_dir}/self
	mkdir -p ${stow_dir}/self
	tar cf - $$(git ls-files) | ( cd ${stow_dir}/self && tar xf -)
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/configure/self: ${tokens_dir}/sync/self
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/make/self: ${tokens_dir}/configure/self
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/install/self: ${tokens_dir}/make/self
	mkdir -p ${stow_dir} && cd ${stow_dir} && ${stow} --stow self
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


