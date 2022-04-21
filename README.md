# name-changer
Shell script for changing file names

<b>Script modify.sh works with the following syntax:</b>

    modify.sh [-r] [-l|-u] <dir/file names...>
  
    modify.sh [-r] <sed pattern> <dir/file names...>
    
    modify.sh [-h]
  
  <b>-l</b>   &ensp;&ensp;&ensp;change to lowercase letters
    
  <b>-u</b>   &ensp;&ensp;&ensp;change to uppercase letters
    
  <b>-r</b>   &ensp;&ensp;&ensp;recursive mode, change all contents of a directory
    
  <b>-h</b>   &ensp;&ensp;&ensp;help
  
  <b>Example of usage:</b>
    
    modify.sh -r -l file1.txt "file 2.docx" directory1
		
	modify.sh s/e/o/g filename
