--creating a database following naming conventions
create database Sql_RetailSales
go

--switching to current database ie from master to RetailSales
use Sql_RetailSales
go

--creating a table : retail_sales
--check if any table with name retail_sales is exists or not
DROP TABLE IF EXISTS retail_sales;
create table retail_sales(
transactions_id INT PRIMARY KEY,	
sale_date	DATE,
sale_time	TIME(0),
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),
quantiy	INT,
price_per_unit	FLOAT,
cogs FLOAT,
total_sale FLOAT
);

--inserting data from csv to retail_sales(table)
BULK INSERT dbo.retail_sales
FROM 'D:\SQL\Retail-Sales-Analysis-SQL-Project--P1\RetailSalesAnalysis_utf.csv'
WITH (
    FORMAT = 'CSV', 
    FIRSTROW = 2, -- skip header row
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    TABLOCK
);

--query the retail_sales for the records 
select * from retail_sales (NOLOCK);

--validating whether all records were inserted into table
select count(*) as TotalRecords from retail_sales (NOLOCK);

--validating if any of the columns is having null data 
select * from retail_sales (NOLOCK) where transactions_id is NULL;

select * from retail_sales (NOLOCK) where sale_date is NULL;

select * from retail_sales (NOLOCK) where sale_time is NULL;

select * from retail_sales (NOLOCK) where customer_id is NULL;

select * from retail_sales (NOLOCK) where gender is NULL;

select * from retail_sales (NOLOCK) where age is NULL;

select * from retail_sales (NOLOCK) where category is NULL;

select * from retail_sales (NOLOCK) where quantity is NULL;

select * from retail_sales (NOLOCK) where price_per_unit is NULL;

select * from retail_sales (NOLOCK) where cogs is NULL;

select * from retail_sales (NOLOCK) where total_sale is NULL;

















