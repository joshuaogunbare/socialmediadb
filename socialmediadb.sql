-- Drops tables if they exist
DROP TABLE IF EXISTS follow;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS photos;
DROP TABLE IF EXISTS users;

-- Create tables to store data
CREATE TABLE users (
  user_id TEXT PRIMARY KEY,
  user_name TEXT UNIQUE NOT NULL,
  date_created DATE
);

CREATE TABLE photos (
  photo_id TEXT PRIMARY KEY,
  image_url TEXT,
  user_id TEXT,
  publish_date DATE,
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE likes (
  user_id TEXT,
  photo_id TEXT,
  like_date DATE,
  PRIMARY KEY (user_id, photo_id),
  FOREIGN KEY (photo_id) REFERENCES photos (photo_id)
);

CREATE TABLE follow (
  follower_id TEXT,
  followee_id TEXT,
  follow_date DATE,
  PRIMARY KEY (follower_id, followee_id),
  FOREIGN KEY (follower_id) REFERENCES users (user_id),
  FOREIGN KEY (followee_id) REFERENCES users (user_id)
);

-- Insert data into users table
INSERT INTO users (user_id, user_name, date_created)
VALUES
('u001', 'john_doe', '2023-02-15'),
('u002', 'alex_smith', '2023-04-10'),
('u003', 'michael_lee', '2023-01-25'),
('u004', 'jessica_williams', '2023-03-03'),
('u005', 'sarah_martin', '2023-06-20'),
('u006', 'robert_johnson', '2023-05-12'),
('u007', 'emily_davis', '2023-08-07'),
('u008', 'christopher_brown', '2023-07-30'),
('u009', 'olivia_wilson', '2023-09-10'),
('u010', 'jacob_moore', '2023-11-22'),
('u011', 'samantha_clark', '2023-12-05'),
('u012', 'william_jones', '2023-10-15'),
('u013', 'madison_taylor', '2023-12-18'),
('u014', 'joseph_martinez', '2023-05-25'),
('u015', 'isabella_white', '2023-08-15'),
('u016', 'daniel_garcia', '2023-07-17'),
('u017', 'mia_rodriguez', '2023-09-03'),
('u018', 'jackson_harris', '2023-06-09'),
('u019', 'ella_king', '2023-11-30'),
('u020', 'mason_scott', '2023-04-25');

-- Insert data into photos table
INSERT INTO photos (photo_id, image_url, user_id, publish_date)
VALUES
('p101', 'https://example.com/photo1.jpg', 'u001', '2023-03-10'),
('p102', 'https://example.com/photo2.jpg', 'u002', '2023-04-12'),
('p103', 'https://example.com/photo3.jpg', 'u003', '2023-05-25'),
('p104', 'https://example.com/photo4.jpg', 'u004', '2023-06-18'),
('p105', 'https://example.com/photo5.jpg', 'u005', '2023-07-12'),
('p106', 'https://example.com/photo6.jpg', 'u006', '2023-08-05'),
('p107', 'https://example.com/photo7.jpg', 'u007', '2023-09-20'),
('p108', 'https://example.com/photo8.jpg', 'u008', '2023-10-01'),
('p109', 'https://example.com/photo9.jpg', 'u009', '2023-11-15'),
('p110', 'https://example.com/photo10.jpg', 'u010', '2023-12-05'),
('p111', 'https://example.com/photo11.jpg', 'u011', '2023-08-22'),
('p112', 'https://example.com/photo12.jpg', 'u012', '2023-09-30'),
('p113', 'https://example.com/photo13.jpg', 'u013', '2023-07-25'),
('p114', 'https://example.com/photo14.jpg', 'u014', '2023-10-12'),
('p115', 'https://example.com/photo15.jpg', 'u015', '2023-06-08'),
('p116', 'https://example.com/photo16.jpg', 'u016', '2023-05-14'),
('p117', 'https://example.com/photo17.jpg', 'u017', '2023-04-30'),
('p118', 'https://example.com/photo18.jpg', 'u018', '2023-08-14'),
('p119', 'https://example.com/photo19.jpg', 'u019', '2023-07-28'),
('p120', 'https://example.com/photo20.jpg', 'u020', '2023-10-10');

-- Insert data into likes table
INSERT INTO likes (user_id, photo_id, like_date)
VALUES
('u001', 'p101', '2023-03-12'),
('u002', 'p102', '2023-04-14'),
('u003', 'p103', '2023-05-27'),
('u004', 'p104', '2023-06-20'),
('u005', 'p105', '2023-07-14'),
('u006', 'p106', '2023-08-07'),
('u007', 'p107', '2023-09-22'),
('u008', 'p108', '2023-10-05'),
('u009', 'p109', '2023-11-17'),
('u010', 'p110', '2023-12-07');

-- Insert data into follow table
INSERT INTO follow (follower_id, followee_id, follow_date)
VALUES
('u001', 'u002', '2023-03-13'),
('u003', 'u005', '2023-04-16'),
('u007', 'u004', '2023-05-28'),
('u009', 'u006', '2023-06-02'),
('u012', 'u011', '2023-07-10');

-- Create function to auto-follow users who like photos
CREATE OR REPLACE FUNCTION auto_follow()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO follow (follower_id, followee_id, follow_date)
    VALUES (NEW.user_id, (SELECT user_id FROM photos WHERE photo_id = NEW.photo_id), NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for auto-follow
CREATE TRIGGER auto_follow_trigger
AFTER INSERT ON likes
FOR EACH ROW
EXECUTE FUNCTION auto_follow();

-- Example query to view all follow relationships
SELECT * FROM follow;
