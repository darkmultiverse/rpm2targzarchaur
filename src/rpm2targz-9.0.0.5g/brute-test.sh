#!/bin/bash -e

sparse_file()
{
	rm -f $1
	dd \
		if=.$1 ibs=3 count=1 \
		of=$1  obs=1 seek=$2 \
		2>/dev/null || exit $?
}

echo BZh > .test.bz2.rpm
echo $'\037\213\010' > .test.gz.rpm

for n in {0..30000} ; do
	sparse_file test.bz2.rpm ${n}
	if [[ $(./rpmoffset < test.bz2.rpm) != ${n} ]] ; then
		echo "FAIL: bz2 size ${n}"
		false
	fi

	sparse_file test.gz.rpm ${n}
	if [[ $(./rpmoffset < test.gz.rpm) != ${n} ]] ; then
		echo "FAIL: gz size ${n}"
		false
	fi

	if [[ $((n % 100)) -eq 0 ]] ; then
		echo "${n} offsets passed ..."
	fi
done

rm -f {,.}test.{bz2,gz}.rpm
echo "DONE! :)"
