#! /bin/bash

projpath="$(pwd)/";

echo -e "\nUsing project: $projpath";

changelog_path="${projpath}CHANGELOG.md";

# Extract current version from first .csproj file containing "VersionPrefix" line
current_version=$(grep "VersionPrefix" $projpath/**/*.csproj | head -n 1 | grep -oE "[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?")

echo "The current version is: $current_version";
read -p "Enter new version (empty for no change): " new_version;

if [[ $new_version ]]; then
    # Update all .csproj files that contain "VersionPrefix"
    find $projpath -type f -name "*.csproj" -exec sed -i "s/$current_version/$new_version/" {} \;
fi

read -p "Update changelog? [Y]/N: " update_changelog
if [[ "$update_changelog" = "N" || "$update_changelog" = "n" ]]; then
    exit 0
fi

# Find changelog line number
changelog_start_line=$(grep -n "\[$current_version\]" $changelog_path | head -n 1 | sed "s/:.*//g");

# Add version number and current date to changelog entry
changelog_entry="## [$new_version] - $(date --iso-8601)\n"

item_type="added"
get_line_items () {
    echo "Enter $item_type items, pressing "Enter" after each one (enter empty line to end)"
    line_items="";
    read_items=true
    
    # Collect line items
    while [ "$read_items" = true ]
    do
        read -p "- " this_line;
        if [[ $this_line ]]; then
            line_items="$line_items\n- $this_line";
        else
            read_items=false;
        fi
    done

    # If any line items were actually added, add a newline after them
    if [[ $line_items ]]; then
        line_items="${line_items}\n"
    fi
}

get_line_items;
if [[ $line_items ]]; then
    changelog_entry="${changelog_entry}\n### Added\n${line_items}";
fi

item_type="changed";
get_line_items;
if [[ $line_items ]]; then
    changelog_entry="${changelog_entry}\n### Changed\n${line_items}";
fi

item_type="removed";
get_line_items;
if [[ $line_items ]]; then
    changelog_entry="${changelog_entry}\n### Removed\n${line_items}";
fi

# Add to changelog
sed -i "${changelog_start_line}i\\${changelog_entry}" $changelog_path
