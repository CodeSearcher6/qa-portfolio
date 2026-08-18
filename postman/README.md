# REST API Testing — Postman

Manual API testing of a public REST API (JSONPlaceholder), covering the full CRUD
cycle plus negative scenarios and response-time checks.

**Files:** [`QA_Practice.postman_collection.json`](QA_Practice.postman_collection.json) —
import into Postman (Import → File) and run the whole collection with the Collection Runner.

---

## Positive scenarios

| # | Request | Checks |
|---|---|---|
| 1 | `GET /posts` | Every post has `id`, `userId`, `title`, `body`; correct data types; no empty strings |
| 2 | `GET /posts?userId=999` | `200 OK`, response is an array, array is empty |
| 3 | `POST /posts` | `201 Created`, response is JSON, server assigns a numeric `id`, submitted data is returned |
| 4 | `PUT /posts/1` | `200 OK`, all fields replaced with the new values |

---

## Negative scenarios

| # | Request | Expected | Actual |
|---|---|---|---|
| 5 | `GET /posts/9999` — non-existent id | `404` | `404` ✅ |
| 6 | `GET /posts/abc` — id of the wrong type | `404` | `404` ✅ |
| 7 | `POST /posts` — empty `body` field | `400` | `201` ⚠️ |
| 8 | `POST /posts` — `userId` as a string | `400` | `201` ⚠️ |
| 9 | `DELETE /posts/99999` — non-existent post | `404` | `200` ⚠️ |

Every request also asserts a response time under 1000 ms.

---

## Known limitations of the test environment

JSONPlaceholder is a mock API. It does not validate incoming data and does not
persist changes: `POST` returns a new `id`, but a follow-up `GET` will not find the
record. `PUT`, `PATCH` and `DELETE` behave the same way — the response is simulated.

This is why cases 7–9 are marked ⚠️. On a production API each of them would be a
validation defect worth reporting:

- accepting a required field as an empty string instead of returning `400 Bad Request`
- accepting a string where a numeric `userId` is expected — no type validation
- returning `200 OK` when deleting a record that does not exist, instead of `404 Not Found`

The tests for these cases are deliberately written against the **actual** behaviour and
labelled `KNOWN ISSUE`, so the collection stays green while the discrepancy remains
documented rather than hidden.

---

## Skills demonstrated

- Full CRUD coverage: `GET`, `POST`, `PUT`, `DELETE`
- Negative testing: non-existent ids, wrong data types, empty required fields
- Status code and JSON schema validation
- Response body assertions with `pm.expect()`
- Basic non-functional check — response time
- Distinguishing an environment limitation from a product defect
