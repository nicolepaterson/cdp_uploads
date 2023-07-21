#!usr/bin/bash
### PERMISSIONS ###
umask 007

### DATABASE VARIABLES ###
hDB=protein_models
hPATH=/warehouse/tablespace/external/hive/${hDB}.db

### DEFINE BASE PATH ###
bpath=
if [ "$bpath" == "" ]; then
    bpath=$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fi

### Load functions
source "$bpath/lib/ifx-shell/utils.sh"
#source "$bpath/lib/ifx-shell/log.sh"

### LOAD DIRECTORY PATHS ###

binp=$bpath/bin
docp=$bpath/docs
#rp=$bpath/r
#sqlp=$bpath/sql
tblp=$bpath/tbl
libp=$bpath/lib

function install() {
    local libp=$1
    libp=$(dirname "$libp")
    [ ! -d "$libp" ] && mkdir "$libp"

    cd "$libp" || exit 1
    for repo in hadoopBySSH distance convert phylo; do
        if [ ! -d "$repo" ]; then
            git clone git@git.biotech.cdc.gov:vfn4/${repo}.git > /dev/null || die "Failed to install $repo"
        else
            cd "$libp/$repo" || exit 1
            git pull || die "Failed to pull data for $repo."
            cd "$libp" || exit 1
        fi
    done
}
