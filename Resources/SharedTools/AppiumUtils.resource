*** Settings ***
Library  AppiumLibrary  

*** Variables ***

*** Keywords ***
Click with Swipe
    [Documentation]  This keyword will scroll down unless is possible to click the given locator. 
    ...  By default it will scroll down 5 times.
    [Arguments]  ${locator}  ${n_times_to_scroll}=5
    FOR  ${i}  IN RANGE  ${n_times_to_scroll}
      ${flag}  Run Keyword And Return Status    Click Element    ${locator}
      Exit For Loop If    ${flag}  
      Run Keyword Unless    ${flag}    Swipe  700  600  700  100            
    END 