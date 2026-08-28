#! /bin/bash

local_nuget_path="/home/wilqo/local-nuget/"

projpath="$(pwd)/";

echo -e "\nUsing project: $projpath";

# Extract current version from first .csproj file containing "VersionPrefix" line
current_version=$(grep "VersionPrefix" $projpath/**/*.csproj | head -n 1 | grep -oE "[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?")
echo "Found version ${current_version}";

read -p "Build first? [Y]/N: " do_build
if [[ "$do_build" != "N" && "$do_build" != "n" ]]; then
    dotnet build;
fi

# If the current version has more than three version sections (ex A.B.C.D not A.B.C), and the last section
#   ends in a ".0", remove the ".0" because the bin file will not include it in the filename
if [ $(echo $current_version | tr -cd "." | wc -c) -gt 2 ] && [[ "$current_version" == *.0 ]]; then
    current_version=${current_version::-2}
fi

echo "Deploying:"
find $projpath**/bin/Debug/* -type f -name "*$current_version*" -exec cp -v {} $local_nuget_path \;

