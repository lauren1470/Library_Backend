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
('The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', '9780743273565', 1925, 'Fiction', 1, 10.99),
('To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', '9780061120084', 1960, 'Fiction', 1, 7.99);


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
('lauren', 'obrien', '20a main street', '07776835699' 'lauren.obrien@kainos.com', '16/06/2025'),
('Lena', 'Morris', '42 Elm Street, London', '07911 345678', 'lena.morris@example.com', '2025-04-21'),
('Dylan', 'Sharma', '88 King’s Avenue, Birmingham', '07488 223344', 'dylan.sharma@example.com', '2025-06-05'),
('Priya', 'Nguyen', '17 Baker Road, Manchester', '07777 987654', 'priya.nguyen@example.com', '2025-05-11'),
('Ethan', 'Okafor', '29 Park Lane, Leeds', '07123 456789', 'ethan.okafor@example.com', '2025-03-18'),
('Chloe', 'Davies', '10 Queen Street, Bristol', '07555 112233', 'chloe.davies@example.com', '2025-01-29');

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
-- Member 1 borrows Book 1 and Book 2
(1, 1, '2025-06-01', '2025-06-10'),
(1, 2, '2025-06-02', NULL),

-- Member 2 borrows Book 1 and Book 3
(2, 1, '2025-06-03', NULL),
(2, 3, '2025-06-04', '2025-06-15'),

-- Member 3 borrows Book 4
(3, 4, '2025-06-05', NULL),

-- Member 4 borrows Book 5
(4, 5, '2025-06-06', NULL),

-- Member 5 borrows Book 2 (already borrowed by Member 1 as well)
(5, 2, '2025-06-07', '2025-06-14');

--Write a query that returns all members with a comma-seperated list of the books they have loaned
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

--Write a query that returns members who have loaned books that have not been returned yet and a comma-seperated list of the books
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

--Write a query that returns the name of the publisher who has loaned the most books this year and how many
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

--Write a query that returns the name of the author who has loaned the least books this year and how many
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

--Write a query that returns the name of all books with a column that says 'Available' if the book is available and 'Unavailable' if the book is not available
SELECT
    title,
    CASE
        WHEN available = 1 THEN 'Available'
        ELSE 'Unavailable'
    END AS availability_status
FROM
    Books;

--Write a query that returns all book genre's with a count of how many books each genre has
SELECT
    genre,
    COUNT(*) AS book_count
FROM
    Books
GROUP BY
    genre
ORDER BY
    book_count DESC;


--Write a query that returns all books that have not been loaned and all members who have not loaned any books
-- Books never loaned
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

-- Members who never borrowed a book
SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS name,
    'Member' AS type
FROM
    Members m
LEFT JOIN
    Loans l ON m.id = l.member_id
WHERE
    l.id IS NULL;


--Write a query that returns the average price of books published last year that have been loaned
SELECT
    AVG(b.price) AS average_price
FROM
    Books b
JOIN
    Loans l ON b.id = l.book_id
WHERE
    b.publication_year = YEAR(CURATE()) - 1;

--Update the price of all books older than 5 years old to reduce the price by 20%
UPDATE Books
SET price = price * 0.8
WHERE publication_year < YEAR(CURATE()) - 5;

--Update the first name of all members to be upper case
UPDATE Members
SET first_name = UPPER(first_name);

UPDATE Members
SET first_name = CONCAT(UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2)));


--Delete loans where the book was returned more that 1 month ago
DELETE FROM Loans
WHERE return_date IS NOT NULL
  AND return_date < CURATE() - INTERVAL 1 MONTH;


--CREATE INDEX idx_genre ON Books(genre);
  CREATE INDEX idx_author ON Books(author);
  CREATE INDEX idx_publisher ON Books(publisher);

--Add a unique index to the email column to prevent incorrect data entry
CREATE UNIQUE INDEX idx_email_unique ON Members(email);


