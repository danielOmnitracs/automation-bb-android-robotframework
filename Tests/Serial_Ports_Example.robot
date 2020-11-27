*** Settings ***
#To use this library it must be installed in the used environment
#In the termina 'pip install path/to/wheel/of/package'
Library    TitanLibrary.handlers.serialdriver.SerialDriver
Resource    ../Resources/SharedTools/SerialPorts.resource


Test Teardown  Close Port

*** Test Cases ***
Bluetooth word appears in 1 min 3 times in log APP
    Set Test Case  Find_bluetooth_word_1_min_app_log
    Log Serial Ports To File
    String Appears in X min Y Times in Log  Bluetooth  1  3  app
    [Teardown]  Close Port

Bluetooth word dont appears in 1 min 3 times in log VOIP
    Set Test Case  Bluetooth_word_is_not_in_viop_log
    Log Serial Ports To File
    String Dont Appears in X min Y Times in Log  Bluetooth  1  3  viop
    [Teardown]  Close Port

One of the first 4 lines with Bluetooth text, shows 'Disable channels:1'
    [Tags]  TC11
    Set Test Case  Disable_channels_1
    Log n Lines to File App  50 
    N Number of Filtered Lines of Log File Should Contain a String  4  Bluetooth  app  Disable channels:1
    [Teardown]  close port

Specific string is in viop log
    Set Test Case   Specific_string_in_viop_log
    Log Serial Ports To File N Seconds  10s
    String Found in Serial Log File  Checking bit rate of 500k Bits/s  viop
    [Teardown]  Close Serial Ports

Specific string is not in app log
    Set Test Case   Specific_string_in_app_log
    Log Serial Ports To File N Seconds  10s
    String not Found in Serial Log File  Checking bit rate of 500k Bits/s  app
    [Teardown]  Close Serial Ports

Specific word is in app log at least 1 time
    Set Test Case  specific_word_in_app_log
    Log Serial Ports To File N Seconds  25s
    Word is in Log File More Than N Times  BT  app  1
    [Teardown]  Close Serial Ports

CAN Watchdog j1939 are present in viop log
    Set Test Case  words_are_in_viop_log
    Log Serial Ports To File N Seconds  10s
    Serial Log File Contains Words  viop  cAn  WATCHDOG  j1939
    [Teardown]  Close Serial Ports

The Wifi Keeps Alive
    Set Test Case  temperature_logic_value
    Log Serial Ports To File N Seconds  30s
    ${lines_with_string}  Get N Lines Containing a String from Log  3  WiFi Hotspot Alive  App
    Log  ${lines_with_string} 
    FOR  ${list_element}  IN  @{lines_with_string}
        Log  ${list_element}
        Should Contain  ${list_element}  true
    END
    [Teardown]  Close Serial Ports