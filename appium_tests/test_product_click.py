from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

# 1. Setup Capabilities
options = UiAutomator2Options()
options.platform_name = 'Android'
options.automation_name = 'UiAutomator2'
options.device_name = 'emulator-5554'
options.app_package = 'com.example.laza_app'
options.app_activity = '.MainActivity'
options.no_reset = True 

# 2. Connect to Server
print("Connecting to Appium...")
driver = webdriver.Remote('http://127.0.0.1:4723', options=options)
wait = WebDriverWait(driver, 20)

try:
    print("App launched! Waiting for UI...")
    time.sleep(5) # Give Flutter time to draw the screen

    # 3. SMART SEARCH
    # Instead of looking for exact text, we look for any View that CONTAINS "Red"
    # We use 'android.view.View' because that is what Flutter widgets really are.
    print("Looking for product...")
    
    xpath_query = '//android.view.View[contains(@content-desc, "Red")]'
    
    product = wait.until(EC.presence_of_element_located(
        (AppiumBy.XPATH, xpath_query)
    ))
    
    product.click()
    print("Success! Clicked the product.")

    time.sleep(5)

except Exception as e:
    print("Could not find text. Using Backup Plan: Coordinate Click.")
    # 4. BACKUP PLAN: If text fails, we tap the screen position directly.
    # (Coordinates for top-left product: x=270, y=650)
    driver.execute_script('mobile: clickGesture', {'x': 270, 'y': 650})
    print("Clicked by coordinates!")

finally:
    driver.quit()