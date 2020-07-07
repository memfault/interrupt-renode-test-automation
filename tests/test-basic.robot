*** Settings ***
Suite Setup       Setup
Suite Teardown    Teardown
Test Setup        Reset Emulation
Resource          ${RENODEKEYWORDS}

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

    ${p}=  Wait For Line On Uart    Hello (\\w+)!     treatAsRegex=true  timeout=2
    Should Be True                  'Tyler' == """${p.groups[0]}"""


High Water Mark
    [Documentation]             Validate high water marks after all the tests run
    [Tags]                      non_critical stability

    Start Test

    Wait For Prompt On Uart         ${SHELL_PROMPT}
    Write Line To Uart              heap_free

    ${p}=  Wait For Line On Uart    (\\d+)     treatAsRegex=true  timeout=2
    ${i}=  Convert To Integer       ${p.groups[0]}
    Should Be True                  1000 < ${i}

