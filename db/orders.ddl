/* Database Schema (PostgreSQL) */

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS users;

-- origin Orders::Entities::Order
CREATE TABLE orders (
  id uuid PRIMARY KEY,
  customer_id uuid REFERENCES customers(id),
  created_at timestamp with time zone,
  total money,
  articles jsonb array
);

-- origin Orders::Entities::Article
CREATE TABLE articles (
  id uuid PRIMARY KEY,
  title text,
  price money
);

-- origin Orders::Entities::User
CREATE TABLE users (
  id uuid PRIMARY KEY,
  name text
);
