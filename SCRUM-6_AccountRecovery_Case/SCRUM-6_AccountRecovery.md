# SCRUM-6: Account recovery Steam verification link fails with HTTP 404

| | |
|---|---|
| **Defect ID** | SCRUM-6 |
| **Status** | In Progress |
| **Severity** | High |
| **Priority** | High |
| **Reporter** | CodeSearcher6 |
| **Labels** | `404`, `account-recovery`, `redirect` |
| **Reference / Case No.** | 26429656 — *accepted and escalated to a specialized team* |

---

## 📝 Summary

The account-recovery verification link fails with **HTTP ERROR 404** because an
internal redirect corrupts the URL path from `steam-external` to
`steam-external-external` (the `external` segment is duplicated), pointing to a page
that does not exist. This blocks the only remaining ownership-verification method for
users who have lost access to their linked email.

---

## ⚙️ Preconditions

- User has a Ubisoft account linked to a Steam account.
- User has lost access to the email address linked to the Ubisoft account.
- Account Recovery has been started, and Steam verification is offered as an
  alternative method.

---

## 🔄 Steps to Reproduce

1. Begin the Ubisoft Account Recovery process for an account with an inaccessible email.
2. Request ownership verification via the linked Steam platform.
3. Open the automated verification email received from Ubisoft Support.
4. Confirm the link in the email is correct (`...&platform=steam-external`).
5. Click **"Verify with Steam"**.
6. Observe the browser address bar after the redirect.

---

## ✅ Expected Result

The Steam ownership-verification screen opens, allowing the user to confirm ownership
of the linked Steam account and continue the recovery process.

---

## ❌ Actual Result

Ubisoft's server redirects to a corrupted URL, duplicating the `external` segment:

- **Correct link (before redirect):** `...&platform=steam-external`
- **Broken URL (after redirect):** `.../steam-external-external?...`

No page exists at that address. The browser returns **HTTP ERROR 404**, and the Steam
verification screen is never reached.

---

## 🌍 Environment

Reproduced with an **identical result (HTTP 404)** across all of the following,
confirming a **server-side defect** independent of client, device, or configuration:

| Category | Details |
|---|---|
| **Desktop browsers** | Chrome (normal / Incognito / Guest), Edge, OperaGX |
| **In-app browser** | Steam built-in browser (fails with `Error -379`) |
| **Mobile** | iPhone (iOS), Android |
| **Machines** | Two separate laptops |
| **Conditions** | Extensions off, no VPN/proxy, cache & cookies cleared |
| **Locales** | English (en-US) and Ukrainian (uk-UA) |

---

## 📊 Impact & Justification

- **Severity: High** — a core recovery path is completely non-functional; for affected
  users it removes the only self-service way to regain full account control.
- **Priority: High** — directly affects account access and security, with no automated
  fallback available to support.

---

## 🔍 Root Cause (observed)

The defect is in Ubisoft's **redirect logic**: the `external` token is concatenated
twice when building the `connect.ubisoft.com/steam-external...` target. The link
provided in the email is valid until the server-side redirect rewrites it.

---

## 📎 Attachments

| # | Description |
|---|---|
| 1 | Correct link in address bar (`steam-external`) — before redirect |
| 2 | Resulting 404 page (`steam-external-external`) — after redirect |
| 3 | 404 reproduced in Chrome (English locale) |
| 4 | 404 reproduced in Chrome Guest mode (clean session) |
| 5 | 404 reproduced on a second laptop |
| 6 | Steam built-in browser failure (Error -379) |

*(Screenshots stored in `/screenshots`.)*

---

*This is a real defect I found, isolated, and reported. Ubisoft Support accepted the
report and escalated the case (26429656) to a specialized team for investigation.*
