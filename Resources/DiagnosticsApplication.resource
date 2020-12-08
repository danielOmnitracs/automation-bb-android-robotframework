*** Settings ***
Documentation  Page Object for Diagnostics Application.
Library  AppiumLibrary  
Variables  ../Data/Diagnostics.yaml

*** Variables ***
${appPackage} =  com.omnitracs.diagnostics
${appActivity} =  com.omnitracs.diagnosticsui.activity.MainActivity

*** Keywords ***
Verify Ignition State in Diagnostics App 
    [Documentation]  Verifies the ignition state in the System Menu of Diagnostics application.
    [Arguments]  ${ignition_state}    
    Start App    ${appPackage}  ${appActivity}
    Click Element    ${ALLOW_BUTTON}
    Click Element    ${ALLOW_BUTTON}
    Wait Until Page Contains  System
    Click Element  ${SYSTEM_MENU_BUTTON}
    Wait Until Page Contains  Ignition State 
    Element Text Should Be    ${SYSTEM_MENU.ignition_State}    ${ignition_state} 
    [Teardown]  Close Application