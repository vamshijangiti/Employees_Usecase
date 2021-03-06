create Database Employee

use Employee

---creating the department table

create table dept(dno int primary key,dname varchar(10) not null,Location varchar(20) check(location in('IND','USA','US')))

INSERT INTO dept VALUES(10,'ADMIN','IND')
INSERT INTO dept VALUES(20,'STAFF','US')
INSERT INTO dept VALUES(30,'HR','IND')
INSERT INTO dept VALUES(40,'ADMIN','USA')
INSERT INTO dept VALUES(50,'HR','US')
INSERT INTO dept VALUES(70,'Clerk','USA')


select * from dept

---creating the emp table

create Table emp(eid int unique not null,ename varchar(10) not null,salary int check(salary>=10000 and salary<=50000),dno int foreign key references dept(dno))

insert into emp values(1,'vamshi',50000,10)
insert into emp values(2,'Sriram',30000,20),(3,'Navya',45000,30),(4,'Akhila',45000,40),(5,'Amulya',35000,50)
insert into emp values(6,'Manasa',30000,60)

select * from emp


--creating the Projects Table

CREATE TABLE PROJECTS(PID INT PRIMARY KEY,PNAME VARCHAR(10) NOT NULL)
insert into PROJECTS values(100,'.NET')
insert into PROJECTS values (101,'c#'),(102,'JAVA')
insert into PROJECTS values (104,'HTML')
insert into PROJECTS values (103,'ADO.net')


select * from PROJECTS

--creating the EmpProjects tables

create table empProject (EID int foreign key references emp(eid),PID int Foreign key references projects(pid))

insert into empProject values(1,100)
insert into empProject values (2,101)
insert into empProject values (8,102)
insert into empProject values (3,104)

select * from empProject

--- 1ST QUERY

selecT * from emp e where dno  in (select dno from dept where dno=e.dno) 
select * from emp 
select * from dept 

--2ND QUERY-- 

select e.ename,e.eid,e.dno,p.PID,p.PNAME from emp e, PROJECTS p where eid in 
(select eid from empProjects where eid=e.eid and PID=p.PID)

select * from empProjects

---3RD QUERY--

select dno,sum(salary) as TotalDeptSalary from emp group by dno 

---4TH QUERY--

select dname from dept where dno not in (select dno from emp)

--5TH QUERY
--LIST 5TH MINIMUM SALARY EMP DETAILS USING NTH QUERY METHOD

SELECT *FROM EMP E WHERE 4=(SELECT COUNT(DISTINCT SALARY) FROM EMP WHERE SALARY<E.SALARY)

--6TH QUERY
SELECT e.eid , r.salary FROM emp e, emp r WHERE  e.salary = r.salary and e.eid=r.eid

--7th QUERY

CREATE PROC P1(@EID INT,@ENAME VARCHAR(20) , @SAL INT , @DNO INT )
AS 
BEGIN
SET NOCOUNT ON 
DECLARE @I INT , @J INT 
SELECT @I=COUNT(*) FROM EMP WHERE EID=@EID
SELECT @J=COUNT(*) FROM EMP WHERE DNO=@DNO
IF(@I>0)
PRINT 'EID SHOULD BE UNIQUE'
ELSE IF (@J=0)
PRINT 'DEPTNO NOT EXISTS'
ELSE IF (@ENAME IS NOT NULL)
PRINT 'ENAME SHOULD NOT BE NULL'
ELSE IF (@SAL>12000)
PRINT 'SALARY SHOULD NOT BE GREATER THAN 12000'
ELSE 
BEGIN
INSERT INTO EMP VALUES(@EID,@ENAME,@SAL,@DNO)
PRINT 'RECORD INSERTED SUCCESSFULLY'
END
END

EXEC P1 1,'PALLAVI',20000,30
SELECT * FROM EMP
-- 8TH QUERY
-- LIST EMP MONTHLYSALARY,ANNUAL SALARY AND SAVE AS VIEW
--CREATING A VIEW TO SELECT EID,SALARY FROM EMPS TABLE AND  TO CALCULATE AS ANNUAL,MONTHLY SALARY

CREATE VIEW VIEW1 AS SELECT EID,SALARY AS MONTHLYSALARY,(SALARY*12) AS ANNUALSALARY FROM EMP
SELECT *FROM VIEW1 --SELECTING VIEW1


-- 9TH QUERY
--CREATE ONE NEW EMPTABLE IN THAT TO STORE INSERTED,DELETED USING TRIGGER.

CREATE TABLE EMP2(EID INT,ENAME VARCHAR(10) NOT NULL,SALARY INT CHECK (SALARY BETWEEN 10000 AND 50000),DNO INT) --APPLYING CONSTRAINTS
SELECT *FROM EMP2
CREATE TRIGGER TR4 
ON EMP
FOR INSERT
AS
BEGIN
INSERT INTO EMP2 SELECT EID,ENAME,SALARY,DNO FROM INSERTED  
END
INSERT INTO EMP(EID,ENAME,SALARY,DNO) VALUES(133,'ABHIMANYU',30000,10) --INSERTING VALUES INTO NAMED 4 COLOUMNS
INSERT INTO EMP(EID,ENAME,SALARY,DNO) VALUES(134,'ABHIGNYA',25000,10) -- INSERTING VALUES INTO NAMED 4 COLOUMNS
SELECT *FROM EMP

CREATE TABLE EMP3(EID INT,ENAME VARCHAR(10) NOT NULL,SALARY INT CHECK(SALARY BETWEEN 10000 AND 50000),DNO INT)
SELECT *FROM EMP3
CREATE TRIGGER TR5  -- TRIGGER NAMED TR5
ON EMP
FOR DELETE
AS
BEGIN
INSERT INTO EMP3 SELECT EID,ENAME,SALARY,DNO FROM DELETED
END
DELETE FROM EMP WHERE EID=134  -- DELETES  EID RECORD
SELECT *FROM EMP   -- RETRIEVE EMPS DETAILS


--10TH QUERY
--TO MAKE TAX()FUNCTION FOR GIVEN SALARY WITH 13%

CREATE FUNCTION TAX (@SALARY INT)
RETURNS FLOAT  -- RETURNS FLOAT DATAYPE
BEGIN
SET @SALARY=@SALARY+(@SALARY*0.13) -- TO CALCULATE SALARY WITH 13%
RETURN @SALARY
END 
SELECT dbo.TAX(SALARY) FROM EMP    -- dbo is DATABASE OWNER WITH EXTENSION OF TAX FUNCTION
