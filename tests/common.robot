*** Variables ***
${CREATE_SNAPSHOT_ON_FAIL}  True

*** Keywords ***

# These were committed after the 1.9.0 release, so I've copied them here
# https://github.com/renode/renode/commit/196d4139616ae4ad095d79c9926940832c1068c1
# If you ever get the error:
#
# Multiple keywords with name 'Test Teardown' found. Give the full name of the keyword you want to use:
#     common.Test Teardown
#     renode-keywords.Test Teardown
#
# You can remove these!

Create Snapshot Of Failed Test
    ${test_name}=      Set Variable  ${SUITE NAME}-${TEST NAME}.fail.save
    ${test_name}=      Replace String  ${test_name}  ${SPACE}  _

    ${snapshots_dir}=  Set Variable  ${PWD_PATH}/test_results/snapshots
    Create Directory   ${snapshots_dir}

    ${snapshot_path}=  Set Variable  "${snapshots_dir}/${test_name}"
    Execute Command  Save ${snapshot_path}
    Log To Console   Failed emulation's state saved to ${snapshot_path}

Test Teardown
    Run Keyword If  ${CREATE_SNAPSHOT_ON_FAIL}
    ...   Run Keyword If Test Failed
          ...   common.Create Snapshot Of Failed Test
    Reset Emulation
