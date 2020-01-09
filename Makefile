SHELL:=/bin/bash

PROJECT_NAME:=DemoLatex
PROJECT_VERSION:=`git describe --long --tags --always --dirty`

DIR_BUILD:=build
DIR_OUTPUT:=out



DIRECTORIES_LIST:="${DIR_OUTPUT}"



default: pdf

all: pdf read

distclean: cleaner



clean:
	@find . \
		-iname '*.aux' \
		-o -iname '*.log' \
		-o -iname '*.out' \
		-o -iname '*.toc' \
		|xargs rm -vf
	@rm -rvf ${DIR_BUILD}



cleaner:
	rm -rvf ${DIR_OUTPUT}



directories:
	for lDir in ${DIRECTORIES_LIST} ; do \
		if [ ! -d "$${lDir}" ] ; then \
			mkdir "$${lDir}"; \
		fi; \
	done

	# Generate in output directory the subdirectories corresponding to the ones in 'src'
	find src/ -type d|sed -e 's@^src@'"${DIR_BUILD}"'@'|xargs mkdir -p



distclean: clean



pdf: directories
	pushd src/ \
	&&  echo "PROJECT_VERSION=$(PROJECT_VERSION)" \
	&&  PROJECT_VERSION="$(PROJECT_VERSION)" \
	    bash ../scripts/latex-build.sh \
	        $(PROJECT_NAME) \
	        master.tex \
	        ../$(DIR_BUILD)

	# copy the generated file to the output directory
	cp ${DIR_BUILD}/${PROJECT_NAME}.pdf ${DIR_OUTPUT}/



read:
	xdg-open ${DIR_OUTPUT}/${PROJECT_NAME}.pdf
