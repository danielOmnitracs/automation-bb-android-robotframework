*** Settings ***
Library  AppiumLibrary  
Variables  Diagnostics.yaml


*** Variables ***

${appPackage} =  com.omnitracs.diagnostics
${appActivity} =  com.omnitracs.diagnosticsui.activity.MainActivity


*** Keywords ***
Verify Ignition State in Diagnostics App 
    [Documentation]  Verifies the ignition state in Diagnostics under System Menu
    [Arguments]  ${ignition_state}
    
    Start App    ${appPackage}  ${appActivity}
    Click Element    ${ALLOW_BUTTON}
    Click Element    ${ALLOW_BUTTON}
    Wait Until Page Contains  System
    Click Element  ${SYSTEM_MENU_BUTTON}
    Wait Until Page Contains  Ignition State 
    Element Text Should Be    ${SYSTEM_MENU.ignition_State}    ${ignition_state}     
   
    [Teardown]  close application


Verify Update version in Diagnostics App 
    [Documentation]  Verifies the ignition state in Diagnostics under System Menu    
    
    Start App    ${appPackage}  ${appActivity}
    Click Element    ${ALLOW_BUTTON}
    Click Element    ${ALLOW_BUTTON}
    Wait Until Page Contains  System
    Click Element  ${INSTALLATION_MENU_BUTTON}
    Wait Until Page Contains  Unit Address 
    ${text}  Get Text  ${INSTALLATION_MENU.unit_address_value}    
    #Element Text Should Be    ${SYSTEM_MENU.Ignition_State}    ${ignition_state}    
    log to console  ${text} 
   
    [Teardown]  close application
