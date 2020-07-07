#!/bin/bash -e

RENODE_CHECKOUT=${RENODE_CHECKOUT:-~/code/renode}

${RENODE_CHECKOUT}/test.sh -t "${PWD}/tests/tests.yaml" --variable PWD_PATH:"${PWD}" -r "${PWD}/test_output"
