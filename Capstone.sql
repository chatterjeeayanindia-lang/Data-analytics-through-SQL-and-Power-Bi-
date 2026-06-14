CREATE DATABASE commodities_supply;
USE commodities_supply;

USE commodities_supply;


#COMMODITIES 

#Q1: Common commodities between Top 10 costliest of 2019 and 2020

WITH top10_2019 AS (
    SELECT ci.Commodity
    FROM price_detail pd
    JOIN commodities_info ci ON pd.Commodity_Id = ci.Id
    WHERE STR_TO_DATE(pd.Date, '%d-%m-%Y') BETWEEN '2019-01-01' AND '2019-12-31'
    GROUP BY ci.Commodity
    ORDER BY AVG(pd.Retail_Price) DESC
    LIMIT 10
),
top10_2020 AS (
    SELECT ci.Commodity
    FROM price_detail pd
    JOIN commodities_info ci ON pd.Commodity_Id = ci.Id
    WHERE STR_TO_DATE(pd.Date, '%d-%m-%Y') BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY ci.Commodity
    ORDER BY AVG(pd.Retail_Price) DESC
    LIMIT 10
)
SELECT t1.Commodity
FROM top10_2019 t1
INNER JOIN top10_2020 t2 ON t1.Commodity = t2.Commodity;

#Q2: Max price difference for Jun 2020

SELECT 
    ci.Commodity,
    MAX(pd.Retail_Price) - MIN(pd.Retail_Price) AS Price_Difference
FROM price_detail pd
JOIN commodities_info ci ON pd.Commodity_Id = ci.Id
WHERE STR_TO_DATE(pd.Date, '%d-%m-%Y') BETWEEN '2020-06-01' AND '2020-06-30'
GROUP BY ci.Commodity
ORDER BY Price_Difference DESC
LIMIT 3;


#Q3: Commodities by number of varieties

-- Q3: Commodities by number of varieties
SELECT 
    Commodity,
    COUNT(DISTINCT Variety) AS Variety_Count
FROM commodities_info
GROUP BY Commodity
ORDER BY Variety_Count DESC
LIMIT 3;

# Q4: State with least data points → top commodity
WITH least_state AS (
    SELECT r.State
    FROM price_detail pd
    JOIN region r ON pd.Region_Id = r.Id
    GROUP BY r.State
    ORDER BY COUNT(pd.Id) ASC
    LIMIT 1
)
SELECT ci.Commodity, COUNT(pd.Id) AS Data_Points
FROM price_detail pd
JOIN region r ON pd.Region_Id = r.Id
JOIN commodities_info ci ON pd.Commodity_Id = ci.Id
WHERE r.State = (SELECT State FROM least_state)
GROUP BY ci.Commodity
ORDER BY Data_Points DESC
LIMIT 1;

#Q5: Highest price variation Jan 2019 → Dec 2020

-- Q5: Highest price variation Jan 2019 → Dec 2020
WITH jan2019 AS (
    SELECT Region_Id, Commodity_Id, AVG(Retail_Price) AS Start_Price
    FROM price_detail
    WHERE STR_TO_DATE(Date, '%d-%m-%Y') BETWEEN '2019-01-01' AND '2019-01-31'
    GROUP BY Region_Id, Commodity_Id
),
dec2020 AS (
    SELECT Region_Id, Commodity_Id, AVG(Retail_Price) AS End_Price
    FROM price_detail
    WHERE STR_TO_DATE(Date, '%d-%m-%Y') BETWEEN '2020-12-01' AND '2020-12-31'
    GROUP BY Region_Id, Commodity_Id
)
SELECT 
    ci.Commodity,
    r.City,
    j.Start_Price,
    d.End_Price,
    ABS(d.End_Price - j.Start_Price) AS Variation_Absolute,
    ROUND(ABS((d.End_Price - j.Start_Price) / j.Start_Price) * 100, 2) AS Variation_Percentage
FROM jan2019 j
INNER JOIN dec2020 d ON j.Region_Id = d.Region_Id AND j.Commodity_Id = d.Commodity_Id
JOIN region r ON j.Region_Id = r.Id
JOIN commodities_info ci ON j.Commodity_Id = ci.Id
ORDER BY Variation_Percentage DESC
LIMIT 2;

#Supply Chain

#Q1: Orders by transaction type

-- Supply Chain Q1: Orders by transaction type
SELECT 
    Type AS Transaction_Type,
    COUNT(Order_Id) AS Orders
FROM orders
WHERE Order_City NOT IN ('Sangli', 'Srinagar')
  AND Order_Status != 'SUSPECTED_FRAUD'
GROUP BY Type
ORDER BY Orders DESC;

#Q2: Top 3 customers by completed orders

-- Supply Chain Q2: Top 3 customers by completed orders
SELECT 
    c.Customer_Id,
    c.First_Name AS Customer_First_Name,
    c.City AS Customer_City,
    c.State AS Customer_State,
    COUNT(o.Order_Id) AS Completed_Orders,
    SUM(oi.Sales) AS Total_Sales
FROM orders o
JOIN orders_items oi ON o.Order_Id = oi.Order_Id
JOIN customer_info c ON o.Customer_Id = c.Customer_Id
WHERE o.Order_Status = 'COMPLETE'
GROUP BY c.Customer_Id, c.First_Name, c.City, c.State
ORDER BY Completed_Orders DESC
LIMIT 3;


#Q3: Order count by Shipping Mode & Department

WITH eligible_depts AS (
    SELECT d.Department_Name
    FROM orders o
    JOIN orders_items oi ON o.Order_Id = oi.Order_Id
    JOIN product_info p ON oi.Item_Id = p.Product_Id
    JOIN department d ON p.Department_Id = d.Department_Id
    WHERE o.Order_Status IN ('COMPLETE', 'CLOSED')
    GROUP BY d.Department_Name
    HAVING COUNT(o.Order_Id) >= 40
)
SELECT 
    o.Shipping_Mode,
    d.Department_Name,
    COUNT(o.Order_Id) AS Orders
FROM orders o
JOIN orders_items oi ON o.Order_Id = oi.Order_Id
JOIN product_info p ON oi.Item_Id = p.Product_Id
JOIN department d ON p.Department_Id = d.Department_Id
WHERE d.Department_Name IN (SELECT Department_Name FROM eligible_depts)
GROUP BY o.Shipping_Mode, d.Department_Name
ORDER BY d.Department_Name, Orders DESC;

#Q4: Shipment compliance + most delayed shipping mode

-- Part 1: Shipment compliance classification
SELECT 
    Order_Id,
    CASE 
        WHEN Order_Status IN ('SUSPECTED_FRAUD', 'CANCELED') THEN 'Cancelled shipment'
        WHEN Real_Shipping_Days < Scheduled_Shipping_Days THEN 'Within schedule'
        WHEN Real_Shipping_Days = Scheduled_Shipping_Days THEN 'On time'
        WHEN Real_Shipping_Days - Scheduled_Shipping_Days <= 2 THEN 'Upto 2 days of delay'
        ELSE 'Beyond 2 days of delay'
    END AS Shipment_Compliance
FROM orders;

-- Part 2: Shipping mode with greatest number of delayed orders
SELECT 
    Shipping_Mode,
    COUNT(Order_Id) AS Delayed_Orders
FROM orders
WHERE Order_Status NOT IN ('SUSPECTED_FRAUD', 'CANCELED')
  AND Real_Shipping_Days > Scheduled_Shipping_Days
GROUP BY Shipping_Mode
ORDER BY Delayed_Orders DESC
LIMIT 1;

#Q5: States ranked by cancellation %

WITH cancelled AS (
    SELECT 
        Order_State, 
        COUNT(Order_Id) AS Cancelled_Orders
    FROM orders
    WHERE Order_Status IN ('CANCELED', 'SUSPECTED_FRAUD')
    GROUP BY Order_State
),
total AS (
    SELECT 
        Order_State, 
        COUNT(Order_Id) AS Total_Orders
    FROM orders
    GROUP BY Order_State
)
SELECT 
    t.Order_State,
    ROUND((c.Cancelled_Orders / t.Total_Orders) * 100, 2) AS Cancellation_Percentage
FROM total t
LEFT JOIN cancelled c ON t.Order_State = c.Order_State
ORDER BY Cancellation_Percentage DESC;



