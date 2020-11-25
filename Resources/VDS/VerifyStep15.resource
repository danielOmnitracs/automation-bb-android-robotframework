*** Settings ***
Documentation    This class contains necessary keywords for Core Bus Item validations
Resource    ../Tools/BasicLayer.resource
Library    TitanLibrary.handlers.serialdriver.SerialDriver

*** Variables ***


*** Keywords ***
Step 15 Verify Core Data Items
    [Documentation]    Verifies 4 Core Items, CoreBus Info and VDS Configuration status.
    [Arguments]    ${core_bus}
    ${file_name} =    get log file path    app
    ${data} =    Get Text From log File Surrounded By a String    ${file_name}   Step\=15
    ${size}    get length    ${data}
    run keyword if    ${size}==0    Fail    Couldn't get 'Step=15' Data
    log    ${data}
    Verify Speed Core item    ${data}
    Verify Engine Core item    ${data}
    Verify DistanceLtd Core item    ${data}
    Verify FuelLtd Core item    ${data}
    Verify CoreBus Info    ${data}    ${core_bus}
    Verify VDS Configuration Status    ${data}
    [Return]    ${data}

Step 15 Verify Missing Speed Core Data Item
    [Documentation]    Verifies Core Items except speed and verifies failure of CoreBus Info and VDS Configuration status.
    [Arguments]    ${core_bus}
    ${file_name} =    get log file path    app
    ${data} =    Get Text From log File Surrounded By a String    ${file_name}   Step\=15
    ${size}    get length    ${data}
    run keyword if    ${size}==0    Fail    Couldn't get 'Step=15' Data
    log    ${data}
    Verify Missing Speed Core item    ${data}
    Verify Engine Core item    ${data}
    Verify DistanceLtd Core item    ${data}
    Verify FuelLtd Core item    ${data}
    Verify Missing CoreBus Info    ${data}    ${core_bus}
    Verify VDS Configuration Failure    ${data}
    [Return]    ${data}


Verify Speed Core item
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    Speed configuration verified
    ...    Core data item Speed is not receiving data    values=False

Verify Missing Speed Core item
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    Speed is not receiving data.
    ...    Unexpected Speed Data    values=False

Verify Engine Core item
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    EngineRpm configuration verified
    ...    Core data item EngineRpm is not receiving data    values=False

Verify Missing Engine Core item
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    EngineRpm is not receiving data.
    ...    Unexpected EngineRpm Data    values=False

Verify DistanceLtd Core item
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    DistanceLtd configuration verified
    ...    Core data item DistanceLtd is not receiving data    values=False

Verify Missing DistanceLtd Core item
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    DistanceLtd is not receiving data.
    ...    Unexpected DistanceLtd Data    values=False

Verify FuelLtd Core item
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    FuelLtd configuration verified
    ...    Core data item FuelLtd is not receiving data    values=False

Verify Missing FuelLtd Core item
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    FuelLtd is not receiving data.
    ...    Unexpected FuelLtd Data    values=False

Verify CoreBus Info
    [Arguments]    ${data}    ${core_bus}
    run keyword and continue on failure    should contain   ${data}    CoreBus = ${core_bus}
    ...    CoreBus Info is NOT matching    values=False
    run keyword and continue on failure    should contain   ${data}    ${core_bus} count: 4
    ...    Missing CoreBus Item     values=False

Verify Missing CoreBus Info
    [Arguments]    ${data}    ${core_bus}
    run keyword and continue on failure    should contain   ${data}    CoreBus = ${core_bus}
    ...    CoreBus Info is NOT matching    values=False
    run keyword and continue on failure    should not contain   ${data}    ${core_bus} count: 4
    ...    Unexpected number of CoreBus Item     values=False

Verify VDS Configuration Status
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    VDS configuration completed. Success.
    ...    VDS configuration Failure    values=False

Verify VDS Configuration Failure
    [Arguments]    ${data}
    run keyword and continue on failure    should contain   ${data}    Failure
    ...    Unexpected VDS configuration    values=False