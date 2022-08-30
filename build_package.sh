#!/bin/bash

version=3.1.1
sha512_source="9030b5249c149db8a5b2fe350f71613e4ee91061765a771640ed3ffa7c24aada4000ba884ef91790fdc0f13dc4519038c1edeba64b85b85ac09c3e955a7988a1"

echo "Creating build folders"
rm -rf ./build
mkdir -p ./build


echo ""

echo "Downloading and verifying SQLiteC++ sources"

curl -L -o "./build/sqlitecpp_$version.orig.tar.gz" "https://github.com/SRombauts/SQLiteCpp/archive/${version}.tar.gz"
main_sum=$(sha512sum "./build/sqlitecpp_$version.orig.tar.gz" | cut -d ' ' -f 1)
if ! [ "$main_sum" == "$sha512_source" ]
then
	echo "SQLiteC++ source does not match checksum"
	echo "Deleting build folder"
	rm -rf "./build"
	exit 1
fi


echo "Extracting source"
cd build
tar xf sqlitecpp_$version.orig.tar.gz

mv ./SQLiteCpp-3.1.1 ./sqlitecpp-3.1.1

echo "Copying build and packaging instructions"
cp -r ../debian ./sqlitecpp-$version/

cd ./sqlitecpp-$version/
echo "Building package"
fakeroot debian/rules binary

