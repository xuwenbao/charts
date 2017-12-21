#!/bin/bash

function scandir() {
        local srcdir tardir
        srcdir=$1
        tardir=$2
        for dirlist in $(ls ${srcdir})
                do
                        if test -d ${srcdir}/${dirlist};then
                        echo ${srcdir}/${dirlist}
                        /usr/local/bin/helm package -u -d ${tardir} --save=false ${srcdir}/${dirlist}
              fi
          done
}

scandir stable stable-archives
