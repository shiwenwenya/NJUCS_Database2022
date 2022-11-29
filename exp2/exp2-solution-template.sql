-- 姓名：田馥雯
-- 学号：201220215
-- 提交前请确保本次实验独立完成，若有参考请注明并致谢。

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1.1
drop procedure if exists GenerateProductOrder;

delimiter $
create procedure GenerateProductOrder(in productName Varchar(40))
begin
	select customer.customerNo, customer.customerName, ordermaster.orderNo, orderdetail.quantity, orderdetail.price
	from product, customer, ordermaster, orderdetail
	where  product.productName = productName and product.productNo = orderdetail.productNo and customer.customerNo = ordermaster.customerNo and ordermaster.orderNo = orderdetail.orderNo
    order by orderdetail.price desc;
end$
delimiter ;

call GenerateProductOrder('32M DRAM');
-- END Q1.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1.2
drop procedure if exists EarlyHiredEmployee;

delimiter $
create procedure EarlyHiredEmployee(in employeeNo Char(8))
begin
	select E1.employeeNo, E1.employeeName, E1.gender, E1.hireDate, E1.department
	from employee E1, employee E2
	where  E2.employeeNo = employeeNo and E1.hireDate < E2.hireDate and E1.department = E2.department;
end$
delimiter ;

call EarlyHiredEmployee('E2008005');
-- END Q1.2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2.1
drop function if exists AverageOrderPrice;

delimiter $
create function AverageOrderPrice(productName Varchar(40))
returns float
deterministic
begin
	declare averagePrice float;
	select avg(orderdetail.price) into averagePrice
    from orderdetail, product
    where orderdetail.productNo = product.productNo and product.productName = productName
    group by product.productName;
    return averagePrice;
end$
delimiter ;

select product.productName, AverageOrderPrice(product.productName) AS averageOrderPrice
from product;
-- END Q2.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2.2
drop function if exists TotalSalesOfProduct;

delimiter $
create function TotalSalesOfProduct(productNo char(9))
returns integer
deterministic
begin
	declare totalSales integer;
	select sum(orderdetail.quantity) into totalSales
    from orderdetail
    where orderdetail.productNo = productNo
    group by orderdetail.productNo;
    return totalSales;
end$
delimiter ;

select product.productNo, product.productName, TotalSalesOfProduct(product.productNo) AS totalSalesOfProduct
from product
where TotalSalesOfProduct(product.productNo) > 4;
-- END Q2.2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3.1
drop trigger if exists InsertProductPrice;

delimiter $
create trigger InsertProductPrice before insert on product for each row
begin
	if new.productPrice > 1000 then
		set new.productPrice = 1000;
	end if;
end$
delimiter ;
-- END Q3.1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3.2
drop trigger if exists IncreaseSalary;

delimiter $
create trigger IncreaseSalary before insert on ordermaster for each row
begin
	declare preSalary float;
    set preSalary = (select salary from employee where employeeNo = new.employeeNo);
	if (select hireDate from employee where employeeNo = new.employeeNo) < date('1992-01-01') then
		update employee set salary = preSalary * 1.05 * 1.03 where employeeNo = new.employeeNo;
	else 
		update employee set salary = preSalary * 1.05 where employeeNo = new.employeeNo;
	end if;
end$
delimiter ;

-- END Q3.2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3.1 TEST
insert product values('P20090001','64M DRAM',             '内存',80.70);
insert product values('P20090002','300GB硬盘',            '存储器',3010.80);
select * from product where productNo like 'P2009%';
delete from product where productNo like 'P2009%';
-- END Q3.1 TEST

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3.2 TEST
insert Employee values('E2009001','雨雨','M','19991014','上海市永吉路1号',null,  '20190528','业务科','职员',1000);
insert Employee values('E2009002','俞超杰','F','19701106','深圳市阳关大道10号',null,  '19901118','财务科','会计',2000);

insert OrderMaster values('200905090001','C20060002','E2009001','20080509',0.00,'I000000009');
insert OrderMaster values('200906120001','C20050001','E2009002','20080612',0.00,'I000000010');

select employeeNo, hireDate, salary
from employee
where employeeNo like 'E2009%';

SET FOREIGN_KEY_CHECKS = 0;
delete from employee where employeeNo like 'E2009%';
SET FOREIGN_KEY_CHECKS = 1;
delete from ordermaster where orderNo like '2009%';
-- END Q3.2 TEST       
 
