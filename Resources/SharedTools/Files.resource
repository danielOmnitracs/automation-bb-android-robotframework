*** Settings ***
Documentation  Resource mean for storing keywords for file management.
...  For this resource it is needed the scalar variable ${TEST_DEVICE_ID} which will be 
...  the id of the device under test that is shown in "adb devices". 
...  Execute the test suite from the root of the project. All the keywords related to a device 
...  can be applied to another device for example to a table, it this case it is needed to specify
...  the device name as an argument when calling the keyword.

Library  OperatingSystem
Library  String
Library  Collections
Library  ../../CustomLibraries/handlelist.py
Resource  adb.resource

*** Keywords ***
Get Lines Matching a regexp from File
    [Documentation]  Returns a List of the lines that contain the specified regexp in the file
    [Arguments]  ${file_path}  ${regexp}
    ${file_content}  Get File  ${file_path}
    ${file_list}  Split To Lines  ${file_content}
    ${file_matching_elements}  Get Matches  ${file_list}  regexp=${regexp}  case_insensitive=True
    Log  ${file_matching_elements}
    ${size_list}  Get Length  ${file_matching_elements}
    [Return]  ${file_matching_elements} 

Get First Line Matching a regexp from File 
    [Documentation]  This will return the first line that matches the regexp (it also can be the complete word)
    [Arguments]  ${file_path}  ${regexp}
    @{lines}  Get Lines Matching a regexp from File  ${file_path}  ${regexp} 
    ${first_line}  Set Variable  ${lines}[0]
    [Return]  ${first_line}

Filtered Device File is Equal To Local File
   [Documentation]  Compares two file line by line. Deletes the lines in the file containing the values
    ...  in ${elements_to_delete}, if speficied (values separated by ',').
    [Arguments]  ${device_file_path}  ${local_file_path}  ${elements_to_delete}=delete none  ${device_name}=${TEST_DEVICE_ID}
    ${local_path_device_file}  Get File from Device to Local Data Temp Folder  ${device_file_path}  ${device_name}
    ${device_file_list}  File Content to List  ${local_path_device_file}  ${elements_to_delete}
    ${local_file_list}  File Content to List  ${local_file_path}  ${elements_to_delete}
    Remove File  ${local_path_device_file}
    Lists Should Be Equal  ${device_file_list}  ${local_file_list}

Filtered Device File is not Equal To Local File
   [Documentation]  Compares two file line by line. Deletes the lines in the file containing the values
    ...  in ${elements_to_delete}, if speficied (values separated by ',').
    [Arguments]  ${device_file_path}  ${local_file_path}  ${elements_to_delete}=delete none  ${device_name}=${TEST_DEVICE_ID}
    ${local_path_device_file}  Get File from Device to Local Data Temp Folder  ${device_file_path}  ${device_name}
    ${device_file_list}  File Content to List  ${local_path_device_file}  ${elements_to_delete}
    ${local_file_list}  File Content to List  ${local_file_path}  ${elements_to_delete}
    Remove File  ${local_path_device_file}
    Should Not Be Equal  ${device_file_list}  ${local_file_list}  ignore_case=True

File Content to List
    [Documentation]  Change a file to a list, where every line is a list element.
    ...  It deletes in file the lines containing the elements in ${elements_to_delete}, if specified.
    [Arguments]  ${file_path}  ${elements_to_delete}=delete none
    ${file_content_list}  Get File  ${file_path}
    ${file_content_list}   Split To Lines  ${file_content_list} 
    Log  ${elements_to_delete}
    ${file_content_list}  Delete Elements From List  ${elements_to_delete}  ${file_content_list}
    Log  ${file_content_list}
    [Return]  ${file_content_list}

Create Command Configuration File with a Command in Local Folder
    [Documentation]  Data/TestFiles folder should be created in the root of the project.
    [Arguments]  ${command}
    Create File  ${EXECDIR}/Data/TestFiles/command.ini  content=${command}