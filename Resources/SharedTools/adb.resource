*** Settings ***
Documentation  This file contains low level keywords related to ADB commands.
...  For this resource it is needed the scalar variable ${DEVICE_ID} which will be 
...  the id that is shown in "adb devices". Execute the test suite from the root of the project

Library  Process
Library  OperatingSystem
Library  String
Library  Collections
Library  TitanLibrary.handlers.commandline
Resource  Files.resource

*** Keywords ***
Add File to Path in Device
    [Documentation]  ${file_path} must have the complete root of the file including the name
    ...  of the file. ${dst_path} could only have the destionation folder root, and
    ...  if the name of the file is other than the one in ${file_path}, then the name of
    ...  the file can be added as part of dst_path.
    [Arguments]  ${file_path}  ${dst_path}
    ${result}  Run Process  adb  push  ${file_path}  ${dst_path}
    Log  ${result.stdout}
    Should Contain  ${result.stdout}  1 file pushed
        
Remove File From Path in Device
    [Documentation]  ${file_path} is the root of the file including the name of it.
    [Arguments]  ${file_path}
    Run Process  adb  shell  rm  -f  ${file_path}
    ${file_name}  Fetch From Right  ${file_path}  /
    ${path}  Fetch From Left  ${file_path}  ${file_name}
    File is not in Device Path  ${file_name}  ${path}

Is File in Device Path
    [Arguments]  ${file}  ${dst_path}
    ${result}  Run Process  adb  shell  cd  ${dst_path}  ;  ls  timeout=15s
    Log  ${result.stdout}
    ${result}  Evaluate  $file in $result.stdout  
    [Return]  ${result}

File is in Device Path
    [Arguments]  ${file}  ${dst_path}
    ${result}  Is File in Device Path  ${file}  ${dst_path}
    Should Be True  ${result}

File is not in Device Path
    [Arguments]  ${file}  ${dst_path}
    ${result}  Is File in Device Path  ${file}  ${dst_path}
    Should Not Be True  ${result}

Wait Some Seconds for File to Exist in Device
    [Documentation]  Wait a maximum of ${seconds}*5 to find a file in a path.
    [Arguments]  ${seconds}  ${file_path}
    ${file_name}  Fetch From Right  ${file_path}  /
    ${path}  Fetch From Left  ${file_path}  ${file_name}
    FOR  ${n}  IN RANGE  ${seconds}
        ${file_found}  Is File in Device Path  ${file_name}  ${path}
        Run Keyword If  $file_found  Exit For Loop
        Sleep  5s
    END
    Should Be True  ${file_found}

Count Current Files in Device Folder
    [Arguments]  ${folder_path}
    ${result}  Run Process  adb  shell  cd  ${folder_path}  ;  ls
    ${elements}  Split To Lines  ${result.stdout}
    ${count}  Get Length  ${elements}
    Log  ${count}
    [Return]  ${count}

Get File from Device to Local Data Temp Folder
    [Documentation]  It gets a file from the device and stores it in Data/Temp folder. The name
    ...  used to save the file is pull_theNameOfTheFile.
    ...  The folder in the current project Data/Temp, has to be created first.
    [Arguments]  ${file_path}
    ${file_name}  Fetch From Right  ${file_path}  /
    Run Process  adb  pull  ${file_path}  ${EXECDIR}/Data/Temp/pull_${file_name}
    Log  ${EXECDIR}\\Data\\Temp\\pull_${file_name}
    [Return]  ${EXECDIR}\\Data\\Temp\\pull_${file_name}

Show File Content from Device in Shell
    [Documentation]  It returns the output of the file.
    [Arguments]  ${file_content_path}
    ${result}  Run Process  adb  shell  cat  ${file_content_path}
    [Return]  ${result}

Run adb getprop on Device
    [Arguments]  ${command}
    ${result}  Run Process  adb  shell  getprop  ${command}
    Log  ${result.stdout}
    [Return]  ${result.stdout}
    
The Device is Rebooted
    [Documentation]  Set ${DEVICE_ID} variable in the environment to identify the Device.
    Run Process  adb  reboot
    FOR  ${i}  IN RANGE  12
        Sleep  10s
        ${result}  Run Process  adb  devices
        Run Keyword If  '${DEVICE_ID}' in $result.stdout  Exit For Loop
    END
    #Wait some time for some application to auto-launch
    Sleep  30s

The Device is On
    [Documentation]  Set ${DEVICE_ID} variable in the environment to identify the Device.
    ${result}  Run Process  adb  devices
    Should Contain  ${result.stdout}  ${DEVICE_ID}

Get Process Id of an App from Device
    [Documentation]  Returns the process id of a specific application if running.
    [Arguments]  ${package_name}
    ${result}  Run Process  adb  shell  pidof  -s  ${package_name}
    Log  ${result.stdout}
    [Return]  ${result.stdout}

App is Running on Device
    [Documentation]  It checks if the application is running at the moment, it doesnt start it.
    [Arguments]  ${package_name}
    ${response}  Get Process Id of an App from Device  ${package_name}
    ${app_found}  Evaluate  len($response)>1
    Should Be True  ${app_found}

App is not Running on Device
    [Documentation]  It checks if the application is currently stopped, it doesnt stop it.
    [Arguments]  ${package_name}
    ${response}  Get Process Id of an App from Device  ${package_name}
    ${app_not_found}  Evaluate  len($response)<1
    Should Be True  ${app_not_found}

App is killed on Device
    [Documentation]  It closes the specified application.
    [Arguments]  ${package_name}
    Run Process  adb  shell  am  force-stop  ${package_name}

App with Activity is Started on Device
    [Documentation]  It starts the specified application.
    [Arguments]  ${package_name}  ${activity_name}
    ${result}  Run Process  adb  shell  am  start  -n  
    ...  ${package_name}/${package_name}.${activity_name}
    Log  ${result.stdout}
    Should Not Match Regexp  ${result.stdout}  Error|Exception

Reach URLs from Device
    [Documentation]  It tries to reach all the urls given in ${end_points} as a list.
    [Arguments]  ${end_points}
    Log  ${end_points}
    FOR  ${el}  IN  @{end_points}
        URL is Reachable from Device  ${el}
    END

URL is Reachable from Device
    [Documentation]  It tries to reach a given url ${url}. Reachable is defined as 404,200 and 405
    ...  http codes, more codes can be added.
    [Arguments]  ${url}
    Log To Console  ${url}
    ${result}  Run Process  adb  shell  curl  -sSL  -D  -  ${url}  -o  /dev/null  timeout=40s
    Log  ${result.stdout}
    Should Match Regexp  ${result.stdout}  .*HTTP/.*\\s4\\d\\d|2\\d\\d  #404|200|405

Turn Off the Wifi on Device by ADB
    Run Process  adb  shell  svc  wifi  disable
    ${wifi_status}  Check Wifi Status Adb  ${DEVICE_ID}
    Should Contain  ${wifi_status}  Wi-Fi is disabling

Turn On the Wifi on Device by ADB
    Run Process  adb  shell  svc  wifi  enable
    ${wifi_status}  Check Wifi Status Adb  ${DEVICE_ID}
    Should Contain  ${wifi_status}  Wi-Fi is enabling
    
Wifi is On in the Device
    [Documentation]  Returns True if the Wifi is on, otherwise it returns false
    ${wifi_status}  Check Wifi Status Adb  ${DEVICE_ID}
    ${wifi_on}  Set Variable If  '${wifi_status}'=='Wi-Fi is enabled'  True  False
    [Return]  ${wifi_on}