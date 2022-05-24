#!/usr/bin/env sh
# Do - The Simplest Build Tool on Earth.
# Documentation and examples see https://github.com/8gears/do

set -e -u # -e "Automatic exit from bash shell script on error"  -u "Treat unset variables and parameters as errors"

if [ -f ./.env ]
then
	export $(cat ./.env | sed 's/#.*//g' | xargs)
fi

if [ -f ../.env ]
then
	export $(cat ../.env | sed 's/#.*//g' | xargs)
fi

PROJECT_NAME=${PROJECT_NAME:-}
COMPOSER=${COMPOSER_BINARY:-~/bin/composer.phar}

composer() {
    cmd="composer $@"
    docker exec -it $PROJECT_NAME\_ss sh -c "$cmd"
}

devBuild() {
    echo "Running dev/build on silverstripe"
    docker exec $PROJECT_NAME\_ss vendor/bin/sake "dev/build" $@
}

sake() {
    cmd="vendor/bin/sake $@"
    docker exec -it $PROJECT_NAME\_ss sh -c "$cmd"
}

dumpDb() {
	filename=$(basename ${1:-$(date -u +"dump-%Y-%m-%d-%H-%M-%S.sql")})
	echo "Dumping to ./dumps/$filename"
	if [[ -n "${PROJECT_NAME}" ]]
	then
		DUMP_DB_CMD="mysqldump --add-drop-table $SS_DATABASE_NAME > /var/data/$filename"
		docker exec $PROJECT_NAME\_db sh -c "$DUMP_DB_CMD"
	else
		mysqldump $SS_DATABASE_NAME | gzip -v > ./dumps/$filename.gz
	fi
	echo "… dump saved"
}

importDb() {
    echo "The following dumps archives were found; select one:"

    # set the prompt used by select, replacing "#?"
    PS3="Use number to select a file or 'exit' to cancel: "
    filenames=$(find ./dumps -type f -name "*.sql" -or -name "*.gz")
    exitposition=$(find ./dumps -type f -name "*.sql" -or -name "*.gz" | wc -l)
    let "exitposition++"

    select filename in $filenames "exit";
    do
        if [[ "$REPLY" == $exitposition || "$REPLY" == exit ]];
        then
            echo BYE
            break
        fi

        if [[ $filename == "" ]]
        then
            echo "'$REPLY' is not a valid number"
            continue
        fi

        if [ -f $filename ]; then
            echo Now import db dump to local db...
            _performImport $filename
        else
            echo "file does not exist!"
        fi
    break
    done
}

_performImport() {
	if [[ -n "${PROJECT_NAME}" ]]
	then
  		IMPORT_DB_CMD="mysql -u root $SS_DATABASE_NAME < /var/data/$(basename $1)"
  		docker exec $PROJECT_NAME\_db sh -c "$IMPORT_DB_CMD"
	else
		gunzip < ./dumps/$(basename $1) | mysql --user=$SS_DATABASE_USERNAME --password $SS_DATABASE_NAME
	fi
  	echo "$(basename $1) installed"
}

"$@" # <- execute the task

[ "$#" -gt 0 ] || printf "Usage:\n\t./do.sh %s\n" "($(compgen -A function | grep '^[^_]' | paste -sd '|' -))"
