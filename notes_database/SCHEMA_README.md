# Secure Notes App Database Schema

This document explains the MySQL schema for the secure-notes-organizer database container.  
The schema supports user authentication, note storage with tags, and follows best practices for security.

## Tables

- **users:** Stores user registration info.  
  - Passwords MUST use bcrypt or argon2 hash (lengthy string in password_hash).
- **notes:** Each note belongs to a user. Contains title, content, timestamps.
- **tags:** A tag vocabulary (unique names).
- **note_tags:** Associative table (many-to-many) for connecting notes and tags.

## Usage

1. Run the schema initialization script on your MySQL server (matching the app's connection settings):

    ```sh
    mysql -u appuser -pdbuser123 -h localhost -P 5000 myapp < init_schema.sql
    ```

2. All user passwords **must be hashed** with bcrypt (recommended: 12 rounds/mincost).  
   Store the hash in `users.password_hash`. Never use plain text here!

   *Backend developers*: Use bcrypt for Node.js/Express (or any backend language).

3. Demo/test data (optional) are provided as comments in `init_schema.sql`.

## Security

- User passwords are not stored in plaintext.
- Use parameterized queries to avoid SQL injection.
- FK constraints enforce referential integrity and allow cascading deletes.

## Relations

- `users (1) -- (*) notes`
- `notes (*) -- (*) tags` via `note_tags`

## Maintenance

- Update schema with `init_schema.sql` if structure changes.
- Update this README for any schema revisions.

---
