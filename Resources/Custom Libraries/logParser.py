

def get_text_surrounded_by_string(filename, stringToFind):
    """ This method accepts two parameters: filename and stringToFind.
        Parameters
        ---------
        filename: str
            The absolute path of the file that will be parsed.
        
        stringToFind: str
            a statement that exists at least twice inside the given file.      
        

        EX:
            get_text_surrounded_by_string(filename, 'Step=15')

        filename can be obtained dynamically with the get_log_file_path method which exist in TitanLibrary.

        - The method will parse the specified log file according to the given stringToFind.
        - The method is written aiming that the given keyword exists at least twice inside the file.
        - And the returning string will consist of data that exists between the 2 keywords.
        - By default there is 45 seconds of timeout, in case it is necessary for the device to produce the logs.        

        If the stringToFind does NOT exist the method will return an empty string.

        Returns:
        -------
         str 
            lines of string starting with stringToFind and ending with stringToFind
    """
    stringToFind = stringToFind.lower() + ' ' 
    
    string_content = ''
    f = open(filename, 'r')
    line = f.readline()
    while line:                    
        if stringToFind in line.lower():
            while line:
                string_content += line
                line = f.readline()
                if stringToFind in line.lower():
                    string_content += line
                    break
        line = f.readline()
    f.close()
    return string_content




"""Examples for the method:

If the stringToFind is "Step=15"


09/30 10:05:29 [Vds.UpdateTimer,INF] Conf: Step=15 ConfigurationVerification started. Total time=39.11 sec. IgnitionTimer: 39100 ms.
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf: VDS configuration verification started.
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf:    Core data item DistanceLtd configuration verified.  Receiving data from 0xFEC100.
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf:    Core data item EngineRpm configuration verified.  Receiving data from 0xF00400.
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf:    Core data item FuelLtd configuration verified.  Receiving data from 0xFEE900.
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf:    Core data item Speed configuration verified.  Receiving data from 0xFEF100.
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf:    Core data item configuration verified.  All 4 core data items are receiving data.
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf: CoreBus = J1939.  J1939 count: 4, J1587 count: 0
09/30 10:05:29 [ConnectionService,CRI] DNS Probe failed
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf: VDS configuration completed. Success. Locked Data Items: 5, Wildcards: 0, Elapsed time: 39.132 sec.
09/30 10:05:29 [Vds.UpdateTimer,INF] Conf: Step=15 ConfigurationVerification ended. Step time=0.03 sec. Total time=39.14 sec, attempts:1. IgnitionTimer: 39133 ms.

OR

If the stringToFind is "SYSTEM INFO"
the method returns:
  --------------------- SYSTEM INFO ------------------------
                          UA: 170001767
            Main App Version: ivgabb 3.0.53
                VIOP Version: 3.0.0.0
                         DDD: O1IMXHW003 O1LPCHW003 O1RFAHW003
        Omnitracs OS Version: OA7 2.11 Wed Jun 03 13:08:22 CDT 2020
          BootLoader Version: 2017.03 Wed Jun 3 11:45:45 PDT 2020
              Kernel Version: 4.9.17
          Android OS Version: 7.1.2
                         MCN: CV90-JE103-100
                       ICCID: 
                 IMEI / MEID: 
       MAC Address Bluetooth: [84:25:3F:50:B9:FD] [84:25:3F:50:B9:FD] [22:22:39:E9:62:DD]
            MAC Address Wifi: [84:25:3F:50:B9:FC] []
           MAC Address Modem: 16:E7:3A:2E:09:08
           MDM Agent Version: 13.7.3 Build 1045
      OT1 Master App Version: 2.0.9
    VIOP Upgrade App Version: 2.0.4
     Diagnostics App Version: 3.0.19
         OtInterface Version: 3.0.9
                Disk usage %: 0
               Reboot reason: TruckPowerLoss(15)
                  Active Set: te-prod
    --------------------- SYSTEM INFO ------------------------

"""