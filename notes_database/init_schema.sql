-- MySQL schema for 'Secure Notes' application
-- Supports: Users (with securely hashed passwords), Notes, Tags, Note-Tag association
-- Designed for compatibility with MySQL 8+

-- Enable InnoDB for FK support.
SET default_storage_engine = 'InnoDB';

-- --- USERS TABLE --- 
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --- NOTES TABLE ---
CREATE TABLE IF NOT EXISTS notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200),
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- FK to users
    CONSTRAINT fk_note_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- --- TAGS TABLE ---
CREATE TABLE IF NOT EXISTS tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- --- NOTE_TAGS (JOIN) TABLE ---
CREATE TABLE IF NOT EXISTS note_tags (
    note_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (note_id, tag_id),
    CONSTRAINT fk_nt_note
        FOREIGN KEY (note_id)
        REFERENCES notes(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_nt_tag
        FOREIGN KEY (tag_id)
        REFERENCES tags(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- --- SECURE PASSWORD STORAGE FOR USERS ---
-- Passwords should be hashed before insertion using bcrypt or argon2.
-- DO NOT store plain text or unsalted hashes.
-- Example for inserting a user with a bcrypt hash (replace 'HASHED_PASSWORD' by backend bcrypt result):
-- INSERT INTO users (email, username, password_hash) VALUES ('test@example.com', 'testuser', '$2b$12$HASHED_PASSWORD');

-- --- OPTIONAL: DEMO DATA (REMOVE for production) ---
-- INSERT INTO users (email, username, password_hash) VALUES ('demo@notes.com', 'demo', '$2b$12$EXAMPLEHASHSTRINGTOREPLACE');
-- INSERT INTO tags (name) VALUES ('work'), ('personal'), ('important');

-- --- INDEXES FOR PERFORMANCE ---
CREATE INDEX IF NOT EXISTS idx_notes_user_id ON notes(user_id);
CREATE INDEX IF NOT EXISTS idx_note_tags_tag_id ON note_tags(tag_id);

-- --- END OF SCHEMA ---
