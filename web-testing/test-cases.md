# QA Case Study — automationexercise.com

Manual testing of the account and shopping flow on a public demo e-commerce site.
All cases were executed by hand in the browser; the observations in **Findings**
come from that run, not from the site's own documentation.

## Scope

**In scope:** user registration, login and logout, account deletion, adding items to
the cart, cart persistence across sessions, and the checkout flow.

**Out of scope:** password recovery, product search and filters, the contact form,
the subscription mailing list, responsive layout, and anything behind real payment
processing.

**Environment:** Chrome (latest), macOS, desktop 1440×900.

## Application structure

Registration happens in two steps. The first screen asks for a name and an email.
The second screen — *Enter Account Information* — asks for a title (Mr / Mrs),
name, email, password, date of birth and a newsletter checkbox, followed by
*Address Information*: first name, last name, company, two address lines, country,
state, city, zip code and mobile number.

Checkout requires an authenticated user. An anonymous user is redirected to the
login page and returns to the cart afterwards.

---

## Findings

Observations from testing, kept separate from the test cases. Each one is either a
defect or a question for the analyst.

### Defects

| # | Finding | Severity |
|---|---|---|
| F-01 | **An order is placed with an invalid card number.** The payment form accepts arbitrary input in the card number field — no format, length or checksum validation — and the order confirmation page is shown. The order reaches the system with no valid payment behind it. | Critical |
| F-02 | **A negative quantity produces a negative line total.** Adding a product with quantity `-1` puts it in the cart priced at the negative of its value (a 1000 item shows as −1000), so the line subtracts from the order instead of adding to it. Combined with F-01, an order can be completed for a reduced or negative total using an invalid card. | Critical |
| F-03 | **Quantities are summed with no upper bound.** Adding the same product with `0`, `-1` and `9999999999` results in a single cart line showing `9999999998` — the values are added together, the negative one subtracts, and no maximum is enforced. | Major |
| F-04 | **Quantity `0` is accepted on some products.** The item is added to the cart with a line total of 0. The behaviour is not consistent across the catalogue — it reproduces on some products and not on others, which suggests validation exists in one code path but not another. Needs further isolation to identify what distinguishes the affected products. | Minor |

### Behaviour worth confirming

1. **Cart survives logout and re-login.** Items added while authenticated are still
   in the cart afterwards. Expected for a real shop, but worth confirming it is
   intentional rather than a side effect.
2. **Anonymous users can add to the cart** and the items are merged into the account
   after login. The merge rule (replace or append) is not documented.
3. **Checkout blocks anonymous users only at the last step** — the user fills the
   cart, presses Checkout, and only then is told to log in. Checking earlier would
   be friendlier.

---

## Authentication

| # | Brief description | Prerequisites | Consistency | Result |
|---|---|---|---|---|
| TC-01 | Registration with all mandatory fields | Signup / Login page is open, the email is not registered | 1. Enter a name and an email, click Signup<br>2. Fill in all mandatory fields on the Enter Account Information form<br>3. Fill in Address Information and click Create Account | 1. The Enter Account Information form opens<br>2. The fields accept the values<br>3. The Account Created message is shown and the user is logged in |
| TC-02 | Registration without optional fields | Signup / Login page is open, the email is not registered | 1. Complete registration leaving Company and Address line 2 empty | 1. The account is created — optional fields do not block submission |
| TC-03 | Login with valid credentials | The account exists, the user is logged out | 1. Click Signup / Login<br>2. Enter the registered email and password<br>3. Click Login | 1. The login page opens<br>2. The credentials are accepted<br>3. The home page shows "Logged in as *username*" |
| TC-04 | Logout | The user is logged in, the home page is open | 1. Click Logout | 1. The user is redirected to the login page and the session ends |
| TC-05 | Account deletion | The user is logged in, the home page is open | 1. Click Delete Account | 1. The ACCOUNT DELETED message is shown<br>2. The session ends |
| TC-06 | Signup with an already registered email | Signup / Login page is open, the email is already registered | 1. Enter a name and the registered email<br>2. Click Signup | 1. An error states that the email already exists<br>2. The account information form does not open |
| TC-07 | Login with incorrect credentials | The user is logged out, the login page is open | 1. Enter an email and password that do not match<br>2. Click Login | 1. The message "Your email or password is incorrect!" is shown<br>2. The user stays on the login page |
| TC-08 | Login with empty fields | The user is logged out, the login page is open | 1. Leave the email empty and click Login<br>2. Repeat with the password empty | 1. A required-field prompt is shown for the empty field<br>2. The form is not submitted in either case |
| TC-09 | Signup with an invalid email format | Signup / Login page is open | 1. Enter `test`, then `test@`, then `test@@mail.com`, then `test @mail.com` | 1. Each value is rejected with a validation message<br>2. No account is created |
| TC-10 | Login after account deletion | The account has just been deleted | 1. Try to log in with the deleted account's credentials | 1. The credentials are rejected — the account no longer exists |

## Cart

| # | Brief description | Prerequisites | Consistency | Result |
|---|---|---|---|---|
| TC-11 | Add an item while logged in | The user is logged in, the products page is open | 1. Click Add to cart on any product<br>2. Open the cart | 1. A confirmation dialog offers to view the cart or continue shopping<br>2. The item is listed in the cart |
| TC-12 | Add an item while logged out | The user is logged out, the products page is open | 1. Add any product to the cart<br>2. Open the cart | 1. The item is added<br>2. The cart is available without authentication |
| TC-13 | Cart persists across a session | The user is logged in with at least one item in the cart | 1. Log out<br>2. Log back in<br>3. Open the cart | 1. The session ends<br>2. The user is authenticated again<br>3. The item is still in the cart |
| TC-14 | Anonymous cart is kept after login | The user is logged out with at least one item in the cart | 1. Log in to an existing account<br>2. Open the cart | 1. The item added before login is still present |
| TC-15 | Quantity of the same product | The products page is open | 1. Add the same product twice | 1. The cart shows one line with quantity 2, not two separate lines |
| TC-16 | Remove an item | The cart contains at least one item | 1. Click the delete icon next to the item | 1. The item is removed and the total is recalculated |
| TC-17 | Empty cart state | The user is logged in, the cart is empty | 1. Open the cart | 1. The message "Cart is empty! Click here to buy products" is shown |

## Checkout

| # | Brief description | Prerequisites | Consistency | Result |
|---|---|---|---|---|
| TC-18 | Checkout as an authenticated user | The user is logged in, the cart contains at least one item | 1. Open the cart and click Checkout<br>2. Click Place Order<br>3. Fill in the payment fields<br>4. Click Pay and Confirm Order | 1. The address details page opens<br>2. The payment page opens<br>3. The fields accept the values<br>4. The order confirmation page is shown |
| TC-19 | Checkout as an anonymous user | The user is logged out, the cart contains at least one item | 1. Open the cart and click Checkout<br>2. Follow the register / login prompt<br>3. Log in<br>4. Open the cart and complete the order | 1. A prompt states that registration or login is required<br>2. The login page opens<br>3. The user is authenticated<br>4. The order is placed and the confirmation page is shown |
| TC-20 | Checkout with an empty cart | The user is logged in, the cart is empty | 1. Open the cart<br>2. Click Checkout | 1. The empty-cart message is shown<br>2. Checkout cannot be started |
| TC-21 | Payment with empty mandatory fields | The user is on the payment page | 1. Leave all card fields empty and click Pay and Confirm Order<br>2. Fill in the first field and click again | 1. A required-field prompt is shown for the first empty field<br>2. The prompt moves to the next empty field; the order is not placed until every mandatory field is filled |
| TC-22 | Payment with an invalid card number | The user is on the payment page | 1. Enter a non-numeric value in the card number field<br>2. Enter a number that fails the Luhn checksum<br>3. Click Pay and Confirm Order | 1. Each value is rejected with a validation message<br>2. The order is not placed — see **F-01** |
| TC-23 | Order total matches the cart | The cart contains several items | 1. Note the cart total<br>2. Proceed to the review-order step | 1. The total on the review step equals the cart total |

## Boundary cases

| # | Brief description | Prerequisites | Consistency | Result |
|---|---|---|---|---|
| TC-24 | Very long name | Signup / Login page is open | 1. Enter a 200-character name and submit | 1. The value is either accepted and displayed in full, or rejected with a length message — no silent truncation |
| TC-25 | Leading and trailing spaces | Signup / Login page is open | 1. Enter an email with a space before and after it | 1. The spaces are trimmed or the value is rejected — the account is not created under a different address |
| TC-26 | Special characters in the name | Signup / Login page is open | 1. Enter `<script>`, `&` and `"` in the name field<br>2. Complete registration | 1. The characters are escaped on display<br>2. No script is executed anywhere in the account area |
| TC-27 | Quantity of zero | A product page is open | 1. Set the quantity to 0 and add to cart<br>2. Open the cart<br>3. Repeat on several different products | 1. The value is rejected with a validation message<br>2. No line with quantity 0 appears in the cart<br>3. The behaviour is the same for every product — see **F-04** |
| TC-28 | Negative quantity | A product page is open | 1. Set the quantity to -1 and add to cart<br>2. Open the cart | 1. The value is rejected<br>2. No line with a negative quantity or a negative line total appears — see **F-02** |
| TC-29 | Extreme quantity | A product page is open | 1. Set the quantity to 9999999999 and add to cart<br>2. Open the cart | 1. The value is capped at a documented maximum or rejected<br>2. The cart never shows a quantity beyond the allowed range — see **F-03** |
