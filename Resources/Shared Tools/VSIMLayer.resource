*** Settings ***
Documentation    Reaches to the CommandLine module for the automation of VSIM app.
Library    TitanLibrary.handlers.commandline

# After importing the "commandline" module, Pycharm IDE shows "keyword not found error"
# Probably it is a bug, the keywords work without any problem.
*** Keywords ***

Send a 'command' to VSIM
    [Documentation]    For this keyword as an argument the commands are: connect, run, stop, pause,
    ...    resume, disconnect and exit.
    [Arguments]    ${command}
    ${result}    send a command to vsim    ${command}
    log to console    ${result}
    log     ${result}

    run keyword IF    '${command}' == 'connect'    should contain    ${result}    Connected to Service
    ...    ELSE     should contain    ${result}    Sucessfully

Send command to VSIM open a script
    [Documentation]    The script we want to run in VSIM is assumed to be in 'Data/VsimScripts' folder of the project.
    ...    When this keyword is called, only the file name (with extention) should be given as an argument.
    [Arguments]    ${filename}
    ${result}    send a command to vsim    open, ${EXEC_DIR}/Data/VsimScripts/${filename}
    log to console    ${result}
    log     ${result}
    should contain    ${result}    Sucessfully


