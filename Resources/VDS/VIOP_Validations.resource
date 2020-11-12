*** Settings ***
Documentation    This class has necessary keywords for validation of Data Items in Step 19.
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

Verify Ignition State 'transitioned to HIGH'
    [Documentation]    Verifies the given Bus Health State (Good or Bad) according to the CoreBus info.
    ...  Before calling this keyword be sure that 'Log To File' or 'Log To File N Seconds'
    ...  methods are called from TitanLibrary.    
    ${filename}    get log file path    viop
    ${file_content}    get file    ${filename}    encoding_errors=ignore
    @{lines}  Split To Lines    ${file_content}
    
    FOR  ${line}  IN  @{lines}               
        ${flag}    Run Keyword And Return Status  should contain  ${line}  HARD-WIRED IGN    
        ${wanted} =  Set Variable If    '${flag}' == 'True'   ${line}
        Exit for loop if    '${flag}' == 'True'
    END
    Should Contain    ${wanted}  transitioned to HIGH  msg=Couldn't get Hard-Wired Ign reason    values=False
    log    ${wanted}
    [Return]  ${wanted}

   