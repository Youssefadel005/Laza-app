from appium import webdriver
from appium.options.android import UiAutomator2Options
import time

# 1. Setup the "Capabilities"
options = UiAutomator2Options()
options.platform_name = 'Android'
options.automation_name = 'UiAutomator2'
options.device_name = 'emulator-5554'
options.app_package = 'com.example.laza_app'
options.app_activity = '.MainActivity'
options.no_reset = True 

# 2. Connect to the Appium Server
print("Connecting to Appium...")
driver = webdriver.Remote('http://127.0.0.1:4723', options=options)

# 3. The Test
try:
    print("App launched!")
    time.sleep(5) 
    print("Test Finished successfully.")

finally:
    driver.quit()