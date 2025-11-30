function sha-rename --description "rename file with sha1 hash"
    if test (count $argv) -eq 0
        echo "Usage: sha-rename <file>"
        return 1
    end

    set -l original_file $argv[1]
    if not test -e $original_file
        echo "File '$original_file' not found."
        return 1
    end

    set -l sum (shasum -a 1 $original_file | cut -d ' ' -f 1)
    set -l ext (string match -r '\.[^.]*$' $original_file)
    set -l filename "$sum$ext"

    mv $original_file $filename
    echo "File '$original_file' renamed to '$filename'"
end

