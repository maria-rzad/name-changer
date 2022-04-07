#!/bin/bash
# Created by Maria Rzad

chmod 755 modify.sh
if [ -d tests ]
then
	rm -r tests
fi
cp -R test_template tests
cd tests

test_case()
{
	echo "TEST $1"; shift
	cd "$1"; shift
	echo "modify.sh $*"
	rec=$1; shift
	echo "before:"
	display $rec
	../../modify.sh $*
	echo "after:"
	display $rec
	cd ..
	echo
}

display()
{
	if [ $1 -eq 1 ]
	then
		find .
	else
		ls
	fi
}

input_error_case()
{
	echo "TEST $1"; shift
}
# test_case <description> <directory> <recursion> <args for modify...>

test_case "1: to lowercase" test1 0 -l lowercase mIXeD with_extension.txt UPPERCASE.txt direCTORY

test_case "2: to uppercase" test2 0 -u lowercase.txt mIXeD.txt no_extension UPPERCASE.txt

test_case "3: file with a new name already exists" test3 0 -u i_exist.txt

test_case "4: file does not exist" test3 0 -l i_do_not_exist

test_case "5: recursion" test4 1 -u -r subdirectory1 subdirectory2 some_file.docx

test_case "6: names with spaces" test5 1 -u -r spaces

test_case "7: custom sed" test6 1 -r s/hello/bye/ greetings
