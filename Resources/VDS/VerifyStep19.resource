*** Settings ***
Documentation    This class has necessary keywords for validation of Data Items in Step 19.
Resource    ../Tools/BasicLayer.resource
Library    TitanLibrary.handlers.serialdriver.SerialDriver

*** Variables ***


*** Keywords ***
Step 19 Validate Data Items
    [Documentation]    Verifies the VDS status and CoreBus info in Step 19.
    [Arguments]    ${core_bus}
    ${file_name} =    get log file path    app
    ${data} =    Get Step Data from log file    ${file_name}   Step=19
    ${size}    get length    ${data}
    run keyword if    ${size}==0    Fail    Couldn't get 'Step=19' Data
    log    ${data}
    Verify Result in Step 19    ${data}
    Verify CoreBus Info in Step 19    ${data}    ${core_bus}
    Log LockedDataItems Number    ${data}

Verify Result in Step 19
    [Documentation]    Verifies the 'Result is Success' in VDS Configuraton
    [Arguments]    ${data}
    @{lines} =    split to lines  ${data}

    FOR  ${line}  IN  @{lines}
        ${flag}    run keyword and return status    should contain    ${line}    Result    ignore_case=True
        ${wanted} =  set variable    ${line}
        Exit for loop if    '${flag}' == 'True'
    END
    run keyword and continue on failure    should contain   ${wanted}    Success    ignore_case=True    values=False
    log    ${wanted}

Verify CoreBus Info in Step 19
    [Arguments]    ${data}    ${core_bus}
    @{lines} =    split to lines  ${data}

    FOR  ${line}  IN  @{lines}
        ${flag}    run keyword and return status    should contain    ${line}    CoreBus    ignore_case=True
        ${wanted} =  set variable    ${line}
        Exit for loop if    '${flag}' == 'True'
    END
    run keyword and continue on failure    should contain   ${wanted}    ${core_bus}    ignore_case=True    values=False
    log    ${wanted}

Log LockedDataItems Number
    [Documentation]    Logs the number of LockedDataItems into the Reports
    [Arguments]    ${data}

    @{lines} =    split to lines  ${data}
    FOR  ${line}  IN  @{lines}
        ${flag}    run keyword and return status    should contain    ${line}    LockedDataItems    ignore_case=True
        ${wanted} =  set variable    ${line}
        Exit for loop if    '${flag}' == 'True'
    END
    log    ${wanted}
