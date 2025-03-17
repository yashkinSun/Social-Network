-- 00_create_tables.sql
PRAGMA foreign_keys = ON;

------------------------------------------------------------------------
-- 1. Удаляем таблицы (если уже существуют), начиная с зависимых
------------------------------------------------------------------------
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS friends;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

------------------------------------------------------------------------
-- 2. Создаём таблицу users
--   id, username, email, password, avatar, bio, created_at, updated_at
------------------------------------------------------------------------
CREATE TABLE users (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    username    TEXT    NOT NULL UNIQUE,
    email       TEXT    NOT NULL UNIQUE,
    password    TEXT    NOT NULL,
    avatar      TEXT,
    bio         TEXT,
    created_at  TEXT    DEFAULT (datetime('now')),
    updated_at  TEXT
);

------------------------------------------------------------------------
-- 3. Создаём таблицу posts
--   id, user_id (FK -> users), title, content, media_url, created_at, updated_at
------------------------------------------------------------------------
CREATE TABLE posts (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER NOT NULL,
    title       TEXT    NOT NULL,
    content     TEXT,
    media_url   TEXT,
    created_at  TEXT    DEFAULT (datetime('now')),
    updated_at  TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

------------------------------------------------------------------------
-- 4. Создаём таблицу comments
--   id, post_id (FK), user_id (FK), content, created_at, parent_id (FK), ...
------------------------------------------------------------------------
CREATE TABLE comments (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id     INTEGER NOT NULL,
    user_id     INTEGER NOT NULL,
    content     TEXT    NOT NULL,
    created_at  TEXT    DEFAULT (datetime('now')),
    parent_id   INTEGER,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES comments(id) ON DELETE CASCADE
);

------------------------------------------------------------------------
-- 5. Создаём таблицу likes
--   id, post_id (FK), user_id (FK), created_at
------------------------------------------------------------------------
CREATE TABLE likes (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id     INTEGER NOT NULL,
    user_id     INTEGER NOT NULL,
    created_at  TEXT    DEFAULT (datetime('now')),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

------------------------------------------------------------------------
-- 6. Создаём таблицу friends
--   id, user_id (FK), friend_id (FK), status, created_at
------------------------------------------------------------------------
CREATE TABLE friends (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER NOT NULL,
    friend_id   INTEGER NOT NULL,
    status      TEXT    DEFAULT 'pending',
    created_at  TEXT    DEFAULT (datetime('now')),
    FOREIGN KEY (user_id)   REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE
);

------------------------------------------------------------------------
-- 7. Создаём таблицу messages
--   id, sender_id (FK), receiver_id (FK), content, created_at, read_status
------------------------------------------------------------------------
CREATE TABLE messages (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    sender_id   INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    content     TEXT    NOT NULL,
    created_at  TEXT    DEFAULT (datetime('now')),
    read_status INTEGER DEFAULT 0,
    FOREIGN KEY (sender_id)   REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
);

------------------------------------------------------------------------
-- 8. Создаём таблицу notifications
--   id, user_id (FK), type, content, link, is_read, created_at
------------------------------------------------------------------------
CREATE TABLE notifications (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER NOT NULL,
    type        TEXT    NOT NULL,
    content     TEXT,
    link        TEXT,
    is_read     INTEGER DEFAULT 0,
    created_at  TEXT    DEFAULT (datetime('now')),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
