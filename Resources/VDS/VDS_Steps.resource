*** Settings ***
Library    TitanLibrary.handlers.serialdriver.SerialDriver
Library    String
Resource    ../Tools/BasicLayer.resource


*** Variables ***


*** Keywords ***
Step 0 Get Trigger Reason
    ${file_name} =    get log file path    app
    ${data} =    Get Step Data from log file    ${file_name}   Step=0
    ${size}    get length    ${data}
    run keyword if    ${size}==0    Fail    Couldn't get 'Step=0' Data
    ${first}    Get line  ${data}  0
    @{words}    Split string    ${first}
    FOR    ${word}  IN  @{words}
        ${flag}    run keyword and return status    should contain  ${word}  Trigger    ignore_case=True
        ${trigger_reason} =  set variable    ${word}
        Exit for loop if    '${flag}' == 'True'
    END
    log    ${trigger_reason}
    [Return]  ${trigger_reason}


Step 4 Verify Files Exist
    [Documentation]    In this step verifies; CurrentVdsConfiguration.txt, VdsData.bin,
     ...    and VdsState.bin files exist in /storage/emulated/0/Documents/Omnitracs/AppData/VehicleService
    ${file_1} =    set variable    CurrentVdsConfiguration.txt
    ${file_2} =    set variable    VdsData.bin
    ${file_3} =    set variable    VdsState.bin

    ${result}    Run process  adb  shell  cd  /storage/emulated/0/Documents/Omnitracs/AppData/VehicleService  ;  ls
    run keyword and continue on failure    should contain   ${result.stdout}  ${file_1}
    ...    Missing File: ${file_1}    values=False
    run keyword and continue on failure    should contain   ${result.stdout}  ${file_2}
    ...    Missing File: ${file_2}    values=False
    run keyword and continue on failure    should contain   ${result.stdout}  ${file_3}
    ...    Missing File: ${file_3}    values=False

