-- =========================================
-- CREATE DATABASE
-- =========================================
CREATE DATABASE IF NOT EXISTS fb_demo;
USE fb_demo;

-- =========================================
-- 1. USERS
-- =========================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255) DEFAULT NULL,
    cover_image VARCHAR(255) DEFAULT NULL,
    bio TEXT DEFAULT NULL,
    gender ENUM('male', 'female', 'other') DEFAULT 'other',
    date_of_birth DATE DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- 2. POSTS
-- =========================================
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    privacy ENUM('public', 'friends', 'private') DEFAULT 'public',
    feeling VARCHAR(100) DEFAULT NULL,
    location VARCHAR(255) DEFAULT NULL,
    post_type ENUM('text', 'image', 'video', 'shared') DEFAULT 'text',
    original_post_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_posts_original_post
        FOREIGN KEY (original_post_id) REFERENCES posts(id)
        ON DELETE SET NULL
);

-- =========================================
-- 3. POST IMAGES
-- =========================================
CREATE TABLE post_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_post_images_post
        FOREIGN KEY (post_id) REFERENCES posts(id)
        ON DELETE CASCADE
);

-- =========================================
-- 4. LIKES
-- =========================================
CREATE TABLE likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    reaction_type ENUM('like', 'love', 'care', 'haha', 'wow', 'sad', 'angry') DEFAULT 'like',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_likes_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_likes_post
        FOREIGN KEY (post_id) REFERENCES posts(id)
        ON DELETE CASCADE,
    CONSTRAINT uq_user_post_like UNIQUE (user_id, post_id)
);

-- =========================================
-- 5. COMMENTS
-- =========================================
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    parent_comment_id INT DEFAULT NULL,
    comment_text TEXT NOT NULL,
    image_url VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id) REFERENCES posts(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_comments_parent
        FOREIGN KEY (parent_comment_id) REFERENCES comments(id)
        ON DELETE CASCADE
);

-- =========================================
-- 6. SHARES
-- =========================================
CREATE TABLE shares (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    share_text TEXT DEFAULT NULL,
    privacy ENUM('public', 'friends', 'private') DEFAULT 'public',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_shares_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_shares_post
        FOREIGN KEY (post_id) REFERENCES posts(id)
        ON DELETE CASCADE
);

-- =========================================
-- 7. FRIENDSHIPS
-- =========================================
CREATE TABLE friendships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    requester_id INT NOT NULL,
    addressee_id INT NOT NULL,
    status ENUM('pending', 'accepted', 'rejected', 'blocked') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_friendships_requester
        FOREIGN KEY (requester_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_friendships_addressee
        FOREIGN KEY (addressee_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT uq_friendship UNIQUE (requester_id, addressee_id)
);

-- =========================================
-- 8. FOLLOWERS
-- For follow system like page/person follow
-- =========================================
CREATE TABLE followers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_followers_follower
        FOREIGN KEY (follower_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_followers_following
        FOREIGN KEY (following_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT uq_follow UNIQUE (follower_id, following_id)
);

-- =========================================
-- 9. STORIES
-- =========================================
CREATE TABLE stories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    media_url VARCHAR(255) NOT NULL,
    media_type ENUM('image', 'video') DEFAULT 'image',
    caption VARCHAR(255) DEFAULT NULL,
    expires_at DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_stories_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================
-- 10. STORY VIEWS
-- =========================================
CREATE TABLE story_views (
    id INT AUTO_INCREMENT PRIMARY KEY,
    story_id INT NOT NULL,
    viewer_id INT NOT NULL,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_story_views_story
        FOREIGN KEY (story_id) REFERENCES stories(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_story_views_viewer
        FOREIGN KEY (viewer_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT uq_story_view UNIQUE (story_id, viewer_id)
);

-- =========================================
-- 11. CONVERSATIONS
-- =========================================
CREATE TABLE conversations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_type ENUM('private', 'group') DEFAULT 'private',
    title VARCHAR(150) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- 12. CONVERSATION MEMBERS
-- =========================================
CREATE TABLE conversation_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_id INT NOT NULL,
    user_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_conversation_members_conversation
        FOREIGN KEY (conversation_id) REFERENCES conversations(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_conversation_members_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT uq_conversation_member UNIQUE (conversation_id, user_id)
);

-- =========================================
-- 13. MESSAGES
-- =========================================
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_id INT NOT NULL,
    sender_id INT NOT NULL,
    message_text TEXT DEFAULT NULL,
    media_url VARCHAR(255) DEFAULT NULL,
    is_seen TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_messages_conversation
        FOREIGN KEY (conversation_id) REFERENCES conversations(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_messages_sender
        FOREIGN KEY (sender_id) REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================
-- 14. PAGES
-- =========================================
CREATE TABLE pages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    page_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) DEFAULT NULL,
    description TEXT DEFAULT NULL,
    profile_image VARCHAR(255) DEFAULT NULL,
    cover_image VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pages_owner
        FOREIGN KEY (owner_id) REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================
-- 15. PAGE FOLLOWERS
-- =========================================
CREATE TABLE page_followers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    page_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_page_followers_page
        FOREIGN KEY (page_id) REFERENCES pages(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_page_followers_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT uq_page_follower UNIQUE (page_id, user_id)
);

-- =========================================
-- 16. GROUPS
-- =========================================
CREATE TABLE groups (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    group_name VARCHAR(150) NOT NULL,
    description TEXT DEFAULT NULL,
    privacy ENUM('public', 'private') DEFAULT 'public',
    cover_image VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_groups_owner
        FOREIGN KEY (owner_id) REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================================
-- 17. GROUP MEMBERS
-- =========================================
CREATE TABLE group_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    user_id INT NOT NULL,
    role ENUM('member', 'moderator', 'admin') DEFAULT 'member',
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'approved',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_group_members_group
        FOREIGN KEY (group_id) REFERENCES groups(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_group_members_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT uq_group_member UNIQUE (group_id, user_id)
);

-- =========================================
-- 18. NOTIFICATIONS
-- =========================================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    actor_id INT NOT NULL,
    type ENUM(
        'like',
        'comment',
        'share',
        'friend_request',
        'friend_accept',
        'follow',
        'message',
        'page_follow',
        'group_invite'
    ) NOT NULL,
    post_id INT DEFAULT NULL,
    comment_id INT DEFAULT NULL,
    story_id INT DEFAULT NULL,
    conversation_id INT DEFAULT NULL,
    is_read TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notifications_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notifications_actor
        FOREIGN KEY (actor_id) REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notifications_post
        FOREIGN KEY (post_id) REFERENCES posts(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notifications_comment
        FOREIGN KEY (comment_id) REFERENCES comments(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notifications_story
        FOREIGN KEY (story_id) REFERENCES stories(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notifications_conversation
        FOREIGN KEY (conversation_id) REFERENCES conversations(id)
        ON DELETE CASCADE
);

-- =========================================
-- INDEXES
-- =========================================
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_post_images_post_id ON post_images(post_id);
CREATE INDEX idx_likes_post_id ON likes(post_id);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_shares_post_id ON shares(post_id);
CREATE INDEX idx_friendships_requester_id ON friendships(requester_id);
CREATE INDEX idx_friendships_addressee_id ON friendships(addressee_id);
CREATE INDEX idx_followers_follower_id ON followers(follower_id);
CREATE INDEX idx_followers_following_id ON followers(following_id);
CREATE INDEX idx_stories_user_id ON stories(user_id);
CREATE INDEX idx_story_views_story_id ON story_views(story_id);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_pages_owner_id ON pages(owner_id);
CREATE INDEX idx_page_followers_page_id ON page_followers(page_id);
CREATE INDEX idx_groups_owner_id ON groups(owner_id);
CREATE INDEX idx_group_members_group_id ON group_members(group_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
