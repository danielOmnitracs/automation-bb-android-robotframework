*** Settings ***
Documentation    Reaches to the CommandLine module for the automation of VSIM app.
Library    TitanLibrary.handlers.commandline

*** Keywords ***
Send a 'command' to VSIM
    [Documentation]    For this keyword as an argument the commands are: connect, run, stop, pause,
    ...    resume, disconnect and exit.
    [Arguments]    ${command}
    ${result}    Send a Command to VSIM    ${command}
    Log To Console    ${result}
    Log     ${result}
    Run Keyword IF    '${command}' == 'connect'    Should Contain    ${result}    Connected to Service  
    ...    msg=A problem has occurred with the VSIM connection!
    ...    ELSE IF    '${command}' == 'exit'    Log    Could exit VSIM successfully.
    ...    ELSE     Should Contain    ${result}    Sucessfully  msg=A problem has occurred with the VSIM connection!\n 
    
Send Command to VSIM Open a Script
    [Documentation]    The script we want to run in VSIM is assumed to be in 'Data/VsimScripts' folder of the project.
    ...    When this keyword is called, only the file name (with extention) should be given as an argument.
    [Arguments]    ${filename}
    ${result}    Send a Command to VSIM    open, ${EXEC_DIR}/Data/VsimScripts/${filename}
    Log To Console    ${result}
    Log     ${result}
    Should Contain    ${result}    Sucessfully  msg=A problem has occurred while opening the script!


