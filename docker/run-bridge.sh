#!/bin/bash
if [[ -z "$BRIDGE_NAME" ]]; then
	echo "BRIDGE_NAME not set"
	exit 1
fi
export BBCTL_CONFIG=${BBCTL_CONFIG:-/bbctl.json}
if [[ ! -f $BBCTL_CONFIG ]]; then
	if [[ -z "$MATRIX_ACCESS_TOKEN" ]]; then
		echo "MATRIX_ACCESS_TOKEN not set"
		exit 1
	fi
	export DATA_DIR=${DATA_DIR:-/data}
	if [[ ! -d $DATA_DIR ]]; then
		echo "DATA_DIR ($DATA_DIR) does not exist"
		exit 1
	fi
	export DB_DIR=${DB_DIR:-/data/db}
	mkdir -p $DB_DIR
	jq -n '{environments: {prod: {access_token: env.MATRIX_ACCESS_TOKEN, database_dir: env.DB_DIR, bridge_data_dir: env.DATA_DIR}}}' > $BBCTL_CONFIG
fi
bbctl run $BRIDGE_NAME
