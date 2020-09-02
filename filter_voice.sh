#!/bin/bash

set -e

tmp_file_location=/home/$USER/Downloads
tmp_file=$tmp_file_location/cadmus.AppImage

wget https://github.com/josh-richardson/cadmus/releases/download/0.0.2/cadmus.AppImage -O "$tmp_file"

cd "$tmp_file"
chmod +x "$tmp_file"
cd "$tmp_file_location"
./$tmp_file
cd - &>/dev/null

