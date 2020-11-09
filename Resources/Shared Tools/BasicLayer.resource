*** Settings ***
Documentation    Holds basic keywords necessary for the Test Cases
Library    TitanLibrary.handlers.serialdriver.SerialDriver
Library    ../../CustomLibraries/logParser.py
Library    OperatingSystem
Library    Process
Library    String


*** Variables ***
${destination_for_debugconfig} =    sdcard/Documents/Omnitracs

*** Keywords ***

Delete 'VehicleService' folder from device
    [Documentation]    Deletes the VehicleService folder in our device, as a given pre-condition
    Run process    adb  shell  cd  sdcard/Documents/Omnitracs/AppData    ;    rm -rf VehicleService
    ${result}     Run process    adb  shell  cd  sdcard/Documents/Omnitracs/AppData    ;    ls
    should not contain  ${result.stdout}  VehicleService  msg= VehicleService file could not be deleted. \n

Push 'debugconfig' file to device
    [Documentation]    Pushes the debugconfig file to the device as a given pre-condition,
    ...    unless the device already has it.
    ${result}    Run process  adb  shell  cd  sdcard/Documents/Omnitracs  ;    ls -la
    ${failed}    Run keyword and return status    should contain    ${result.stdout}    debugconfig.ini
    Run keyword unless    ${failed}    Run process  adb  push  ${EXEC_DIR}/Data/debugconfig.ini
    ...    ${destination_for_debugconfig}

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
    FOR    ${index}    IN RANGE    1    60
        ${file_content}    get file    ${file_path}    encoding_errors=ignore
        ${flag}    run keyword and return status    should contain    ${file_content}
        ...    All services entered Running state    values=False   ignore_case=True
        Exit for loop if  "${flag}" == "True"
        sleep    5s
    END

Get Step Data from log file
    [Documentation]    From atom log files gets the information in between two step words
    [Arguments]    ${filename}    ${stringToFind}
    ${stringLines} =   LogParser.get step data from logfile    ${filename}    ${stringToFind}
    [Return]    ${stringLines}



