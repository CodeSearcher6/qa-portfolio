# BUG-01 — Order is placed with an invalid card number

| | |
|---|---|
| **ID** | BUG-01 |
| **Severity** | Critical |
| **Priority** | High |
| **Status** | Open |
| **Component** | Checkout / Payment |
| **Reported by** | Vladyslav Suprun |
| **Date** | 2026-08-20 |

## Summary

The payment form accepts an arbitrary value in the card number field and completes
the order. No format, length or checksum validation is performed, so an order reaches
the system with no valid payment behind it.

## Environment

- **URL:** https://automationexercise.com
- **Browser:** Chrome 151.0.7922.175
- **OS:** macOS 26.5.2
- **Resolution:** 1440×900
- **Account:** registered test user

## Preconditions

1. The user is registered and logged in.
2. The cart contains at least one product.

## Steps to reproduce

1. Open the cart and click **Proceed To Checkout**.
2. Click **Place Order**.
3. Fill in the payment form with an invalid card number: `1111 abcd 9999 3214`.
4. Fill in the remaining mandatory fields with any valid values.
5. Click **Pay and Confirm Order**.

## Expected result

The card number fails validation. An error message is displayed next to the field,
the order is **not** placed, and the user stays on the payment page.

## Actual result

The value is accepted without any validation message. The order is placed and the
order confirmation page is displayed.

## Impact

An order with no valid payment enters the system. On a production shop this means the
warehouse sees a paid order that will never be settled. Combined with **BUG-02**
(negative quantity produces a negative line total), an order can be completed for a
reduced or negative total with an invalid card.

## Attachments

- `screenshots/bug-01-payment-form.png` — the payment form with the invalid value entered
- `screenshots/bug-01-order-confirmed.png` — the order confirmation page

## Notes

Not verified whether the value is rejected server-side after submission — the user
receives a success confirmation either way, which is itself misleading.

A well-formed 16-digit number that fails the Luhn checksum (`3214 3444 9999 1111`) is
also accepted, so neither the character type nor the checksum is validated.
