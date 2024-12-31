use classicmodels;
-- 1.SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)
-- a) 
select * from employees;
select employeeNumber,firstname,lastname  from employees where jobTitle="Sales Rep" and reportsTo=1102;
-- b)
select * from products;
select distinct productline from products where productline like '%cars' ;
-- 2.CASE STATEMENTS for Segmentation
-- a)
select * from customers;
select customerNumber,customerName,
case
        when country="USA" or country="Canada" then "North America"
        when country="UK" or country="France" or country="Germany" then "Europe"
        else "Other"
end as CustomerSegment from customers;
-- Q3. Group By with Aggregation functions and Having clause, Date and Time functions
-- a)
select * from orderdetails;
select productCode, SUM(quantityOrdered) AS total_Ordered
from OrderDetails group by productCode order by total_ordered desc limit 10;
-- b)
select * from payments;
select monthname(paymentdate) as payment_month ,count(customerNumber) as num_payments
from payments group by payment_month having num_payments>20 order by num_payments desc;
-- 4)CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default
-- a)
create database customers_Orders;
create table customers2 (customer_id  int auto_increment primary key ,first_name varchar(50) not null,last_name varchar(50)not null,
email varchar(255) unique ,phone_number varchar(20));
-- b)
create table orders4(order_id int auto_increment primary key,customer_id int,order_date date,total_amount decimal(10,2),
constraint fk_customer1 foreign key(customer_id) references customers2(customer_id) ,
constraint chk_total_amount2 check(total_amount>=0)); 
-- 5)Joins
select * from customers;
select * from orders;
select c.country,count(o.orderNumber) as order_count from  customers as c
 join orders as o on c.customerNumber=o.customerNumber
 group by c.country order by order_count desc limit 5;
 -- 6)Self join
 create table project1(EmployeeId int auto_increment primary key,fullname varchar(50) not null,gender enum("male","female") not null,
 managerid int);
 select * from project1;
 insert into project1 (fullname,gender,managerid) values("Pranaya","Male",3);
 insert into project1 (fullname,gender,managerid) values
 ("Priyanka","Female",1),("Preety","Female",null),("Anurag","Male",1),
 ("Sambit","Male",1),("Rajesh","Male",3),("Hina","Female",3);
 select p.fullname as managername,p1.fullname as empname from project1 p
  join project1 p1 on p.employeeid=p1.managerid;
  -- 7)DDL commands:create,alter,rename
  create table facility(facility_id int,name varchar(30),state varchar(30),country varchar(30));
  -- i) 
  alter table facility modify facility_id int auto_increment, add primary key(facility_id);
  -- ii)
  alter table facility add city varchar(30) not null after name;
  describe facility;
  -- 8)views in sql
  select * from products;
  select * from orders;
  select * from orderdetails;
  select * from productlines;
  create view  product_category1 as 
  select p1.productline as productline,
  sum(od.quantityordered*priceeach) as total_sales,
  count(distinct o.ordernumber) as number_of_orders 
  from productlines p1 join products p on p.productline=p1.productline
  join orderdetails od on od.productcode=p.productcode
  join orders o on o.ordernumber=od.ordernumber
  group by p1.productline;
  select * from product_category1;
  -- 9)Stored Procedures in SQL with parameters
  select * from customers;
  select * from payments;
  
  DELIMITER $$
USE `classicmodels`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc`(year int,country varchar(30))
BEGIN
select
     year(p.paymentdate) as year,
     c.country as country,
     concat(format(sum(p.amount)/1000,0),'k') as totalamount
     from customers c join payments p on p.customernumber=c.customernumber
where
     year(p.paymentdate)=year and
     c.country=country
group by
	year(p.paymentdate),c.country;
     
END$$

DELIMITER ;
;
 call classicmodels.procedure1(2003, 'france');
 -- 10)Window functions - Rank, dense_rank, lead and lag
 -- a)
 select * from customers;
 select * from orders;
 with ctc as(select c.customername ,count(o.ordernumber)as order_count 
 from customers c join orders o on c.customernumber=o.customernumber
 group by customername)
 select customername,order_count,dense_rank()over(order by order_count desc) as order_frequency_rnk from ctc
 order by order_frequency_rnk;
 -- b)
 select * from orders;
 select year(orderdate) as "year",monthname(orderdate) as "Month",count(ordernumber) as "total orders",
 concat(round(((count(ordernumber)-lag(count(ordernumber),1)over())/lag(count(ordernumber),1)over())*100),"%") as "% YOY change"
 from orders group by year,month;
 -- 11)Subqueries and their applications
select * from products;
 select productline,count(*) as total from products 
 where buyprice>(select avg(buyprice) from products)group by productline order by total desc;
 -- 12)ERROR HANDLING in SQL
 create table emp_eh(empid int primary key,empname varchar(30),emailaddress varchar(30));
 
USE `classicmodels`;
DROP procedure IF EXISTS `classicmodels`.`errorhandling1`;
;

DELIMITER $$
USE `classicmodels`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `errorhandling`(e_empid int,e_empname varchar(30),e_emailaddress varchar(30))
BEGIN
declare exit handler for sqlexception
begin
select 'Error ocuured'as error;
end;
insert into emp_eh(empid,empname,emailaddress) values(e_empid,e_empname,e_emailaddress);
END$$

DELIMITER ;
;
call classicmodels.errorhandling(200, 'janani', 'janani333priya@gmail.com');
-- 13)TRIGGERS
create table emp_bit( Name varchar(30),occupation varchar(30),working_date date,working_hours int);
insert into emp_bit (name,occupation,working_date,working_hours) values ('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
delimiter $$
Create trigger Positive_Working_Hours1
before insert on  emp_bit
for each row
begin
    if new.working_hours < 0 then
        set new.working_hours = abs(new.working_hours);
    end if;
end $$




  
  
  