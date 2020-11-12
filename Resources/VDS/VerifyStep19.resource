*** Settings ***
Documentation    This class has necessary keywords for validation of Data Items in Step 19 of ATOM logs.
Resource    ../Tools/BasicLayer.resource
Library    TitanLibrary.handlers.serialdriver.SerialDriver

*** Variables ***


*** Keywords ***
Step 19 Validate Data Items
    [Documentation]    Verifies the VDS status and CoreBus info in Step 19. The arguments are the CoreBus 
    ...  info and the expected result that we want to verify.
    [Arguments]    ${core_bus}  ${expected_result}
    ${file_name} =    get log file path    app
    ${data} =    Get Step Data from log file    ${file_name}   Step=19
    ${size}    get length    ${data}
    run keyword if    ${size}==0    Fail    Couldn't get 'Step=19' Data
    log    ${data}
    Verify Result in Step 19    ${data}  ${expected_result}
    Verify CoreBus Info in Step 19    ${data}    ${core_bus}
    Log LockedDataItems Number    ${data}

Verify Result in Step 19
    [Arguments]    ${data}  ${expected_result}
    @{lines} =    split to lines  ${data}

    FOR  ${line}  IN  @{lines}
        ${flag}    run keyword and return status  should contain  ${line}  Result  ignore_case=True
        ${wanted} =  set variable  ${line}
        Exit for loop if  '${flag}' == 'True'
    END
    run keyword and continue on failure  should contain  ${wanted}  ${expected_result}  ignore_case=True  values=False
    log  ${wanted}

Verify CoreBus Info in Step 19
    [Arguments]    ${data}    ${core_bus}
    @{lines} =    split to lines  ${data}

    FOR  ${line}  IN  @{lines}
        ${flag}    run keyword and return status  should contain  ${line}  CoreBus  ignore_case=True
        ${wanted} =  set variable    ${line}
        Exit for loop if    '${flag}' == 'True'
    END
    run keyword and continue on failure  should contain  ${wanted}  ${core_bus}  ignore_case=True  values=False
    log    ${wanted}

Log LockedDataItems Number
    [Arguments]    ${data}
    @{lines} =    split to lines  ${data}

    FOR  ${line}  IN  @{lines}
        ${flag}    run keyword and return status  should contain  ${line}  LockedDataItems  ignore_case=True
        ${wanted} =  set variable    ${line}
        Exit for loop if    '${flag}' == 'True'
    END
    log    ${wanted}
