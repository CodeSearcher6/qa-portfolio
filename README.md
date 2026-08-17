# QA Portfolio — Vladyslav Suprun

Junior QA Engineer (Manual) with a Computer Engineering background (BSc, 2026).
I learn by building: I write C# for .NET and Unity, work with REST APIs, SQL and Git,
and I completed a Software Testing Fundamentals course (Lviv IT School / Prometheus).

This repository collects my hands-on QA work: real bug reports, SQL practice, and
testing documentation.

---

## 📋 Bug Reports

| Report | Product | Type | Highlight |
|---|---|---|---|
| [Ubisoft Account Recovery — Steam verification 404](SCRUM-6_AccountRecovery_Case/SCRUM-6_AccountRecovery.md) | Ubisoft (account recovery) | Server-side defect | Found, isolated across 8+ environments, and reported a real defect in Ubisoft's account-recovery flow. The report was accepted and escalated to a specialized team (Case No. 26429656). |

Each report follows a standard structure: Summary, Preconditions, Steps to Reproduce,
Expected vs Actual Result, Environment, Severity/Priority, and Attachments.

---

## 🗄 SQL

| File | What's inside |
|---|---|
| [sql/queries.md](sql/queries.md) | 27 documented queries — filtering, aggregate functions, `GROUP BY` / `HAVING`, `INNER JOIN` and `LEFT JOIN`, duplicate search |
| [sql/schema.sql](sql/schema.sql) | Test database (SQLite) — run it to reproduce every query yourself |

Written from a tester's point of view: each query has a note on what can silently go
wrong there. Most SQL mistakes do not raise an error — a missing `WHERE`, `AND`
instead of `OR`, or `COUNT(*)` instead of `COUNT(column)` all return a plausible
number that is simply not the correct one. That is why reading SQL matters in manual
testing: it shows what the application actually stored, not what the UI displays.

---

## 🧰 Skills demonstrated here

- Writing clear, reproducible **bug reports** (standard defect-report structure)
- **Defect isolation** — reproducing across browsers, devices and OS to confirm a
  server-side vs client-side cause
- **Root-cause analysis** — identifying *why* a defect occurs, not just the symptom
- **SQL** — verifying data directly in the database, checking for duplicates and
  incorrect records
- Working with **Jira** (bug tracking) and defect life cycle
- Testing theory: test types, test design techniques (equivalence partitioning,
  boundary value analysis, state transition), SDLC / STLC

---

## 🎓 Background

- **Testing:** Software Testing Fundamentals — Lviv IT School (Prometheus), certified
- **Cloud:** AWS Academy Cloud Foundations — EC2, VPC, IAM, CloudWatch
- **Technical:** C#, .NET, SQL / SQLite, REST APIs, Git, Linux, Postman (basics)
- **Projects:** see my other repositories (Unity game, WPF desktop app, Discord bot,
  .NET console app with REST API + SQLite)

---

## 📫 Contact

- LinkedIn: [vladyslav-suprun](https://www.linkedin.com/in/vladyslav-suprun-3a4a4b341/)
- Email: zasiadko1774@gmail.com

*Open to Junior QA / Manual QA / Trainee QA roles.*
