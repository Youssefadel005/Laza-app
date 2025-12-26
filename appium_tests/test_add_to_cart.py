from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

# 1. Setup
options = UiAutomator2Options()
options.platform_name = 'Android'
options.automation_name = 'UiAutomator2'
options.device_name = 'emulator-5554'
options.app_package = 'com.example.laza_app'
options.app_activity = '.MainActivity'
options.no_reset = True 

print("Connecting to Appium...")
driver = webdriver.Remote('http://127.0.0.1:4723', options=options)
wait = WebDriverWait(driver, 20)

try:
    print("App launched!")
    time.sleep(3) 

    # --- STEP 1: CLICK PRODUCT ---
    print("Looking for Product...")
    try:
        # We use a special XPath that ignores the price and newlines
        xpath_query = '//android.view.View[contains(@content-desc, "Classic Red")]'
        product = wait.until(EC.presence_of_element_located((AppiumBy.XPATH, xpath_query)))
        product.click()
        print("Clicked Product (by Text)!")
    except:
        # Backup Plan: Coordinates
        print("Text failed. Using Backup Coordinates.")
        driver.execute_script('mobile: clickGesture', {'x': 270, 'y': 650})
        print("Clicked Product (by Coordinates)!")

    # --- STEP 2: CLICK ADD TO CART ---
    print("Waiting for Product Page...")
    time.sleep(3) # Wait for animation
    
    # Attempt to find the "Add to Cart" button
    # Usually, the text on the button is its ID
    print("Looking for 'Add to Cart' button...")
    
    # Try finding by Accessibility ID first (Standard Flutter)
    try:
        cart_btn = wait.until(EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, "Add to Cart")))
        cart_btn.click()
        print("SUCCESS: Clicked 'Add to Cart'!")
    except:
        # If ID fails, try XPath looking for the text
        cart_btn = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Add to Cart"]')
        cart_btn.click()
        print("SUCCESS: Clicked 'Add to Cart' (via XPath)!")

    time.sleep(5)

finally:
    driver.quit()