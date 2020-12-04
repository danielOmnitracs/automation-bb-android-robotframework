*** Settings ***
Documentation  This file contains low level keywords related to ADB commands.
...  For this resource it is needed the scalar variable ${TEST_DEVICE_ID} which will be 
...  the id of the device under test that is shown in "adb devices". 
...  Execute the test suite from the root of the project. All the keywords can be applied
...  to another device for example to a table, it this case it is needed to specify the 
...  device name as an argument when calling the keyword.

Library  Process
Library  String
Library  TitanLibrary.handlers.commandline

*** Keywords ***
Remove Folder from Device
    [Arguments]  ${folder_path}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  -s  ${device_name}  shell  rm  -r  ${folder_path}
    Log  ${result.stdout}
    Should Be Empty  ${result.stdout}

Add File to Path in Device
    [Documentation]  ${file_path} must have the complete root of the file including the name
    ...  of the file. ${dst_path} could only have the destionation folder root, and
    ...  if the name of the file is other than the one in ${file_path}, then the name of
    ...  the file can be added as part of dst_path.
    [Arguments]  ${file_path}  ${dst_path}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  -s  ${device_name}  push  ${file_path}  ${dst_path}
    Log  ${result.stdout}
    Should Contain  ${result.stdout}  1 file pushed
        
Remove File From Path in Device
    [Documentation]  ${file_path} is the root of the file including the name of it.
    [Arguments]  ${file_path}  ${device_name}=${TEST_DEVICE_ID}
    Run Process  adb  -s  ${device_name}  shell  rm  -f  ${file_path}
    ${file_name}  Fetch From Right  ${file_path}  /
    ${path}  Fetch From Left  ${file_path}  ${file_name}
    File is not in Device Path  ${file_name}  ${path}

Is File in Device Path
    [Arguments]  ${file}  ${dst_path}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  -s  ${device_name}  shell  cd  ${dst_path}  ;  ls  timeout=15s
    Log  ${result.stdout}
    ${result}  Evaluate  $file in $result.stdout  
    [Return]  ${result}

File is in Device Path
    [Arguments]  ${file}  ${dst_path}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Is File in Device Path  ${file}  ${dst_path}  ${device_name}
    Should Be True  ${result}

File is not in Device Path
    [Arguments]  ${file}  ${dst_path}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Is File in Device Path  ${file}  ${dst_path}  ${device_name}
    Should Not Be True  ${result}

Wait Some Seconds for File to Exist in Device
    [Documentation]  Wait a maximum of ${seconds}*5 to find a file in a path.
    [Arguments]  ${seconds}  ${file_path}  ${device_name}=${TEST_DEVICE_ID}
    ${file_name}  Fetch From Right  ${file_path}  /
    ${path}  Fetch From Left  ${file_path}  ${file_name}
    FOR  ${n}  IN RANGE  ${seconds}
        ${file_found}  Is File in Device Path  ${file_name}  ${path}   ${device_name}
        Run Keyword If  $file_found  Exit For Loop
        Sleep  5s
    END
    Should Be True  ${file_found}

Count Current Files in Device Folder
    [Arguments]  ${folder_path}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  -s  ${device_name}  shell  cd  ${folder_path}  ;  ls
    ${elements}  Split To Lines  ${result.stdout}
    ${count}  Get Length  ${elements}
    Log  ${count}
    [Return]  ${count}

Get File from Device to Local Data Temp Folder
    [Documentation]  It gets a file from the device and stores it in Data/Temp folder. The name
    ...  used to save the file is pull_theNameOfTheFile.
    ...  The folder in the current project Data/Temp, has to be created first.
    [Arguments]  ${file_path}  ${device_name}=${TEST_DEVICE_ID}
    ${file_name}  Fetch From Right  ${file_path}  /
    ${output_file}  Set Variable  ${EXECDIR}\\Data\\Temp\\pull_${file_name}
    ${result}  Run Process  adb  -s  ${device_name}  pull  ${file_path}  ${output_file}
    Log  ${result.stdout}
    Should Not Contain  ${result.stdout}  error
    [Return]  ${output_file}

Show File Content from Device in Shell
    [Documentation]  It returns the output of the file.
    [Arguments]  ${file_content_path}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  -s  ${device_name}  shell  cat  ${file_content_path}
    [Return]  ${result}

Get File Information From Device
    [Documentation]  It will return information for the specified file, ${file_path}
    ...  is the complete root including the name of file and extension.
    ...  device id can be specified and the return information can be filtered.
    ...  For example, to only see Modification date set ${grep_filter}=Modify.
    ...  By default all the available information of the file available with stat will be displayed.
    [Arguments]  ${file_path}  ${grep_filter}=''  ${device_name}=${TEST_DEVICE_ID}
    ${file_name}  Fetch From Right  ${file_path}  /
    ${path}  Fetch From Left  ${file_path}  ${file_name}
    ${result}  Run Process  adb  -s  ${device_name}  shell  cd  ${path}  ;  stat  ${file_name}  |  grep  '${grep_filter}'
    Log  ${result.stdout}
    Log  ${result.stderr}
    Should Be Empty  ${result.stderr}
    [Return]  ${result.stdout}

Run adb getprop on Device
    [Arguments]  ${command}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  -s  ${device_name}  shell  getprop  ${command}
    Log  ${result.stdout}
    [Return]  ${result.stdout}
    
The Device is Rebooted
    [Arguments]  ${device_name}=${TEST_DEVICE_ID}  ${sleep_after_reboot}=30s
    Run Process  adb  -s  ${device_name}  reboot
    FOR  ${i}  IN RANGE  12
        Sleep  10s
        ${result}  Run Process  adb  devices
        Run Keyword If  '${device_name}' in $result.stdout  Exit For Loop
    END
    #Wait some time for some application to auto-launch
    Sleep  ${sleep_after_reboot}

The Device is On
    [Arguments]  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  devices
    Should Contain  ${result.stdout}  ${device_name}

Get Process Id of an App from Device
    [Documentation]  Returns the process id of a specific application if running.
    [Arguments]  ${package_name}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  -s  ${device_name}  shell  pidof  -s  ${package_name}
    Log  ${result.stdout}
    [Return]  ${result.stdout}

App is Running on Device
    [Documentation]  It checks if the application is running at the moment, it doesnt start it.
    [Arguments]  ${package_name}  ${device_name}=${TEST_DEVICE_ID}
    ${response}  Get Process Id of an App from Device  ${package_name}  ${device_name}
    ${app_found}  Evaluate  len($response)>1
    Should Be True  ${app_found}

App is not Running on Device
    [Documentation]  It checks if the application is currently stopped, it doesnt stop it.
    [Arguments]  ${package_name}  ${device_name}=${TEST_DEVICE_ID}
    ${response}  Get Process Id of an App from Device  ${package_name}  ${device_name}
    ${app_not_found}  Evaluate  len($response)<1
    Should Be True  ${app_not_found}

App is killed on Device
    [Documentation]  It closes the specified application.
    [Arguments]  ${package_name}  ${device_name}=${TEST_DEVICE_ID}
    Run Process  adb  -s  ${device_name}  shell  am  force-stop  ${package_name}

Start App with Activity on Device
    [Documentation]  It starts the specified application.
    [Arguments]  ${package_name}  ${activity_name}  ${device_name}=${TEST_DEVICE_ID}
    ${result}  Run Process  adb  -s  ${device_name}  shell  am  start  -n  
    ...  ${package_name}/${package_name}.${activity_name}
    Log  ${result.stdout}
    Should Not Match Regexp  ${result.stdout}  Error|Exception

App is Rebooted on Device
    [Arguments]  ${package_name}  ${activity_name}  ${device_name}=${TEST_DEVICE_ID}
    App is killed on Device  ${package_name}  ${device_name}
    Start App with Activity on Device  ${package_name}  ${activity_name}

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
    [Arguments]  ${url}  ${device_name}=${TEST_DEVICE_ID}
    Log To Console  ${url}
    ${result}  Run Process  adb  -s  ${device_name}  shell  curl  -sSL  -D  -  ${url}  -o  /dev/null  timeout=40s
    Log  ${result.stdout}
    Should Match Regexp  ${result.stdout}  .*HTTP/.*\\s4\\d\\d|2\\d\\d  #404|200|405

Turn Off the Wifi on Device by ADB
    [Arguments]  ${device_name}=${TEST_DEVICE_ID}
    Run Process  adb  -s  ${device_name}  shell  svc  wifi  disable
    ${wifi_status}  Check Wifi Status Adb  ${device_name}
    Should Contain  ${wifi_status}  Wi-Fi is disabling

Turn On the Wifi on Device by ADB
    [Arguments]  ${device_name}=${TEST_DEVICE_ID}  ${time_to_wait}=10
    Run Process  adb  -s  ${device_name}  shell  svc  wifi  enable
    FOR  ${n}  IN  RANGE  ${time_to_wait}
        ${wifi_status}  Check Wifi Status Adb  ${device_name}
        Exit For Loop If  '${wifi_status}' == 'Wi-Fi is enabled'
        Sleep  1s
    END
    
Wifi is On in the Device
    [Documentation]  Returns True if the Wifi is on, otherwise it returns false
    [Arguments]  ${device_name}=${TEST_DEVICE_ID}
    ${wifi_status}  Check Wifi Status Adb  ${device_name}
    ${wifi_on}  Set Variable If  '${wifi_status}'=='Wi-Fi is enabled'  True  False
    [Return]  ${wifi_on}

Create a File of Specific Size on Device
    [Documentation]  It creates a dummy file with a specif size ${file_size_with_units}, it must 
    ...  be specified as integer with the MB termination. ${file_path} musth have the complete
    ...  path to the destination folder and the name of the file with the extension.
    [Arguments]  ${file_path}  ${file_size_with_units}  ${device_name}=${TEST_DEVICE_ID}
    Run Process  adb  -s  ${device_name}  shell  truncate  -s  ${file_size_with_units}  ${file_path}