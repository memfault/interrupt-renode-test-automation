#!/bin/bash -e

RENODE_TEST_SH=${RENODE_TEST_SH:-/home/developer/renode/test.sh}

PWD_PATH="$(pwd)"

${RENODE_TEST_SH} -t "${PWD_PATH}/tests/tests.yaml" --variable PWD_PATH:"${PWD_PATH}" -r "${PWD_PATH}/test_output" 2>&1 > "${PWD_PATH}/test_output/logs.txt"
