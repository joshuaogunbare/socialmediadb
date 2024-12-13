
# Social Media Database

This project demonstrates a social media database built with **PostgreSQL**. It manages users, photos, likes, and follows using SQL.

## Features

- **User Management**: Store user details.
- **Photo Management**: Track photos with metadata.
- **Likes**: Track which user likes which photo.
- **Follow System**: Automatically follow users when they like a photo (using a trigger).

## Technologies

- **PostgreSQL**
- **SQL**
- **DBeaver**

## Setup

1. Install **PostgreSQL** and **DBeaver**.
2. Run the provided SQL script to create tables and insert sample data.

## Example Queries

- View users:
  ```sql
  SELECT * FROM users;
