--TASK 1:Database Design
--1) creating a database for advanced banking system
CREATE DATABASE BANKINGDB

--renaming the BANKINGDB TO HMBANK
ALTER DATABASE BANKINGDB MODIFY NAME=HMBANK

--to change database instance
USE HMBANK

--2) create a table Customers
CREATE TABLE Customers(
customer_id INT PRIMARY KEY NOT NULL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
DOB DATE NOT NULL,
email VARCHAR(50) NOT NULL,
phone_number INT NOT NULL,
address VARCHAR (50) NOT NULL)

--2) create a table Accounts
CREATE TABLE Accounts(
account_id INT PRIMARY KEY NOT NULL,
customer_id INT NOT NULL,
account_type VARCHAR (25) NOT NULL,
balance INT NOT NULL,
FOREIGN KEY(customer_id)
REFERENCES Customers(customer_id))

--2) create a table Transactions
CREATE TABLE Transactions(
transaction_id INT PRIMARY KEY NOT NULL,
account_id INT NOT NULL,
transaction_type VARCHAR(50) NOT NULL,
amount FLOAT NOT NULL,
transaction_date DATE NOT NULL,
FOREIGN KEY(account_id)
REFERENCES Accounts(account_id))

--change the data type of the column balance in table Accounts
ALTER TABLE Accounts
ALTER COLUMN balance DECIMAL

--change the data type of the column DOB in Customers table
ALTER TABLE Customers
ALTER COLUMN DOB DATE

--TASK 2:Select,Where,Between,and Like
--1) inserting 10 sample records in Customers Table
INSERT INTO Customers(customer_id,first_name,last_name,DOB,email,phone_number,address)
values(1,'Jack','Snowdon',1995-03-15,'jacksnowdon@gmail.com',5551234,'Bangalore'),
(2,'John','Doe',1990-07-21,'johndoe@gmail.com',5555678,'Chennai'),
(3,'Alice','Smith',2000-10-12,'alice@gmail.com',5559012,'Washington'),
(4,'Emily','Woods',2002-11-01,'woods@gmail.com',5553456,'Manhattan'),
(5,'David','Lee',1997-01-01,'davidlee@gmail.com',5554321,'Coimbatore'),
(6,'Chris','Hemsworth',1990-04-09,'hemsworth@gmail.com',5556432,'Bangalore'),
(7,'Emma','Watson',1998-05-29,'emma@gmail.com',5551357,'Mumbai'),
(8,'Andrew','Garfield',1995-09-19,'andrewgarfield@gmail.com',5559876,'Manhattan'),
(9,'Chris','Evans',1990-12-05,'chrisevans@gmail.com',5554680,'Chennai'),
(10,'Tom','Holland',2001-11-18,'tomholland@gmail.com',5559753,'Mumbai')

--view the contents in Customers Table
SELECT * FROM Customers

--1) Insert 10 values in Accounts Table
INSERT INTO Accounts(account_id,customer_id,account_type,balance)
values(1001,1,'zero_balance',1000),
(1002,2,'savings',20000),
(1003,7,'savings',50000),
(1004,4,'current',5000),
(1005,6,'zero_balance',6664),
(1006,3,'savings',15000),
(1007,5,'current',1000),
(1008,9,'current',7500),
(1009,8,'savings',10000),
(1010,10,'zero_balance',4750)

--view the contents of Accounts Table
SELECT *FROM Accounts

--1) Insert 10 values in Transactions table
INSERT INTO Transactions(transaction_id,account_id,transaction_type,amount,transaction_date)
values (501,1001,'deposit',1000,'2024-02-01'),
(502,1003,'transfer',5000,'2023-11-01'),
(503,1002,'withdrawal',10000,'2023-01-21'),
(504,1004,'deposit',5000,'2023-09-19'),
(505,1006,'withdrawal',2500,'2023-10-15'),
(506,1005,'transfer',500,'2024-03-16'),
(507,1007,'deposit',1000,'2023-05-11'),
(508,1008,'withdrawal',1500,'2023-06-17'),
(509,1009,'transfer',2500,'2023-07-19'),
(510,1010,'deposit',5000,'2023-12-12')

--1) view the contents of Transactions table
SELECT *FROM Transactions

--2.1) query to retrieve the name,account type and email of all Customers
SELECT Customers.first_name,Customers.last_name,Customers.email,Accounts.account_type
FROM Customers
JOIN Accounts ON Customers.customer_id=Accounts.customer_id


--2.2) list all transaction corresponding customer
SELECT transaction_type FROM Transactions
WHERE transaction_id=507

--2.3) increase the balance of a specific account by certain amount
UPDATE Accounts 
SET balance=15000
WHERE customer_id=7
--View tha balance column of Accounts table
SELECT balance 
From Accounts 
WHERE customer_id=7

--2.4) combine first and last name of customer to full name
SELECT CONCAT(first_name,' ',last_name) 
AS full_name
FROM Customers

--2.5) remove counts with a balance of zero where the account type is savings
--update 2 accounts of saving to zero
UPDATE Accounts
SET balance=0
WHERE account_id=1002
--to remove
DELETE FROM Accounts
WHERE balance=0 AND account_type='savings'

--2.6) find customers living in a particular city
DECLARE @VALUE VARCHAR (20)='Manhattan'
SELECT * FROM Customers
WHERE address=@VALUE

--2.7) get account balance for specific account
DECLARE @ID INT=1005
SELECT balance FROM Accounts
WHERE account_id=@ID

--2.8) List all current accounts with a balance greater than $1000
SELECT * FROM Accounts 
WHERE account_type='Current' AND balance>1000

--2.9) Retrieve all transactions for a specific account
SELECT transaction_id FROM Transactions
WHERE account_id=1006

--2.10) Calculate the interest accrued on savings accounts based on a given interest rate
DECLARE @INTEREST DECIMAL=4.5
SELECT account_id,
 balance*(@INTEREST *balance) AS Interest
FROM Accounts WHERE ACCOUNT_TYPE='savings'

--2.11) Indentify accounts where the balance is less than a specified overdraft limit
DECLARE @LIMIT INT=1500
SELECT * FROM Accounts
WHERE  balance<@LIMIT

--2.12) find the customers not living in Chennai
SELECT * FROM Customers 
WHERE address!='Chennai'

--TASK 3:Aggregate functions, Having order, Order By, Groupby and Joins
--1) Find the average account balance for all customers
 SELECT Avg(balance) FROM Accounts

--2) Retrieve the top 10 highest accounts balance
SELECT TOP 10 balance 
FROM Accounts
ORDER BY balance DESC

--3) Calculate total deposit for all customers in a specifice date
DECLARE @DATE DATE='2024-02-01'
SELECT SUM(amount) FROM Transactions 
WHERE transaction_type='deposit' AND transaction_date=@DATE

--4) Find the Oldest and Newest Customer 
SELECT First_Name,DOB FROM Customers
WHERE DOB =(SELECT MIN(DOB) FROM Customers)OR
DOB=(SELECT MAX(DOB) FROM Customers)

--5)Retrieve transaction details with account type
SELECT Transactions.transaction_id,Transactions.transaction_type,Accounts.account_type
FROM Transactions
JOIN Accounts ON Accounts.account_id=Transactions.account_id

--6) Get a list of Customers along with their account details
SELECT Customers.customer_id,Customers.first_name,Customers.last_name,
Accounts.account_id,Accounts.account_type,Accounts.balance
FROM Customers
JOIN Accounts ON Customers.customer_id=Accounts.customer_id  

--7) Retreive transaction details along with customer information for a specific account
DECLARE @ACCOUNT INT=1005
SELECT Customers.customer_id,Customers.first_name,Customers.last_name,Customers.DOB,Customers.email,Customers.phone_number,Customers.address,
Transactions.transaction_id,Transactions.transaction_type,Transactions.amount,Transactions.transaction_date
FROM Transactions
JOIN Accounts ON Transactions.account_id=Accounts.account_id
JOIN Customers ON Accounts.customer_id=Customers.customer_id
WHERE Accounts.account_id=@ACCOUNT

--8) Identify customers who have more than one account
SELECT customer_id,COUNT(account_id) AS num_account
FROM Accounts
GROUP BY customer_id
HAVING COUNT(account_id)> 1

--9) Calculate the difference in transaction amounts between deposits and withdrawals
SELECT SUM(CASE WHEN transaction_type='deposit' THEN amount WHEN transaction_type='withdrawl' THEN -amount END) AS net_amount
FROM Transactions

--10) Calculate the average daily balance for each account over a specified period
SELECT A.account_id,AVG(A.balance) AS daily_balance
FROM Accounts A
JOIN Transactions T
ON A.account_id=T.account_id
WHERE transaction_date BETWEEN '01-01-2023' AND '01-01-2024'
GROUP BY A.account_id


--11) Calculate total balance for each account type
SELECT account_type,SUM(balance) AS total_balance
FROM Accounts
GROUP BY account_type

--12) Identify accounts with the highest number of transactions order by descending order
SELECT account_id,COUNT(*) AS Total_transaction
FROM Transactions
GROUP BY account_id
ORDER BY Total_transaction DESC

--13) List customers with high aggregate account balances, along with their account types
SELECT C.customer_id,C.first_name,A.account_type,
(A.balance)Total_Balance
FROM Customers C
JOIN Accounts A ON C.customer_id=A.customer_id
GROUP BY C.customer_id,C.first_name,A.account_type,A.balance
HAVING A.balance >(SELECT AVG(balance) FROM Accounts)
ORDER BY Total_Balance  DESC

--14) Identify and list duplicate transactions based on transaction amount, date, and account.
SELECT account_id,amount,transaction_date,COUNT(*) AS Duplicate
FROM Transactions 
GROUP BY amount,transaction_date,account_id
HAVING COUNT(*) > 1

ALTER TABLE Accounts
ADD CONSTRAINT CK_Accounts_account_type
CHECK (account_type in ('savings','zero_balance','current'))

--TASK 4: Subquery and its types
--1) Retrieve the customer(s) with the highest account balance
SELECT * FROM Accounts
WHERE  balance IN
(SELECT MAX(balance)AS [Highest balance] 
FROM Accounts )

--2)Calculate the average account balance for customers who have more than one account.
SELECT AVG(balance) AS [Average Balance],account_id,customer_id
FROM Accounts 
WHERE customer_id IN
(SELECT customer_id FROM Accounts
GROUP BY customer_id
HAVING COUNT(customer_id) > 1)
GROUP BY account_id,customer_id

--3)Retrieve accounts with transactions whose amounts exceed the average transaction amount
SELECT account_id,transaction_id,amount 
FROM Transactions WHERE amount >=
(SELECT AVG(amount) AS [Transaction Amount] 
FROM Transactions)

--4)Identify customers who have no recorded transactions.
SELECT * 
FROM Customers C
JOIN  Accounts A
ON C.customer_id=A.customer_id
WHERE A.account_id  NOT IN(
SELECT account_id  
FROM Transactions)

--5)Calculate the total balance of accounts with no recorded transactions
SELECT SUM(A.balance)AS [Total Balance]
FROM Customers C
JOIN Accounts A
ON C.customer_id=A.customer_id
WHERE A.account_id NOT IN
(SELECT account_id 
FROM Transactions)

--6)Retrieve transactions for accounts with the lowest balance
SELECT T.* 
FROM Transactions T
JOIN (
SELECT account_id FROM Accounts A
WHERE balance=
(SELECT MIN(balance) FROM Accounts))AS Lowest_balance 
ON T.account_id=Lowest_balance.account_id 

--7)Identify customers who have accounts of multiple types
SELECT customer_id
FROM (SELECT customer_id,COUNT(DISTINCT account_type) AS account_type
FROM Accounts
GROUP BY customer_id) AS customer_account_types
WHERE account_type>1

--8)Calculate the percentage of each account type out of the total number of accounts
SELECT account_type,COUNT(*) AS num_accounts,
(COUNT(*) * 100.0)/(SELECT COUNT(*) FROM Accounts) AS Percentage
FROM Accounts
GROUP BY account_type

 --9)Retrieve all transactions for a customer with a given customer_id.
DECLARE @ID INT=3
SELECT * FROM Transactions  WHERE account_id IN
(SELECT account_id
FROM Accounts
WHERE customer_id=@ID)

--10)Calculate the total balance for each account type, including a subquery within the SELECT clause.
SELECT DISTINCT(A.account_type) AS Distinct_Type,innerquery.Total_balance
FROM
(SELECT account_type,SUM(balance) AS Total_balance
FROM Accounts
GROUP BY account_type) AS innerquery
JOIN Accounts A 
ON innerquery.account_type=A.account_type















