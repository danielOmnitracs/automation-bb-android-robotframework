*** Settings ***
Library    TitanLibrary.handlers.serialdriver.SerialDriver
Library    String
Resource    ../Tools/BasicLayer.resource
Resource    ../Tools/adb.resource


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
        ${wanted} =  set variable    ${word}
        Exit for loop if    '${flag}' == 'True'
    END
    log    ${wanted}
    [Return]  ${wanted}

Step 1 Remove Locks
    ${file_name} =    get log file path    app
    ${data} =    Get Step Data from log file    ${file_name}   Step=1
    #log to console    ${data}
    log    ${data}
    [Return]  ${data}

Step 2 Inialize Devices
    ${file_name} =    get log file path    app
    ${data} =    BasicLayer.Get Step Data from log file     ${file_name}    Step=2
    #log to console    ${data}
    log    ${data}
    [Return]  ${data}

Step 3 Load Filter Tables
    ${file_name} =    get log file path    app
    ${data} =    Get Step Data from log file     ${file_name}   Step=3
    #log to console    ${data}
    log    ${data}
    [Return]  ${data}


Step 4 Verify File Exist in Path
    [Documentation]    This step verifies; the given files exist in destination path. By default dst_path is 
    ...  /storage/emulated/0/Documents/Omnitracs/AppData/VehicleService. Other value can be assigned when necessary.

    [Arguments]  ${file}  ${dst_path}=storage/emulated/0/Documents/Omnitracs/AppData/VehicleService       
    ${flag}  Is File in Device Path    ${file}    ${dst_path} 
    Run Keyword Unless    ${flag}  log  ${file} is NOT found in the path of ${dst_path}    



