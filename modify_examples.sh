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

test_error()
{
	echo "modify.sh $*"
	../modify.sh $*
	echo
	
}
# test_case <description> <directory> <recursion> <args for modify...>

test_case "1: multiple files to uppercase" test1 0 -u lowercase mIXeD with_extension.txt UPPERCASE direCTORY

test_case "2: custom sed" test2 0 s/hello/bye/ hello_everyone hello_world

test_case "3: file with a new name already exists" test3 0 -l EXISTING_FILE

test_case "4: file does not exist" test3 0 -u nonexistent_file

test_case "5: recursion" test4 1 -u -r subdirectory1 subdirectory2 some_file

test_case "6: names with spaces" test5 1 -u -r spaces

echo "INCORRECT INPUT TESTS"
test_error

test_error -h -l

test_error -u -l -r file

test_error -u -k file

test_error h/e/l/l/o file
