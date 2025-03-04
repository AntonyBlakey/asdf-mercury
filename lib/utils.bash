#!/usr/bin/env bash

set -euo pipefail

DL_REPO="https://dl.mercurylang.org"
DL_ARCHIVE_REPO="https://github.com/Mercury-Language/mercury-srcdist/archive"
TOOL_NAME="mercury"
TOOL_TEST="mmc --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
	curl "${curl_opts[@]}" "$DL_REPO" |
		grep -E '[0-9.]* Release' | sed -e 's/<h3>\([0-9.]*\) Release.*/\1/'
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

        echo "* Downloading $TOOL_NAME release $version..."
	if [[ $version =~ ^rotd ]]; then
 		url="$DL_REPO/rotd/mercury-srcdist-${version}.tar.xz"
     		archive_url="$DL_ARCHIVE_REPO/${version}.tar.gz"
   		curl "${curl_opts[@]}" -o "$filename" -C - "$url" || \
     		curl "${curl_opts[@]}" -o "$filename" -C - "$archive_url" || \
       		fail "Could not download $url or $archive_url"
	elif [[ $version =~ -beta- ]]; then
 		url="$DL_REPO/beta/mercury-srcdist-${version}.tar.xz"
   		curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
        else
	        url="$DL_REPO/release/mercury-srcdist-${version}.tar.xz"
	 	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
	fi


}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		cd "$ASDF_DOWNLOAD_PATH"
		chmod -R u+w .
		./configure --prefix="$install_path"
		make PARALLEL="-j$ASDF_CONCURRENCY"
		mkdir -p "$install_path"
		make PARALLEL="-j$ASDF_CONCURRENCY" install

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
