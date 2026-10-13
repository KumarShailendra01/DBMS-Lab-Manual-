CREATE DATABASE CompanyDB;
USE CompanyDB;
CREATE TABLE Department ( dept_id INT PRIMARY KEY,
dept_name VARCHAR(50) NOT NULL
);
CREATE TABLE Project ( project_id INT PRIMARY KEY,
project_name VARCHAR(100) NOT NULL, budget DECIMAL(12,2),
dept_id INT,
FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);
CREATE TABLE Employee ( emp_id INT PRIMARY KEY,
emp_name VARCHAR(50) NOT NULL, salary DECIMAL(10,2),
hire_date DATE, dept_id INT, project_id INT, manager_id INT,
FOREIGN KEY (dept_id) REFERENCES Department(dept_id), FOREIGN KEY (project_id) REFERENCES Project(project_id), FOREIGN KEY (manager_id) REFERENCES Employee(emp_id)
);
 
-- Insert Departments
INSERT INTO Department VALUES (1,'Development'),
(2,'PeopleOps'),
(3,'Accounts'),
(4,'Sales'),
(5,'Logistics');
-- Insert Projects
INSERT INTO Project VALUES
(101,'Web Platform',150000,1), (102,'Data Insights',200000,1), (103,'Talent Hub',80000,2),
(104,'Audit Dashboard',120000,3), (105,'Sales Campaign',90000,4), (106,'Logistics Tracker',180000,5), (107,'Mobile Suite',140000,1), (108,'Employee Care',60000,2);
-- Insert 30 Employees
INSERT INTO Employee VALUES (1,'Ishaan',65000,'2022-01-10',1,101,NULL),
(2,'Reyansh',72000,'2021-03-15',1,102,1),
(3,'Adit',58000,'2023-06-20',1,107,2),
(4,'Aarush',81000,'2020-08-12',1,101,3),
(5,'Raghav',69000,'2022-11-05',1,102,4),
(6,'Vihaan',62000,'2024-02-18',1,107,5),


(7,'Anika',52000,'2022-04-11',2,103,NULL),
(8,'Kavya',48000,'2023-01-22',2,108,7),
(9,'Ira',61000,'2021-07-19',2,103,8),
(10,'Naina',55000,'2022-09-30',2,108,9),
(11,'Aditi',47000,'2024-03-14',2,103,10),
(12,'Saanvi',59000,'2020-12-01',2,108,11),


(13,'Harsh',75000,'2021-02-17',3,104,NULL),
 
(14,'Mohit',68000,'2022-05-09',3,104,13),
(15,'Ritvik',83000,'2019-10-21',3,104,14),
(16,'Ayush',62000,'2023-08-13',3,104,15),
(17,'Kunal',71000,'2021-11-28',3,104,16),
(18,'Varun',56000,'2024-01-09',3,104,17),


(19,'Mehak',54000,'2022-02-25',4,105,NULL),
(20,'Pihu',63000,'2021-06-16',4,105,19),
(21,'Shreya',57000,'2023-04-10',4,105,20),
(22,'Tara',66000,'2020-09-07',4,105,21),
(23,'Mahi',51000,'2024-02-05',4,105,22),
(24,'Anvi',70000,'2022-12-19',4,105,23),


(25,'Rajat',60000,'2021-01-12',5,106,NULL),
(26,'Yuvraj',73000,'2020-04-23',5,106,25),
(27,'Arnav',67000,'2022-07-18',5,106,26),
(28,'Laksh',59000,'2023-05-29',5,106,27),
(29,'Devansh',76000,'2019-08-31',5,106,28),
(30,'Om',64000,'2024-01-20',5,106,29);

Select * from Employee;

