# Appium Test Cases

## Tools Used
- **Appium Version:** 3.1.2
- **Driver:** uiautomator2
- **Language:** Python
- **Device:** Android Emulator (Pixel)

---

## Test Case 1: Auth Test
**Description:** Verify that a user can log out and log back in successfully.
**Pre-conditions:** App is installed. User account exists.
**Steps:**
1. Open App.
2. Check if logged in (perform Logout if needed).
3. Enter valid Email and Password.
4. Click Login.
**Expected Result:** User is redirected to the Home Screen displaying products.

---

## Test Case 2: Cart Flow
**Description:** Verify adding a product to the cart.
**Steps:**
1. Browse Home Screen.
2. Click on "Classic Red Baseball Cap".
3. Click "Add to Cart".
4. Navigate to Cart Screen.
5. Verify item name exists in the list.
**Expected Result:** "Classic Red Baseball Cap" appears in the Cart screen.