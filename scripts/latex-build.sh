#!/bin/bash

set -e
set -x

function	F_usage()
{
	echo "Usage: $0 <project_name> <master_file.tex> <output_directory>"
}



function	F_bibliography()
{
	pushd "${pOutputDirectory}"
		export BIBINPUTS="../src/30-backmatter/bibliography/;${BIBINPUTS}"
		export BSTINPUTS="../src/;${BSTINPUTS}"
		bibtex \
			"${pProjectName}"
	popd
}



function	F_build()
{
	pdflatex \
		-halt-on-error \
		-interaction=nonstopmode \
		-output-directory="${pOutputDirectory}" \
		-jobname="${pProjectName}" \
		"\def\documentVersion{${pProjectVersion}} \input{${pFileMaster}}" #\
		#-include-directory=src/
}



function	F_makeGlossaries()
{
	makeglossaries \
		-d "${pOutputDirectory}" \
		"${pProjectName}"
		#$(basename ${pFileMaster} .tex)
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


pProjectVersion="${PROJECT_VERSION}"
if [ -z "${pProjectVersion}" ]
then
	pProjectVersion="[unknown]"
fi


# Compile
#pushd "${pDirBase}"

# Compile for the first time
F_build

# Generate bibliography
F_bibliography

# Generate glossaries
F_makeGlossaries

# Compile again to solve references troubles.
F_build
F_build



#popd

exit $?
