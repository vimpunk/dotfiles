#!/bin/sh
sed -i \
         -e 's/#2e3745/rgb(0%,0%,0%)/g' \
         -e 's/#aab1be/rgb(100%,100%,100%)/g' \
    -e 's/#2e3745/rgb(50%,0%,0%)/g' \
     -e 's/#aab1be/rgb(0%,50%,0%)/g' \
     -e 's/#2e3745/rgb(50%,0%,50%)/g' \
     -e 's/#aab1be/rgb(0%,0%,50%)/g' \
	$@
