#!/bin/bash

set -e
set -x

function	F_usage()
{
	echo "Usage: $0 <project_name> <master_file.tex> <output_directory>"
}


pScriptName="$0"

#shift
#pProjectName="$(pwd)/$(dirname $0)"
pProjectName="$1"

shift
#pDirBase="$(pwd)/$(dirname $0)"
#pFileMaster="$(basename $0)"
pFileMaster="$1"

shift
pOutputDirectory="$1"



# Check pre-conditions
if    [ -z "${pFileMaster}" ] ||  [ -z "${pProjectName}" ] ||  [ -z "${pOutputDirectory}" ]
then
	F_usage
	exit 1
fi


# Compile
#pushd "${pDirBase}"

	# Compile
	pdflatex \
		-halt-on-error \
		-interaction=nonstopmode \
		-output-directory="${pOutputDirectory}" \
		-jobname="${pProjectName}" \
		${pFileMaster} #\
		#-include-directory=src/

#popd

exit $?
