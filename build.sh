#!/bin/bash

IMLIB=/lib64/ImageMagick-6.7.7
IMINC=/usr/include/ImageMagick

CFLAGS="-g -Wall"
LDFLAGS="-I$IMINC -L$IMLIB -lMagickWand -lMagickCore"

# set base directory
if readlink ${BASH_SOURCE[0]} > /dev/null; then
  BASE="$( dirname "$( readlink ${BASH_SOURCE[0]} )" )"
else  
  BASE="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

for SOURCE in $BASE/*.c; do
  OUT=$BASE/`basename -s .c $SOURCE`
  if [[ "$1" == "clean" ]]; then
	if [ -e "$OUT" ]; then
	  CMD="rm -rf $OUT"
	else
	  CMD=""
	fi
  else
	if [ -e "$OUT" ] && [ `stat -c %Y $SOURCE` -le `stat -c %Y $OUT` ]; then
	  CMD=""
	else
	  CMD="gcc $CFLAGS $LDFLAGS -o $OUT $SOURCE"
	fi
  fi
  if [ -n "$CMD" ]; then
	echo $CMD
	$CMD
  fi
done

