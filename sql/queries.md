# SQL for Manual QA — 27 practice queries

A small SQL practice set I built while preparing for QA interviews.
Focus: reading and writing the kind of queries a manual tester actually
needs — checking data after a test, finding duplicates, and verifying
that a report shows the right numbers.

All queries were executed against SQLite and the results below are real
output, not written from memory.

**How to reproduce:**

```bash
sqlite3 practice.db < schema.sql
```

---

## Test data

```
users
id | name    | country | age | created_at
1  | Andrii  | UA      | 25  | 2024-01-10
2  | Olena   | UA      | 31  | 2024-03-05
3  | Marek   | PL      | 19  | 2024-03-05
4  | Sofia   | UA      | 42  | 2023-11-20
5  | Tomas   | PL      | 25  | 2024-05-01

orders
id | user_id | amount | status
1  | 1       | 500    | paid
2  | 1       | 300    | canceled
3  | 3       | 700    | paid
4  | 5       | 200    | pending
```

Olena and Sofia have no orders. That is intentional: it makes the
difference between `JOIN` and `LEFT JOIN` visible in the output.

---

## 1. Basics: SELECT / WHERE / ORDER BY

**1. All users, all columns**

```sql
SELECT * FROM users;
```

**2. Name and country of users older than 30**

```sql
SELECT name, country
FROM users
WHERE age > 30;
```

> Returns Olena (31) and Sofia (42). Note `>` excludes 30 itself.
> This is boundary value analysis in practice: if the requirement says
> "older than 30", then 30 must not appear in the result. A `>=` here
> would be a real bug.

**3. Users from Poland, sorted by name**

```sql
SELECT name
FROM users
WHERE country = 'PL'
ORDER BY name;
```

> Text values go in single quotes, numbers do not.

**4. Users who are exactly 25**

```sql
SELECT name FROM users WHERE age = 25;
```

**5. Users not from Ukraine**

```sql
SELECT * FROM users WHERE country <> 'UA';
```

> `<>` means "not equal". `!=` works in most databases too.

**6. Users from Ukraine under 40, oldest first**

```sql
SELECT name, age
FROM users
WHERE country = 'UA' AND age < 40
ORDER BY age DESC;
```

> Two conditions are joined with `AND`, not a comma.
> `DESC` = descending, `ASC` = ascending (default).

**7. Users from Poland OR older than 40**

```sql
SELECT *
FROM users
WHERE country = 'PL' OR age > 40;
```

> Returns Marek, Sofia, Tomas.
> `AND` narrows the result, `OR` widens it. Using `AND` here would
> return zero rows — a mistake that is easy to miss because the query
> still runs without any error.

**8. Users aged 20 to 30 (inclusive)**

```sql
SELECT *
FROM users
WHERE age >= 20 AND age <= 30;

-- same result, shorter:
SELECT * FROM users WHERE age BETWEEN 20 AND 30;
```

> `BETWEEN` includes both borders.

**9. All users sorted by country, then by age**

```sql
SELECT *
FROM users
ORDER BY country, age;
```

> `ORDER BY` is written once; the column order sets the sorting priority.

---

## 2. Aggregate functions

**10. Total number of users**

```sql
SELECT COUNT(*) FROM users;
```

**11. Number of users from Ukraine**

```sql
SELECT COUNT(*) FROM users WHERE country = 'UA';   -- 3
```

**12. Age of the oldest user**

```sql
SELECT MAX(age) FROM users;   -- 42
```

**13. Average age of Polish users**

```sql
SELECT AVG(age) FROM users WHERE country = 'PL';   -- 22.0
```

> Without the `WHERE` this returns 28.4 — the average of everyone.
> Still a valid query, just the wrong answer.

**14. How many different countries**

```sql
SELECT COUNT(DISTINCT country) FROM users;   -- 2
```

**15. Age of the youngest Ukrainian user**

```sql
SELECT MIN(age) FROM users WHERE country = 'UA';   -- 25
```

### `COUNT(*)` vs `COUNT(column)` — a QA trap

`COUNT(*)` counts rows. `COUNT(column)` counts only rows where that
column is **not NULL**.

If one user has an empty email, `COUNT(*)` returns 5 while
`COUNT(email)` returns 4. If a report is built on the wrong one, the
numbers silently drift apart — no error message, just wrong data.

---

## 3. GROUP BY and HAVING

**16. Average age per country**

```sql
SELECT country, AVG(age)
FROM users
GROUP BY country;
```

```
PL | 22.0
UA | 32.67
```

> Rule: whatever is in `GROUP BY` should also be in `SELECT`.
> Without `country` in `SELECT` you get bare numbers and no way to tell
> which country they belong to.

**17. Number of users registered per date**

```sql
SELECT created_at, COUNT(*)
FROM users
GROUP BY created_at;
```

> `SELECT *` cannot be used with `GROUP BY`: several rows collapse into
> one, so the database has no single value to show for the other columns.

**18. Oldest user per country**

```sql
SELECT country, MAX(age)
FROM users
GROUP BY country;
```

```
PL | 25
UA | 42
```

**19. Countries with more than 2 users**

```sql
SELECT country, COUNT(*)
FROM users
GROUP BY country
HAVING COUNT(*) > 2;      -- UA | 3
```

**20. Dates with more than one registration (duplicate pattern)**

```sql
SELECT created_at, COUNT(*)
FROM users
GROUP BY created_at
HAVING COUNT(*) > 1;      -- 2024-03-05 | 2
```

> This is the standard way to find duplicates: group by the column that
> should be unique, then keep the groups with more than one row. Same
> query shape works for duplicate emails, double-submitted orders, or
> records doubled by a broken import.

**21. Countries where the average age is above 25**

```sql
SELECT country, AVG(age)
FROM users
GROUP BY country
HAVING AVG(age) > 25;     -- UA | 32.67
```

> A function can be used in `HAVING` even if it is not in `SELECT`.

### `WHERE` vs `HAVING`

| | filters | can use `COUNT()` / `SUM()` |
|---|---|---|
| `WHERE` | individual rows, **before** grouping | no |
| `HAVING` | groups, **after** grouping | yes |

---

## 4. JOIN

**22. User name and order amount (only users who ordered)**

```sql
SELECT u.name, o.amount
FROM users u
JOIN orders o ON u.id = o.user_id;
```

```
Andrii | 500
Andrii | 300
Marek  | 700
Tomas  | 200
```

> `INNER JOIN` keeps only matching rows, so Olena and Sofia disappear.
> `users u` is an alias — from that point the table is referenced as `u`.

**23. Same, but keep every user**

```sql
SELECT u.name, o.amount
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;
```

> Olena and Sofia stay in the result with `NULL` in the amount column.
> `JOIN` = only rows that have a match. `LEFT JOIN` = every row from the
> left table, plus the match if it exists.

**24. Paid orders only**

```sql
SELECT u.name, o.amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'paid';
```

```
Andrii | 500
Marek  | 700
```

**25. Users with no orders at all**

```sql
SELECT u.name
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL;
```

```
Olena
Sofia
```

> The classic "find the rows without a match" pattern:
> `LEFT JOIN` + `IS NULL` on the right table.
> `IS NULL` — never `= NULL`. Comparison with NULL using `=` never
> returns true.

**26. Order count per user, including users with zero**

```sql
SELECT u.name, COUNT(o.id)
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.name;
```

```
Andrii | 2
Marek  | 1
Olena  | 0
Sofia  | 0
Tomas  | 1
```

> `COUNT(o.id)` and not `COUNT(*)`. After a `LEFT JOIN`, Olena still has
> one row, but every column from `orders` is NULL in it. `COUNT(*)` would
> count that row and report 1 order for a user who has none.
> `COUNT(o.id)` skips NULLs and correctly returns 0.

**27. Total paid amount per user, highest first**

```sql
SELECT u.name, SUM(o.amount)
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'paid'
GROUP BY u.name
ORDER BY SUM(o.amount) DESC;
```

```
Marek  | 700
Andrii | 500
```

---

## Clause order (fixed, cannot be changed)

```
SELECT → FROM → JOIN → WHERE → GROUP BY → HAVING → ORDER BY
```

---

## Why this matters for testing

Most SQL mistakes do not produce an error message. The query runs and
returns a number — just not the right one. A missing `WHERE`, `AND`
instead of `OR`, `COUNT(*)` instead of `COUNT(column)`: each of these
returns plausible-looking data that is quietly wrong.

That is exactly why a manual tester needs to read SQL — to check what
the application actually wrote to the database, instead of trusting what
the UI displays.
