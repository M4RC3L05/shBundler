# Simple bundler for shell scripts

## Usage

1. Clone repo

2. Compile: ./index.sh \<entry file path> \<output dir> \<output filename (optional)>

    ```console
    host@name:~$ ./index.sh ./dist shBundler.sh
    ```

3. expose the compiled file to you path

4. To use on your own project, create an entry file where you import the files you use.

    You can use "source \<filepath>", ". \<filepath>" ou "#import \<filepath>".

5. Now run de command with the name of the created entry file
    ```console
    host@name:~$ shBundler.sh <entry file path> <output dir> <output filename>
    ```
