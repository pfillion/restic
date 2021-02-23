#!/usr/bin/env bats

NS=${NS:-pfillion}
IMAGE_NAME=${IMAGE_NAME:-restic}
VERSION=${VERSION:-latest}
CONTAINER_NAME="restoc-${VERSION}"

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

function teardown(){
    docker rm -f ${CONTAINER_NAME}
}

@test "entrypoint" {
    docker run -d --entrypoint sleep --name ${CONTAINER_NAME} ${NS}/${IMAGE_NAME}:${VERSION} 100
    
    # Test all environment variables supported by secret files.
	docker exec ${CONTAINER_NAME} bash -c "echo 'secret1' > /file1"
    
	run docker exec \
		-e 'RESTIC_KEY_HINT_FILE=/file1' \
		${CONTAINER_NAME} \
		bash -c '. /usr/local/bin/entrypoint.sh && 
			echo $RESTIC_KEY_HINT'
	
	assert_success
	assert_line --index 0 'secret1'
}