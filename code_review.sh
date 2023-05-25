#!/bin/bash

# Get the directory of the bash script
DIR="$(dirname "$0")"

# Check if both branch names are passed
if [ "$#" -ne 2 ]; then
    echo "Incorrect number of arguments supplied."
    echo "You must specify exactly 2 branches for comparison."
    echo "Usage: ./code_review.sh source_branch target_branch"
    echo "Example: ./code_review.sh origin/main origin/my_feature_branch"
    exit 1
fi

BRANCH1=$1
BRANCH2=$2

# Fetch the latest code from origin
git fetch origin

# List the files to exclude
exclude=("package-lock.json" "package.json")

# List the file extensions to exclude
exclude_ext=("json" "lock" "yml" "yaml" "md" "html" "spec.ts")

# Get a list of changed files
FILES=$(git diff --name-only "$BRANCH1".."$BRANCH2")

# Filter out files
FILTERED_FILES=$(echo "$FILES" | awk -v exclude="${exclude[*]}" -v ext="${exclude_ext[*]}" '
BEGIN {
    split(exclude, arr_exclude);
    split(ext, arr_ext);
}
{
    for (i in arr_exclude) {
        if ($0 ~ arr_exclude[i]) {
            next;
        }
    }
    for (i in arr_ext) {
        if ($0 ~ "\\."arr_ext[i]"+$") {
            next;
        }
    }
    print $0
}')

echo "$FILTERED_FILES";

# Iterate over the filtered files
for FILE in $FILTERED_FILES
do
    # Check if the file is in .gitignore
    if git check-ignore -q "$FILE"; then
        echo "Skipping $FILE because it is in .gitignore..."
        continue
    fi

    echo "Processing $FILE..."

    # Create a temporary file for each diff
    TEMP_FILE=$(mktemp)

    # Write the diff to the temporary file
    git diff "$BRANCH1".."$BRANCH2" -- "$FILE" > "$TEMP_FILE"

    echo "Diff saved to $TEMP_FILE"

    # Pass the temporary file path to the Python script
    python3 "$DIR/code_review.py" "$TEMP_FILE"

    echo "The file $FILE processed."
    echo ""
done
