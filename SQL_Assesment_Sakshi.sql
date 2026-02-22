CREATE DATABASE company;
USE company;
CREATE TABLE dept (
    deptno INT PRIMARY KEY,
    dname VARCHAR(50),
    loc VARCHAR(50)
);

CREATE TABLE emp (
    empno INT PRIMARY KEY,
    ename VARCHAR(50),
    job VARCHAR(50),
    mgr INT NULL,
    hiredate DATE,
    sal DECIMAL(10,2),
    comm DECIMAL(10,2) NULL,
    deptno INT REFERENCES dept(deptno)
);

INSERT INTO dept VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept VALUES (40, 'OPERATIONS', 'BOSTON');
INSERT INTO dept VALUES (50, 'IT', 'HYDERABAD');



INSERT INTO emp VALUES (1001,'SMITH','CLERK',7902,'2018-01-01',1200,NULL,20);
INSERT INTO emp VALUES (1002,'ALLEN','SALESMAN',7698,'2019-02-20',1800,300,30);
INSERT INTO emp VALUES (1003,'WARD','SALESMAN',7698,'2017-03-15',1700,500,30);
INSERT INTO emp VALUES (1004,'JONES','MANAGER',7839,'2016-04-02',2975,NULL,20);
INSERT INTO emp VALUES (1005,'MARTIN','SALESMAN',7698,'2019-05-12',1600,1400,30);
INSERT INTO emp VALUES (1006,'BLAKE','MANAGER',7839,'2015-06-09',2850,NULL,30);
INSERT INTO emp VALUES (1007,'CLARK','MANAGER',7839,'2014-07-19',2450,NULL,10);
INSERT INTO emp VALUES (1008,'SCOTT','ANALYST',7566,'2020-08-01',3000,NULL,20);
INSERT INTO emp VALUES (1009,'KING','PRESIDENT',NULL,'2013-09-11',5000,NULL,10);
INSERT INTO emp VALUES (1010,'TURNER','SALESMAN',7698,'2021-10-10',1500,0,30);
INSERT INTO emp VALUES (1011,'ADAMS','CLERK',7788,'2022-11-05',1100,NULL,20);
INSERT INTO emp VALUES (1012,'JAMES','CLERK',7698,'2023-01-23',950,NULL,30);
INSERT INTO emp VALUES (1013,'FORD','ANALYST',7566,'2018-02-14',3000,NULL,20);
INSERT INTO emp VALUES (1014,'MILLER','CLERK',7782,'2017-04-18',1300,NULL,10);
INSERT INTO emp VALUES (1015,'RAJ','DEVELOPER',1007,'2021-06-21',4200,NULL,50);
INSERT INTO emp VALUES (1016,'ARUN','DEVELOPER',1015,'2022-03-10',3900,NULL,50);
INSERT INTO emp VALUES (1017,'PRIYA','TESTER',1015,'2021-07-12',2800,NULL,50);
INSERT INTO emp VALUES (1018,'KIRAN','TESTER',1015,'2020-08-14',2600,NULL,50);
INSERT INTO emp VALUES (1019,'NEHA','HR',1007,'2019-09-09',2400,NULL,10);
INSERT INTO emp VALUES (1020,'ROHIT','HR',1007,'2023-01-01',2200,NULL,10);


-- 1. Display total salaries for each job within each loc, excluding job type President.
SELECT d.loc, e.job, SUM(e.sal) AS total_salary
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE e.job != 'PRESIDENT'
GROUP BY d.loc, e.job;

-- 2. Display the department name in which there is the highest salary employee.
SELECT dname FROM dept d
JOIN emp e ON d.deptno=e.deptno
WHERE e.sal = (SELECT MAX(sal) FROM emp);

-- 3. Display top 2 highest salary earners from each job excluding job type President.
with cte as(
SELECT *, dense_rank() over (PARTITION BY job ORDER BY sal DESC) AS rn
FROM emp WHERE job!='PRESIDENT')
SELECT ename, job, sal, rn FROM cte WHERE rn <=2;

-- 4. Display all columns from both the dept and emp table for matching deptno. The nonmatching records of dept table should also get displayed. Ensure that the output has records of those employees who earn salary above 2000.
SELECT * FROM dept d
LEFT JOIN emp e ON d.deptno=e.deptno AND e.sal>2000;

-- 5. Display employee name, salary, job, average salary within that job and difference of how much more salary that employee is getting for all those employees who earn salary greater than average salary of their own job type.
WITH cte AS (
SELECT ename, sal, job, AVG(sal) OVER (PARTITION BY job) AS avg_sal FROM emp)
SELECT ename, job, sal, avg_sal, (sal- avg_sal) AS diff FROM cte WHERE sal > avg_sal;





