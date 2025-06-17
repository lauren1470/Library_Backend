CREATE TABLE Books (
   id INT AUTO_INCREMENT PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   author VARCHAR(255) NOT NULL,
   publisher VARCHAR(255) NOT NULL,
   isbn VARCHAR(255) NOT NULL,
   publication_year YEAR NOT NULL,
   genre VARCHAR(255) NOT NULL,
   available TINYINT(1) NOT NULL DEFAULT 1,
   price DECIMAL(10,2) NOT NULL
    );

INSERT INTO Books (title, author, publisher, isbn, publication_year, genre, available, price)
VALUES
('1984', 'George Orwell', 'Secker & Warburg', '9780451524935', 1949, 'Dystopian', 1, 9.99),
('The Hobbit', 'J.R.R. Tolkien', 'George Allen & Unwin', '9780261102217', 1937, 'Fantasy', 1, 12.50),
('To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', '9780061120084', 1960, 'Classic', 1, 8.99),
('The Martian', 'Andy Weir', 'Crown Publishing', '9780804139021', 2011, 'Science Fiction', 1, 10.99),
('Atomic Habits', 'James Clear', 'Avery', '9780735211292', 2018, 'Self-help', 1, 16.20);


CREATE TABLE Members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    register_date DATE NOT NULL
    );

INSERT INTO Members (first_name, last_name, address, phone, email, register_date)
VALUES
('Alice', 'Johnson', '123 Maple Street, Belfast', '07700 123456', 'alice.johnson@example.com', '2025-06-01'),
('Ben', 'Lee', '456 Oak Road, Derry', '07700 654321', 'ben.lee@example.com', '2025-06-02'),
('Carla', 'Nguyen', '789 Birch Ave, Armagh', '07700 112233', 'carla.nguyen@example.com', '2025-06-03'),
('David', 'Patel', '321 Cedar St, Lisburn', '07700 334455', 'david.patel@example.com', '2025-06-04'),
('Ella', 'OBrien', '159 Willow Lane, Newry', '07700 778899', 'ella.obrien@example.com', '2025-06-05');

CREATE TABLE Loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    loan_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(id),
    FOREIGN KEY (book_id) REFERENCES Books(id)
);

INSERT INTO Loans (member_id, book_id, loan_date, return_date)
VALUES
(1, 1, '2025-06-06', NULL),
(2, 2, '2025-06-07', '2025-06-14'),
(3, 3, '2025-06-08', NULL),
(4, 4, '2025-06-09', NULL),
(5, 5, '2025-06-10', '2025-06-17');

SELECT
    m.id AS member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    GROUP_CONCAT(b.title ORDER BY b.title SEPARATOR ', ') AS borrowed_books
FROM
    Loans l
JOIN
    Members m ON l.member_id = m.id
JOIN
    Books b ON l.book_id = b.id
GROUP BY
    m.id, m.first_name, m.last_name;


SELECT
    m.id AS member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    GROUP_CONCAT(b.title ORDER BY b.title SEPARATOR ', ') AS currently_borrowed_books
FROM
    Loans l
JOIN
    Members m ON l.member_id = m.id
JOIN
    Books b ON l.book_id = b.id
WHERE
    l.return_date IS NULL
GROUP BY
    m.id, m.first_name, m.last_name;


SELECT
    b.publisher,
    COUNT(*) AS total_loans
FROM
    Loans l
JOIN
    Books b ON l.book_id = b.id
WHERE
    YEAR(l.loan_date) = YEAR(CURDATE())
GROUP BY
    b.publisher
ORDER BY
    total_loans DESC
LIMIT 1;


SELECT
    b.author,
    COUNT(*) AS total_loans
FROM
    Loans l
JOIN
    Books b ON l.book_id = b.id
WHERE
    YEAR(l.loan_date) = YEAR(CURDATE())
GROUP BY
    b.author
ORDER BY
    total_loans ASC
LIMIT 1;


SELECT
    title,
    CASE
        WHEN available = 1 THEN 'Available'
        ELSE 'Unavailable'
    END AS availability_status
FROM
    Books;


SELECT
    genre,
    COUNT(*) AS book_count
FROM
    Books
GROUP BY
    genre
ORDER BY
    book_count DESC;



SELECT
    b.title AS name,
    'Book' AS type
FROM
    Books b
LEFT JOIN
    Loans l ON b.id = l.book_id
WHERE
    l.id IS NULL

UNION


SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS name,
    'Member' AS type
FROM
    Members m
LEFT JOIN
    Loans l ON m.id = l.member_id
WHERE
    l.id IS NULL;



SELECT
    AVG(b.price) AS average_price
FROM
    Books b
JOIN
    Loans l ON b.id = l.book_id
WHERE
    b.publication_year = YEAR(CURDATE()) - 1;


UPDATE Books
SET price = price * 0.8
WHERE publication_year < YEAR(CURDATE()) - 5;


UPDATE Members
SET first_name = UPPER(first_name);

UPDATE Members
SET first_name = CONCAT(UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2)));



DELETE FROM Loans
WHERE return_date IS NOT NULL
  AND return_date < CURDATE() - INTERVAL 1 MONTH;



CREATE INDEX idx_author ON Books(author);
CREATE INDEX idx_publisher ON Books(publisher);


CREATE UNIQUE INDEX idx_email_unique ON Members(email);


