-- Test database for SQL practice (SQLite)
-- Run: sqlite3 practice.db < schema.sql

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id         INTEGER PRIMARY KEY,
    name       TEXT NOT NULL,
    country    TEXT,
    age        INTEGER,
    created_at DATE
);

CREATE TABLE orders (
    id      INTEGER PRIMARY KEY,
    user_id INTEGER,
    amount  INTEGER,
    status  TEXT,   -- paid / pending / canceled
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (id, name, country, age, created_at) VALUES
    (1, 'Andrii', 'UA', 25, '2024-01-10'),
    (2, 'Olena',  'UA', 31, '2024-03-05'),
    (3, 'Marek',  'PL', 19, '2024-03-05'),
    (4, 'Sofia',  'UA', 42, '2023-11-20'),
    (5, 'Tomas',  'PL', 25, '2024-05-01');

INSERT INTO orders (id, user_id, amount, status) VALUES
    (1, 1, 500, 'paid'),
    (2, 1, 300, 'canceled'),
    (3, 3, 700, 'paid'),
    (4, 5, 200, 'pending');

-- Note: Olena (id=2) and Sofia (id=4) have no orders.
-- This is intentional - it makes the difference between
-- JOIN and LEFT JOIN visible in the results.
