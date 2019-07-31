#!/bin/bash

source /opt/qt59/bin/qt59-env.sh
DIR=$(dirname "$(readlink -f "$0")")
export LD_LIBRARY_PATH="$DIR/../lib":$LD_LIBRARY_PATH
$DIR/rdm