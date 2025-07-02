# RetailSales_DataAnalysis
## Project Overview

**Project Title**: Retail Sales Analysis   
**Database**: `Sql_RetailSales`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Sql_RetailSales`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
FROM 'RetailSalesAnalysis.csv'
WITH (
    FORMAT = 'CSV', 
    FIRSTROW = 2, -- skip header row
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    TABLOCK
);

```
### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
--query the retail_sales for the records 
select * from retail_sales (NOLOCK);

--validating whether all records were inserted into table
select count(*) as TotalRecords from retail_sales (NOLOCK);

--Data Cleaning 
--validating if any of the columns is having null data 
select * from retail_sales (NOLOCK) 
where 
	transactions_id is NULL  OR
	sale_date is NULL OR
	sale_time is NULL OR
	customer_id is NULL OR 
	gender is NULL OR 
	category is NULL OR
	age is NULL OR
	quantity is NULL OR 
	price_per_unit is NULL OR 
	cogs is NULL OR 
	total_sale is NULL;

--delete the records which have the null values
delete from retail_sales
where transactions_id is NULL  OR
	sale_date is NULL OR
	sale_time is NULL OR
	customer_id is NULL OR 
	gender is NULL OR 
	category is NULL OR
	age is NULL OR
	quantity is NULL OR 
	price_per_unit is NULL OR 
	cogs is NULL OR 
	total_sale is NULL;

```
### 3. Data Analysis

The following SQL queries were developed to answer specific business questions:
--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05' :
select * 
from retail_sales(NOLOCK)
where sale_date = '2022-11-05';

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022:
select * 
from retail_sales(NOLOCK)
where category='Clothing' and quantity>=4 and Format(sale_date,'yyyy-MM') = '2022-11';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category :
select category, sum(total_sale) as TotalSales 
from retail_sales(NOLOCK)
GROUP BY category

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select avg(age) as AverageAge
from retail_sales(NOLOCK)
where category='Beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * 
from retail_sales(NOLOCK)
where total_sale>1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category,gender,count(transactions_id) as NoOfTransactions
from retail_sales(NOLOCK)
GROUP BY gender, category 
order by gender;

--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS sales_month,
        SUM(total_sale) AS total_sales
    FROM 
        retail_sales
    GROUP BY 
        YEAR(sale_date), MONTH(sale_date)
),
RankedMonths AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY sales_year ORDER BY total_sales DESC) AS rank_in_year
    FROM MonthlySales
)
SELECT 
    sales_year,
    sales_month,
    total_sales
FROM 
    RankedMonths
WHERE 
    rank_in_year = 1;

--8. Write a SQL query to find the top 5 customers based on the highest total sales **:
select top(5) customer_id,sum(total_sale) as Total
from retail_sales(NOLOCK)
group by customer_id
order by Total desc;

--9. Write a SQL query to find the number of unique customers who purchased items from each category.**:
select category, count(distinct customer_id) as UniqueCustomers
from retail_sales(NOLOCK)
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
With newTable AS (select *,
case when DATEPART(HOUR, sale_time) < 12 THEN 'Morning' 
	 when DATEPART(HOUR, sale_time) between 12 and 17 THEN 'Afternoon'
	 else 'Evening'
end as Shift
from retail_sales(NOLOCK) )

select Shift,count(*) as TotalOrders
from newTable 
group by Shift;

```

## Findings

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

