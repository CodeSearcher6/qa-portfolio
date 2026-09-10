# automationexercise.com — e-commerce flow

Manual testing of a demo online shop: registration, login, cart and checkout.
A practice project, used to build a full set of test documentation from scratch.

**Scope:** account creation and login, cart behaviour across sessions, checkout
and payment form.
**Out of scope:** search and filters, contact form, subscription, responsive layout.

**Result:** 4 defects found, two of them Critical.

| File | What's inside |
|---|---|
| [test-cases.md](test-cases.md) | 29 test cases — positive, negative and boundary scenarios, plus findings with severity |
| [smoke-checklist.md](smoke-checklist.md) | 31-point post-deployment pass with an explicit build acceptance rule and a regression block |
| [bug-reports/](bug-reports/) | Detailed reports for the two Critical defects, with steps to reproduce and screenshots |

## The two Critical findings

**An order is placed with an invalid card number.** The payment form performs no
format, length or checksum validation — an order reaches the system with no valid
payment behind it.

**A negative quantity produces a negative line total.** A cart line priced at
Rs. 600 with quantity `-1` shows as `-600`, subtracting from the order sum instead
of adding to it.

Together they allow an order to be completed for a reduced total with no valid
payment. The second one was found through exploratory testing — by entering values
into the quantity field that no test case anticipated.
