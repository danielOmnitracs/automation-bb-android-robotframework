*** Settings ***
Documentation  Resource mean for storing keywords for file management.
...  Execute the test suite from the root of the project

Library  OperatingSystem
Library  String
Library  ../../CustomLibraries/handlelist.py

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

Files are Equal
    [Documentation]  Compares two file line by line. Deletes the lines containing the values
    ...  in ${elements_to_delete} if speficied (values separated by ',').
    [Arguments]  ${file_content_path}  ${comparation_file_path}  ${elements_to_delete}=delete none
    ${file_content_list}  ${comparing_list}  Files Content to List  ${file_content_path}  ${comparation_file_path}
    ...  ${elements_to_delete}
    Lists Should Be Equal  ${file_content_list}  ${comparing_list}

Files are not Equal
    [Documentation]  Compares two file line by line. Deletes the lines containing the values
    ...  in ${elements_to_delete} if speficied (values separated by ',').
    [Arguments]  ${file_content_path}  ${comparation_file_path}  ${elements_to_delete}=delete none
    ${file_content_list}  ${comparing_list}  Files Content to List  ${file_content_path}  ${comparation_file_path}
    ...  ${elements_to_delete}
    Should Not Be Equal  ${file_content_list}  ${comparing_list}  ignore_case=True

Files Content to List
    [Documentation]  Change a file to a list, where every line is a list element.
    ...  It deletes, in ${file_content_path}, the lines containing the elements
    ...  in ${elements_to_delete} if specified.
    [Arguments]  ${file_content_path}  ${comparation_file_path}  ${elements_to_delete}=delete none
    ${comparing_list}  Get File  ${comparation_file_path}
    ${comparing_list}  Split To Lines  ${comparing_list}
    ${result}  Show File Content from Device in Shell  ${file_content_path}
    ${file_content_list}  Split To Lines  ${result.stdout}
    Log  ${elements_to_delete}
    ${file_content_list}  Delete Elements From List  ${elements_to_delete}  ${file_content_list}
    Log  ${file_content_list}
    Log  ${comparing_list}
    [Return]  ${file_content_list}  ${comparing_list}

Create Command Configuration File with a Command in Local Folder
    [Documentation]  Data/TestFiles folder should be created in the root of the project.
    [Arguments]  ${command}
    Create File  ${EXECDIR}/Data/TestFiles/command.ini  content=${command}