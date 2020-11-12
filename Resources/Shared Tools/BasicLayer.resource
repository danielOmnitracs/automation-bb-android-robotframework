*** Settings ***
Documentation    Holds basic keywords necessary for the Test Cases
Library    TitanLibrary.handlers.serialdriver.SerialDriver
Library    ../../CustomLibraries/logParser.py
Library    OperatingSystem
Library    Process
Library    String
Resource   adb.resource 


*** Variables ***


*** Keywords ***

Delete 'VehicleService' folder from device
    [Documentation]    Deletes the VehicleService folder in our device, as a given pre-condition
    Run process    adb  shell  cd  sdcard/Documents/Omnitracs/AppData    ;    rm -rf VehicleService
    # Remove Folder from Device  /sdcard/Documents/Omnitracs/AppData/VehicleService  
    ${result}     Run process    adb  shell  cd  sdcard/Documents/Omnitracs/AppData    ;    ls
    should not contain  ${result.stdout}  VehicleService  msg= VehicleService file could not be deleted. \n

Push 'debugconfig' file to device
    [Documentation]    Pushes the debugconfig file to the sdcard/Documents/Omnitracs path of the 
    ...   device as a given pre-condition.The mentioned file assumed to be inside the Data folder of the project.
    Add File to Path in Device    ${EXEC_DIR}/Data/debugconfig.ini    sdcard/Documents/Omnitracs

Reboot the device
    [Documentation]    Reboots the device with ADB command
    Run process    adb    shell    reboot
    sleep    15s

Waiting for device to be ready after reboot
    [Documentation]    Waits until ATOM logs has "All services entered Running state" statement. The
    ...    default timeout is 3 mins
    ${file_path}    get log file path    app
    log to console    ${file_path}
    log to console    Waiting device to be ready, will wait up to 3 mins
    FOR    ${i}    IN RANGE    60
        ${file_content}    get file    ${file_path}    encoding_errors=ignore
        Run Keyword If   'All services entered Running state' in $file_content  Exit For Loop          
        sleep    5s
    END

Get Step Data from log file
    [Documentation]    From atom log files gets the information in between two step words
    [Arguments]    ${filename}    ${stringToFind}
    ${stringLines} =   logParser.get step data from logfile    ${filename}    ${stringToFind}
    [Return]    ${stringLines}

