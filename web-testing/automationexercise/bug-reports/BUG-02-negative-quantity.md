# BUG-02 — Negative quantity produces a negative line total

| | |
|---|---|
| **ID** | BUG-02 |
| **Severity** | Critical |
| **Priority** | High |
| **Status** | Open |
| **Component** | Cart / Product page |
| **Reported by** | Vladyslav Suprun |
| **Date** | 2026-08-20 |

## Summary

The quantity field on the product page accepts negative numbers. The product is added
to the cart with a negative quantity, and its line total becomes negative, subtracting
from the order total instead of adding to it.

## Environment

- **URL:** https://automationexercise.com
- **Browser:** Chrome 151.0.7922.175
- **OS:** macOS 26.5.2
- **Resolution:** 1440×900
- **Account:** registered test user

## Preconditions

1. The user is registered and logged in.

## Steps to reproduce

1. Open the product page for **Winter Top**.
2. Set the quantity field to `-1`.
3. Click **Add to cart**.
4. Open the cart.

## Expected result

The quantity field rejects negative values. The minimum accepted quantity is `1`, and
a validation message is shown. No cart line with a negative quantity or a negative
line total is ever created.

## Actual result

The value is accepted without a validation message and the "Added!" confirmation is displayed. 
The cart contains a line with quantity -1. The unit price is shown correctly (Rs. 600), but the line total is negative (Rs. -600), 
and the cart total is reduced by that amount. With two products in the cart (Rs. 600 at quantity 1 
and Rs. 600 at quantity -1), the cart total is Rs. 0.

## Impact

A cart line with a negative total subtracts from the order sum instead of adding to
it. By combining an expensive product at quantity `1` with another product at a
negative quantity, a user can reduce the order total, bring it to zero, or make it
negative — and then place that order. This is a direct financial vulnerability, not a
display defect.

## Attachments

- `screenshots/bug-02-cart-negative-total.png`

## Related

- **BUG-01** — invalid card number is accepted. Together the two defects allow an
  order to be completed for a reduced total with no valid payment.
- **BUG-03** — quantities are summed across additions with no upper bound
  (`0`, `-1` and `9999999999` produce a single line of `9999999998`).
- **BUG-04** — quantity `0` is accepted on some products but not on others; the
  affected products have not been isolated yet.
  
