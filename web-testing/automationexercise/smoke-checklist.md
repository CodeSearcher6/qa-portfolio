# Smoke checklist — automationexercise.com

A short pass over the critical paths, run after every deployment. The goal is to
decide whether the build is stable enough to test further — not to test in depth.
Full coverage lives in the test cases.

**Expected duration:** 15–20 minutes.
**Stop rule:** if any item in *Availability*, *Authentication*, *Cart* or *Checkout*
fails, the build is rejected and deeper testing does not start.

## Availability

- [ ] Home page loads without errors
- [ ] No 4xx or 5xx responses on the main pages
- [ ] No errors in the browser console (DevTools)
- [ ] Images and styles load — no broken images or unstyled content

## Navigation

- [ ] Header menu links open the correct pages
- [ ] Category list expands and subcategory links work
- [ ] Brand links open a filtered product list
- [ ] Static pages open (Test Cases, API Testing, Contact Us)

## Authentication

- [ ] Registration completes and the account is created
- [ ] Login with valid credentials works
- [ ] Invalid credentials are rejected with an error message
- [ ] Logout ends the session
- [ ] Delete Account works and shows the confirmation

## Catalog

- [ ] Product list is displayed with names and prices
- [ ] View Product opens the product page
- [ ] Product page shows name, price, availability and quantity control
- [ ] Quantity control increases and decreases the value

## Cart

- [ ] Add to cart works from the product list
- [ ] Add to cart works from the product page
- [ ] Cart page opens and shows the item with the correct price and quantity
- [ ] Item can be removed and the total is recalculated
- [ ] Empty cart shows the empty-state message

## Checkout

- [ ] Checkout is available to a logged-in user
- [ ] Anonymous user is prompted to log in or register
- [ ] Address details page shows the account's delivery address
- [ ] Order total on the review step matches the cart total
- [ ] Order can be placed and the confirmation page is shown
- [ ] Invoice download works

## Known issues to re-check

Defects found during testing — verified on each build until they are fixed.
See the test cases document for details.

- [ ] F-01 — order is placed with an invalid card number
- [ ] F-02 — negative quantity produces a negative line total
- [ ] F-03 — quantities are summed with no upper bound
- [ ] F-04 — quantity 0 is accepted on some products
