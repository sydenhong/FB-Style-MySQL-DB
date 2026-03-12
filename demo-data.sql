USE fb_demo;

INSERT INTO users (full_name, email, password, bio, gender)
VALUES
('John Doe', 'john@example.com', '123456', 'Hello I am John', 'male'),
('Jane Smith', 'jane@example.com', '123456', 'Love coffee', 'female'),
('David Lee', 'david@example.com', '123456', 'Web developer', 'male'),
('Sok Dara', 'dara@example.com', '123456', 'From Cambodia', 'male');

INSERT INTO posts (user_id, content, privacy, feeling, location, post_type)
VALUES
(1, 'Hello everyone! My first post.', 'public', 'happy', 'Phnom Penh', 'text'),
(2, 'Good morning with coffee.', 'public', 'excited', 'Siem Reap', 'image'),
(3, 'Working on new app.', 'friends', 'motivated', 'Battambang', 'text');

INSERT INTO post_images (post_id, image_url)
VALUES
(2, 'coffee.jpg');

INSERT INTO likes (user_id, post_id, reaction_type)
VALUES
(2, 1, 'like'),
(3, 1, 'love'),
(4, 1, 'haha');

INSERT INTO comments (user_id, post_id, comment_text)
VALUES
(2, 1, 'Nice post!'),
(3, 1, 'Welcome!');

INSERT INTO shares (user_id, post_id, share_text)
VALUES
(4, 1, 'Check this out.');

INSERT INTO friendships (requester_id, addressee_id, status)
VALUES
(1, 2, 'accepted'),
(1, 3, 'pending');

INSERT INTO followers (follower_id, following_id)
VALUES
(2, 1),
(3, 1);

INSERT INTO stories (user_id, media_url, media_type, caption, expires_at)
VALUES
(1, 'story1.jpg', 'image', 'My Story', DATE_ADD(NOW(), INTERVAL 1 DAY));

INSERT INTO conversations (conversation_type, title)
VALUES
('private', NULL),
('group', 'Project Team');

INSERT INTO conversation_members (conversation_id, user_id)
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(2, 3);

INSERT INTO messages (conversation_id, sender_id, message_text)
VALUES
(1, 1, 'Hello Jane'),
(1, 2, 'Hi John'),
(2, 3, 'Team meeting today');

INSERT INTO pages (owner_id, page_name, category, description)
VALUES
(1, 'John Tech', 'Technology', 'Technology news and tutorials');

INSERT INTO page_followers (page_id, user_id)
VALUES
(1, 2),
(1, 3);

INSERT INTO groups (owner_id, group_name, description, privacy)
VALUES
(2, 'PHP Developers', 'Discuss PHP coding', 'public');

INSERT INTO group_members (group_id, user_id, role, status)
VALUES
(1, 2, 'admin', 'approved'),
(1, 1, 'member', 'approved'),
(1, 3, 'member', 'approved');

INSERT INTO notifications (user_id, actor_id, type, post_id, is_read)
VALUES
(1, 2, 'like', 1, 0),
(1, 3, 'comment', 1, 0);
