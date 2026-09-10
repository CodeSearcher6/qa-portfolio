# Bug Reports — forwoman.com.ua

> Published with the site owner's permission. Contact details and third-party
> profile links have been redacted.

Manual testing of a live landing page (registration funnel).
Six defects found, two of them blocking the primary conversion flow.

**Environment:** Chrome 151.0.7922.175 / macOS 26.5.2 / 1440×900 · iPhone, Safari
All desktop defects reproduced in both a signed-in profile and a guest profile
with extensions disabled.

| ID | Summary | Severity | Priority |
|---|---|---|---|
| FWM-01 | Decorative image overlaps the registration form and blocks input | Critical | Highest |
| FWM-02 | Second registration form accepts a non-existent phone number | Major | High |
| FWM-03 | Two registration forms on one page use different phone validation | Major | High |
| FWM-04 | Viber contact link opens an empty tab with no fallback | Medium | Medium |
| FWM-05 | Facebook link in the reviews block leads to unavailable content | Low | Medium |
| FWM-06 | Field icons misaligned relative to inputs on mobile | Minor | Low |

---

## FWM-01 — Decorative gift image overlaps the registration form and blocks input

**Severity:** Critical · **Priority:** Highest · **Component:** Registration form

### Summary
A decorative gift image is rendered above the registration form on desktop and
intercepts pointer events, making the Name and Phone fields impossible to fill in.

### Environment
- URL: https://forwoman.com.ua
- Chrome 151.0.7922.175 / macOS 26.5.2 / 1440×900
- Reproduced in a signed-in profile and in a guest profile with extensions disabled

### Preconditions
The site is open in a desktop browser.

### Steps to reproduce
1. Scroll to the registration form block.
2. Move the cursor over the Name or Phone field, in the area covered by the gift image.
3. Click the field and attempt to type.

### Expected result
The field receives focus and accepts input across its full area. A decorative
image does not intercept pointer events.

### Actual result
The field does not respond to clicks in the overlapped area. Input is impossible there.

### Impact
The registration form is the only conversion point on the landing page. Desktop
visitors cannot submit a request, which translates directly into lost leads.

### Notes
Not reproduced on mobile — the layout places the image differently there.

### Recommendation
Add `pointer-events: none` to the decorative image, or raise the form's `z-index`
above it.

---

## FWM-02 — Second registration form accepts a non-existent phone number

**Severity:** Major · **Priority:** High · **Component:** Registration form (lower)

### Summary
The phone field in the lower registration form accepts a value that matches no
real operator code and exceeds valid length, and the form submits successfully.

### Environment
- URL: https://forwoman.com.ua
- iPhone, Safari · also reproduced on Chrome 151 / macOS 26.5.2

### Steps to reproduce
1. Scroll to the lower registration form.
2. Enter `QATest` in the name field.
3. Enter `99999999999` in the phone field.
4. Submit the form.

### Expected result
The value is rejected with a validation message. Only valid Ukrainian mobile
numbers are accepted — 9 digits after the country code, with a real operator
code (39, 50, 63, 66, 67, 68, 73, 91–99).

### Actual result
The value passes validation, the form is submitted and a confirmation is shown.
The submitted value has 11 digits and no valid operator code.

### Impact
Leads with unreachable phone numbers enter the database. The entire funnel depends
on calling the applicant back within 1–2 days, so each such entry is a lost contact
and wasted follow-up time.

### Notes
A valid number (`991234567`) is accepted correctly, so the field works on valid
input. The defect is the absence of format and operator-code validation. See
FWM-03 — a correct implementation already exists elsewhere on the same page.

### Recommendation
Apply Tilda's built-in Phone field type with a country mask, as already configured
in the upper form.

---

## FWM-03 — Two registration forms on one page use different phone validation

**Severity:** Major · **Priority:** High · **Component:** Registration forms

### Summary
The page contains two registration forms with inconsistent phone field
implementations: one validated, one not.

### Steps to reproduce
1. Click the "Хочу тест драйв" button at the top of the page.
2. Inspect the phone field in the form that opens.
3. Scroll to the second registration form lower on the page.
4. Inspect its phone field.

### Expected result
Both forms apply the same validation rules to the same type of data.

### Actual result
**Upper form:** country selector, `+380` prefix, input mask that groups digits,
and a hard limit on digit count matching a valid number.
**Lower form:** a plain text input with no mask, no country code and no length
limit — it accepts `9999999`.

### Impact
Data quality depends on which form the visitor happens to use. Submissions from
the lower form are unusable for follow-up.

### Recommendation
Copy the field configuration from the upper form to the lower one. The correct
implementation already exists on the same page, so no new development is needed.

---

## FWM-04 — Viber contact link opens an empty tab with no fallback

**Severity:** Medium · **Priority:** Medium · **Component:** Contacts block

### Summary
The Viber contact link uses a native app scheme with `target="_blank"`. On desktop
without Viber installed, it opens a blank tab and provides no alternative.

### Steps to reproduce
1. Scroll to the contacts block in the footer.
2. Click the Viber icon.

### Expected result
The link opens Viber if installed, or the user is given a usable fallback. No
empty tab is left behind.

### Actual result
A blank tab opens and remains. Console output:
`Failed to launch 'viber://chat?number=380XXXXXXXXX' because the scheme does not have a registered handler.`

### Notes
The Telegram link in the same block uses a standard `https://t.me/...` URL and
works correctly. The Viber link is the only one relying on a native app scheme.
Markup: `<a href="viber://chat?number=380XXXXXXXXX" target="_blank">`.

Reproduced with and without extensions, in signed-in and guest profiles.

### Recommendation
Replace the `viber://` scheme with a web-compatible link, or remove
`target="_blank"` and display the phone number as text alongside the icons.

---

## FWM-05 — Facebook link in the reviews block leads to unavailable content

**Severity:** Low · **Priority:** Medium · **Component:** Reviews block

### Steps to reproduce
1. Scroll to the reviews block.
2. Click the Facebook link in a testimonial (a personal profile URL).

### Expected result
The linked review opens and is publicly visible.

### Actual result
Facebook shows a content-unavailable message — the post has been deleted or
its audience restricted.

### Impact
Reviews serve as social proof. A broken link to a testimonial undermines it.

### Recommendation
Update the link to a currently public post, or remove it.

---

## FWM-06 — Field icons misaligned relative to inputs on mobile

**Severity:** Minor · **Priority:** Low · **Component:** Registration form, mobile layout

### Steps to reproduce
1. Open the site on a mobile device.
2. Scroll to the registration form.

### Expected result
Each icon is vertically aligned with its corresponding input field.

### Actual result
Icons sit above their fields rather than beside them.

### Impact
Cosmetic. Does not block submission, but mobile is the primary audience for this
landing page.

---

## Accessibility observation (not filed as a defect)

The contact links carry `aria-label=""` with `role="img"`. A screen reader
announces them as unnamed images, so a user relying on assistive technology
cannot tell what the links do. Filling in `aria-label` with a meaningful value
would resolve this.

## Open question for the client

Two test submissions were sent under the name `QATest`. Confirmation that they
reached the client's inbox is still pending. If a form shows a success message
but the lead never arrives, that is the most expensive possible defect and is
invisible from the outside — this check cannot be completed without the client.
