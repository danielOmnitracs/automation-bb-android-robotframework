*** Settings ***
Documentation    This class has some necessary keywords for validation from VIOP logs.
Library    TitanLibrary.handlers.serialdriver.SerialDriver
Library    ../../CustomLibraries/logParser.py
Library    OperatingSystem
Library    Process
Library    String


*** Variables ***


*** Keywords ***
Verify EngineRPM Value
    [Documentation]    Verifies the given EngineRPM value according to the CoreBus info. 
    ...  Before calling this keyword be sure that 'Log To File' or 'Log To File N Seconds'
    ...  methods are called from TitanLibrary.
    [Arguments]  ${core_bus}    ${engineRPM_value}
    ${filename}    get log file path    viop
    ${file_content}    get file    ${filename}    encoding_errors=ignore
    log    ${file_content}
    should contain any    ${file_content}    Current RPM \= ${engineRPM_value} from ${core_bus}
    ...    RPM Value: ${engineRPM_value}  values=False

Verify Bus Health State
    [Documentation]    Verifies the given Bus Health State (Good or Bad) according to the CoreBus info.
    ...  Before calling this keyword be sure that 'Log To File' or 'Log To File N Seconds'
    ...  methods are called from TitanLibrary.
    [Arguments]  ${core_bus}    ${expected_state}
    ${filename}    get log file path    viop
    ${file_content}    get file    ${filename}    encoding_errors=ignore
    log    ${file_content}
    should contain    ${file_content}   ${core_bus} Bus Health State: ${expected_state}  ignore_case=True  
    ...  values=False


