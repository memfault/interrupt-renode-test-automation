*** Settings ***
Resource          ${RENODEKEYWORDS}
Resource          common.robot
Suite Setup       Setup
Suite Teardown    Teardown
Test Setup        Reset Emulation
Test Teardown     common.Test Teardown

*** Variables ***
${SHELL_PROMPT}    shell>

*** Keywords ***
Start Test
    Execute Command             mach create
    Execute Command             machine LoadPlatformDescription @platforms/boards/stm32f4_discovery-kit.repl
    Execute Command             machine LoadPlatformDescription @${PWD_PATH}/add-ccm.repl
    Execute Command             sysbus LoadELF @${PWD_PATH}/build/renode-example.elf
    Create Terminal Tester      sysbus.uart2
    Start Emulation

*** Test Cases ***
Ping
    [Documentation]             Ping Pong
    [Tags]                      non_critical  factory  uart

    Start Test

    Wait For Prompt On Uart     ${SHELL_PROMPT}
    Write Line To Uart          ping
    Wait For Line On Uart       PONG


Help Menu
    [Documentation]             Prints help menu of the command prompt
    [Tags]                      critical  uart

    Start Test

    Wait For Prompt On Uart     ${SHELL_PROMPT}
    Write Line To Uart          help
    Wait For Line On Uart       help: Lists all commands
    Wait For Line On Uart       ping: Prints PONG


Greet
    [Documentation]             Greets given name
    [Tags]                      non_critical  uart  input

    Start Test

    Wait For Prompt On Uart         ${SHELL_PROMPT}
    Write Line To Uart              greet Tyler

    ${p}=  Wait For Line On Uart    Hello (\\w+)!     treatAsRegex=true
    Should Be True                  'Tyler' == """${p.groups[0]}"""


Trigger Fault
    [Documentation]             Should fail, but fine since non_critical
    [Tags]                      non_critical  uart  input

    Start Test

    Wait For Prompt On Uart         ${SHELL_PROMPT}
    Write Line To Uart              fault

    # By now we've crashed
    Wait For Line On Uart           Nope     timeout=2
