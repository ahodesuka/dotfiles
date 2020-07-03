#!/bin/bash
OUTSIZES="8 16 22 24 32 48 256"

for size in ${OUTSIZES}; do
  cat "symlinks.lst" | while read line; do
    filename="${line%% *}.png"
    #[ -e ${OUTDIR}/${size}x${size}/${filename} ] && continue

    cd "${size}x${size}"

    if [ -f "${filename}" ]; then
      for lnk in ${line#* }; do
        if [ ! -f ${lnk}.png ]; then
          ln -s ${filename} ${lnk}.png
        fi
      done
    fi

    cd ..
  done
done
