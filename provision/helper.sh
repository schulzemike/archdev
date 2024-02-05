#!/bin/bash


function createDirIfNotExist() {
	if [[ $# -ne 1 ]]; then
		echo "Provide the name of the directory" >&2
		exit 1
	fi

	[[ -d $1 ]] || mkdir -p $1
}