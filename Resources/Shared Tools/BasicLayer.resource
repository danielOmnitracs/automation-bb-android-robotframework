*** Settings ***
Documentation    Holds basic keywords necessary for the VDS Test Cases
Library    TitanLibrary.handlers.serialdriver.SerialDriver
Library    ../../CustomLibraries/logParser.py
Library    OperatingSystem
Library    Process
Library    String
Resource   adb.resource
Resource   Files.resource


*** Variables ***

*** Keywords ***

Delete 'VehicleService' folder from device
    [Documentation]    Deletes the VehicleService folder in our device, as a given pre-condition

    [Arguments]  ${device_name}=${TEST_DEVICE_ID}        
    Remove Folder from Device  /sdcard/Documents/Omnitracs/AppData/VehicleService  
    ${result}     Run process    adb  -s  ${device_name}  shell  cd  sdcard/Documents/Omnitracs/AppData    ;    ls
    should not contain  ${result.stdout}  VehicleService  msg= VehicleService file could not be deleted. \n


Push 'debugconfig' file to device
    [Documentation]    Pushes the debugconfig file to the sdcard/Documents/Omnitracs path of the 
    ...   device as a given pre-condition.The mentioned file assumed to be inside the Data folder of the project.
    Add File to Path in Device    ${EXEC_DIR}/Data/debugconfig.ini    sdcard/Documents/Omnitracs

Push a custom debugconfig file to device
    [Documentation]    Pushes a custom debugconfig file to the sdcard/Documents/Omnitracs path of the 
    ...  device as a given pre-condition. Accepts an argument as ${command_for_debugconfig} for the text that 
    ...  will be written inside the file that we want to create. For more details about the commands check 
    ...  DebugConfigSettings.yaml variable file inside the Data/ folder of the project root.
    [Arguments]  ${command_for_debugconfig}
    ${debugconfig_path}  Create Command Configuration File with a Command in Local Folder    debugconfig  ${command_for_debugconfig}       
    Add File to Path in Device    ${debugconfig_path}    ${DEBUGCONFIG_DEST_PATH}


Reboot the device
    [Documentation]    Reboots the device with ADB command
    Run process    adb  -s  ${device_name}  shell    reboot
    sleep    15s


Waiting for device to be ready after reboot
    [Documentation]    Waits until App logs has "All services entered Running state" statement. The
    ...    default timeout is 3 mins
    ${file_path}    get log file path    app
    log to console    ${file_path}
    log to console    Waiting device to be ready, will wait up to 3 mins
    FOR    ${i}    IN RANGE    60
        ${file_content}    get file    ${file_path}    encoding_errors=ignore
        Run Keyword If   'All services entered Running state' in $file_content  Exit For Loop          
        sleep    5s
    END


Get Text From Log File Surrounded By a String
    [Documentation]    From atom log files gets the information in between two step words
    [Arguments]    ${filename}    ${stringToFind}
    ${stringLines} =   logParser.get text surrounded by string   ${filename}    ${stringToFind}
    [Return]    ${stringLines}


Waiting for A Specific Keyword To Appear in Log File
    [Documentation]    Waits until the given log file has ${specified_keyword} statement. The
    ...    default ${mins_to_wait} is 3 mins, the default ${log_name} is app.
    [Arguments]  ${specified_keyword}  ${log_name}=app  ${mins_to_wait}=3
    ${file_path}    get log file path    ${log_name}
    
    log to console    Waiting for ${specified_keyword}, will wait up to ${mins_to_wait} mins
    
    ${is_containing}  Set Variable    False
    ${loop_range}  Evaluate    ${mins_to_wait}*12     
    FOR    ${i}    IN RANGE    ${loop_range}
        ${file_content}    get file    ${file_path}    encoding_errors=ignore
        ${is_containing}  Run Keyword And Return Status    should contain  ${file_content}    ${specified_keyword}    ignore_case=True
        Run Keyword If    '${is_containing}'=='True'   Exit For Loop
               
        sleep    5s
    END
   
    Should Be True    ${is_containing}    msg=In ${log_name} logs could NOT encounter ${specified_keyword} keyword in ${mins_to_wait} mins! 
    Log  ${file_content} 

