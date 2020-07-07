#!/bin/bash -e

# Originally written by TensorFlow at
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/micro/testing/test_stm32f4_binary.sh
#
# -------------------------------------------------------
#
# Tests a 'stm32f4' STM32F4 ELF by parsing the log output of Renode emulation.
#
# First argument is the ELF location.

declare -r HOST_ROOT_DIR=`pwd`
declare -r HOST_TEST_OUTPUT_PATH=${HOST_ROOT_DIR}/test_output
declare -r HOST_LOG_PATH=${HOST_TEST_OUTPUT_PATH}
declare -r HOST_LOG_FILENAME=${HOST_LOG_PATH}/logs.txt

declare -r DOCKER_TAG=renode_stm32f4
declare -r DOCKER_WORKSPACE=/workspace
declare -r DOCKER_TEST_OUTPUT_PATH=/tmp/test_output

mkdir -p ${HOST_LOG_PATH}

docker build -t ${DOCKER_TAG} -f ${HOST_ROOT_DIR}/Dockerfile .

# running in `if` to avoid setting +e

exit_code=0
if ! docker run \
  --log-driver=none -a stdout -a stderr \
  --volume ${HOST_ROOT_DIR}:${DOCKER_WORKSPACE} \
  --volume ${HOST_TEST_OUTPUT_PATH}:${DOCKER_TEST_OUTPUT_PATH} \
  --env SCRIPT=${DOCKER_WORKSPACE}/renode-config.resc \
  --env RENODE_CHECKOUT=/home/developer/renode \
  --workdir ${DOCKER_WORKSPACE} \
  ${DOCKER_TAG} \
  /bin/bash -c "./run_tests.sh 2>&1 > ${DOCKER_TEST_OUTPUT_PATH}/logs.txt"
then
  echo "FAILED"
  exit_code=1
fi

echo -e "\n----- LOGS -----\n"
cat ${HOST_LOG_FILENAME}

if [ $exit_code -eq 0 ]
then
  echo "$1: PASS"
else
  echo "$1: FAIL"
fi

# Raise the exit
exit $exit_code
