#! /bin/bash

projpath="$(pwd)/";

echo -e "\nUsing project: $projpath";

read -p "Enter package name: " package_name;

# Extract current version from first .csproj file containing "VersionPrefix" line
current_version=$(grep "PackageReference Include=\"${package_name}\"" $projpath/**/*.csproj | head -n 1 | grep -oE "([0-9]+\.)?[0-9]+\.\*")

echo "The current version is: $current_version";
read -p "Enter new version (empty for no change): " new_version;


if [[ $new_version ]]; then
    # Escape any asterisks to prevent clearing properties after the "Version" property
    clean_current_version="${current_version/\*/\\*}"
    # Update all .csproj files that contain "PackageReference"
    find $projpath -type f -name "*.csproj" -exec sed -i "s/PackageReference Include=\"${package_name}\" Version=\"${clean_current_version}\"/PackageReference Include=\"${package_name}\" Version=\"${new_version}\"/" {} \;
fi

bash nuget-localize.sh;

echo ""; # newline
read -p "Clean build? [Y]/N: " do_build
if [[ "$do_build" = "N" || "$do_build" = "n" ]]; then
    exit 0
fi

dotnet clean;
dotnet nuget locals all --clear;
dotnet restore;
dotnet build;

