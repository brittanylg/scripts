#!/bin/bash

read -a paths_arr <<< "read-string-of-paths as-array-of-paths"

comment_str=(
    '<!-- BEGIN_TF_DOCS -->'
    '<!-- END_TF_DOCS -->'
)

for path in "${paths_arr[@]}"
do
    # if a readme already exists, check for the comments in $comment_str
    # this will prevent duplication of documentation in readmes where docs 
    # exist but do not have the required comments
    if [ -f "$path/README.md" ]
    then
        for str in "${comment_str[@]}"
        do
            if ! grep -qF -e "$str" "$path/README.md"
            then
                echo "Did not find $str, exiting"
                exit
            fi
        done
    fi
    ## TODO: add a check for .terraform-docs.yml
    terraform-docs markdown table --output-file README.md --output-mode inject $path
done

if [ -z "$(git status --porcelain)" ]
then
    echo "No changes to readme, nothing to commit"
else
    git add "./*README.md"
    git commit -m "Update terraform docs in readme to reflect changes to resources"
fi
