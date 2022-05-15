#!/bin/bash
#
# Expected test layout:
# test/
#  rpm/   put all rpms here
#  tmp/   scratch space for testing
#  lst/   known good listings
#

cd "${0%/*}" || exit 1

if [ ! -e test ] ; then
	echo "Sorry, no test data (test/)"
	exit 0
fi

# This can be verbose, so do it before `set -x`
PATH=$PWD:$PATH

set -ex

which rpmunpack
which rpm2tar

cd test

rm -rf tmp
mkdir tmp
cd tmp

fail=
for rpm in ../rpm/*.rpm ; do
	r=${rpm##*/}
	if ! rpmunpack ${rpm} ; then
		fail+=" ${r}"
		continue
	fi
	# do not track timestamps as some cpio archives
	# only contain info for the files, not the dirs
	tree -apsn -o ../${r}.lst
	mv ../${r}.lst ./
	diff -u ${r}.lst ../lst/
	rm -rf ./*
done

set +x
if [[ -n ${fail} ]] ; then
	echo "FAILED:" ${fail}
else
	echo "ALL PASSED"
fi
