#!/bin/bash -e

# Runs Robot Framework tests locally

RENODE_CHECKOUT=${RENODE_CHECKOUT:-~/code/renode}

${RENODE_CHECKOUT}/test.sh -t "${PWD}/tests/tests.yaml" --variable PWD_PATH:"${PWD}" --variable snapshots_dir:"${PWD}/test_results" -r "${PWD}/test_results"
