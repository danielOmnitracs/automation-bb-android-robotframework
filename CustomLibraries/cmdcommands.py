import subprocess

def check_wifi_status_adb():
    res = subprocess.run(["adb","shell","dumpsys", "wifi", "|", "grep", "'Wi-Fi is'"],capture_output=True)
    response_string = res.stdout.decode("utf-8")
    return response_string.replace('\r\n','')
