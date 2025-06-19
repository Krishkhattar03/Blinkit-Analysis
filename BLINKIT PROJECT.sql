DROP TABLE IF EXISTS blinkit;


CREATE  TABLE blinkit (
    item_fat_content VARCHAR(20),
    item_identifier VARCHAR(10),
    item_type VARCHAR(50),
    outlet_establishment_year INT,
    outlet_identifier VARCHAR(10),
    outlet_location_type VARCHAR(20),
    outlet_size VARCHAR(10),
    outlet_type VARCHAR(30),
    item_visibility NUMERIC(10, 8),
    item_weight NUMERIC(5, 2),
    total_sales NUMERIC(10, 4),
    rating DECIMAL(4,2)
);

SELECT * FROM blinkit;

UPDATE blinkit
SET item_fat_content = 
    CASE 
        WHEN item_fat_content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN item_fat_content = 'reg' THEN 'Regular'
        ELSE item_fat_content
END;
--## KPI

--1.Total Sales 
SELECT CAST(SUM(total_sales) / 1000000.0 AS DECIMAL(10,2)) AS Total_Sales_Million
FROM blinkit;
--2 Avg  Sales
SELECT CAST(AVG(Total_Sales)AS INT) AS Total_Sales_Million
FROM blinkit;
--3.NO OF ITEMS 
SELECT COUNT (*)  AS NO_OF_ITEMS FROM blinkit;
--4.AVERAGE RATINGS 
SELECT CAST(AVG(rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM blinkit;
--5.Total Sales By fat Content 
SELECT item_fat_content, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY item_fat_content;
--6. Total Sales By item type 
SELECT item_type, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY item_type
ORDER BY total_sales DESC;
--7.Fat Content by Outlet for Total Sales

SELECT outlet_location_type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT outlet_location_type, item_fat_content, 
           CAST(SUM(total_sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit
    GROUP BY outlet_location_type, item_fat_content
) AS SourceTable
PIVOT 
(
    SUM(total_sales) 
    FOR item_fat_content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY outlet_location_type;
--8.Total Sales By outlet Establishment 
SELECT outlet_establishment_year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY outlet_establishment_year
ORDER BY outlet_establishment_year;

--9.Percentage of Sales by Outlet Size
    SELECT 
        outlet_size,
        CAST(SUM(total_sales) AS DECIMAL(10, 2)) AS total_sales,
        CAST((SUM(total_sales) * 100.0 / SUM(SUM(total_sales)) OVER ()) AS DECIMAL(10, 2)) AS sales_percentage
    FROM blinkit
    GROUP BY outlet_size
    ORDER BY total_sales DESC;

--10 Sales by Outlet Location
SELECT outlet_location_type, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY outlet_location_type
ORDER BY total_sales DESC;

--11.All Metrics By Outlet Type 
SELECT outlet_type, 
CAST(SUM(total_sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(total_sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(item_visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit
GROUP BY outlet_type
ORDER BY total_sales DESC;





