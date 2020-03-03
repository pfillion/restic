#!/usr/bin/env bats

NS=${NS:-pfillion}
IMAGE_NAME=${IMAGE_NAME:-restic}
VERSION=${VERSION:-latest}
CONTAINER_NAME="restoc-${VERSION}"

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

# Retry a command $1 times until it succeeds. Wait $2 seconds between retries.
function retry(){
	local attempts=$1
	shift
	local delay=$1
	shift
	local i

	for ((i=0; i < attempts; i++)); do
		run "$@"
		if [[ "$status" -eq 0 ]]; then
			return 0
		fi
		sleep $delay
	done

	echo "Command \"$@\" failed $attempts times. Output: $output"
	false
}

function teardown(){
    docker rm -f ${CONTAINER_NAME}
}

@test "entrypoint" {
    docker run -d --entrypoint sleep --name ${CONTAINER_NAME} ${NS}/${IMAGE_NAME}:${VERSION} 100
    # retry 30 1 is_ready
    
    # Test all environment variables supported by secret files.
	docker exec ${CONTAINER_NAME} bash -c "echo 'secret1' > /file1"
	docker exec ${CONTAINER_NAME} bash -c "echo 'secret2' > /file2"
	docker exec ${CONTAINER_NAME} bash -c "echo 'secret3' > /file3"
    
	run docker exec \
		-e 'RESTIC_REPOSITORY_FILE=/file1' \
		-e 'RESTIC_PASSWORD_FILE=/file2' \
		-e 'RESTIC_KEY_HINT_FILE=/file3' \
		${CONTAINER_NAME} \
		bash -c '. /usr/local/bin/entrypoint.sh && 
			echo $RESTIC_REPOSITORY && 
			echo $RESTIC_PASSWORD &&
			echo $RESTIC_KEY_HINT'
	
	assert_success
	assert_line --index 0 'secret1'
	assert_line --index 1 'secret2'
	assert_line --index 2 'secret3'
}