#! /bin/bash

local_source_text="    <add key=\"local\" value=\"/home/wilqo/local-nuget\" />";
nugetpath="$(pwd)/nuget.config";

echo -e "\nLocalizing nuget: $nugetpath";

found_match=$(grep "$local_source_text" "$nugetpath" | wc -l);

if [[ found_match -gt 0 ]]; then
    echo "Already localized.";
    exit 0;
fi

# Find changelog line number
nuget_start_line=$(grep -n "DevelopmentFeed" $nugetpath | head -n 1 | sed "s/:.*//g");

# Add to nuget.config
sed -i "${nuget_start_line}i\\${local_source_text}" $nugetpath;

echo "Done."

