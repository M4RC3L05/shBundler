# Simple bundler for shell scripts

## Usage

1.  Clone repo

2.  Compile: ./index.sh \<entry file path> \<output dir> \<output filename (optional)>

    ```bash
    host@name:~$ ./index.sh ./index.sh ./dist shBundler.sh
    ```

    or execute `build.sh`

3.  expose the compiled file to you path

4.  To use on your own project, create an entry file where you import the files you use.

    You can use

    -   "source \<filepath>",
    -   ". \<filepath>"
    -   "#import \<filepath>"
    -   (New) Named Imports
        -   "#import { \<fnName>, \<...otherFnNames> } \<filepath>" (You will have to import the function dependencies before)

5.  Now run de command with the name of the created entry file
    ```bash
    host@name:~$ shBundler.sh <entry file path> <output dir> <output filename>
    ```
