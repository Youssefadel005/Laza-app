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
    print("--- STEP 1: Select Product ---")
    xpath_query = '//android.view.View[contains(@content-desc, "Classic Red")]'
    
    try:
        # Try to find the product immediately
        product = wait.until(EC.presence_of_element_located((AppiumBy.XPATH, xpath_query)))
        product.click()
    except:
        print("Product not found! We might be on the wrong screen.")
        print("Pressing BACK button and trying again...")
        driver.back() # Press Android Back Button
        time.sleep(2)
        # Try finding it one more time
        product = wait.until(EC.presence_of_element_located((AppiumBy.XPATH, xpath_query)))
        product.click()
        
    print("Clicked Product.")

    print("--- STEP 2: Add to Cart ---")
    time.sleep(2) 
    add_btn = wait.until(EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, "Add to Cart")))
    add_btn.click()
    print("Clicked 'Add to Cart'.")

    print("--- STEP 3: Go to Cart Screen ---")
    time.sleep(2) 
    # Find all buttons. The Cart icon is usually the last one.
    buttons = driver.find_elements(AppiumBy.CLASS_NAME, "android.widget.Button")
    
    if len(buttons) > 0:
        print(f"Found {len(buttons)} buttons. Clicking the last one...")
        buttons[-1].click()
    else:
        print("No buttons found! Trying backup coordinates.")
        driver.execute_script('mobile: clickGesture', {'x': 980, 'y': 150})
        
    print("Attempted to open Cart Screen.")

    print("--- STEP 4: VERIFY ---")
    time.sleep(3)
    
    # Check if the product text exists on the new screen
    cart_item = driver.find_element(AppiumBy.XPATH, '//android.view.View[contains(@content-desc, "Classic Red")]')
    
    if cart_item:
        print("✅ TEST PASSED: Item found in Cart!")
    else:
        print("❌ TEST FAILED: Cart is empty.")

except Exception as e:
    print("Something went wrong.")
    print(e)

finally:
    driver.quit()
