--VIEWING ENTIRE TABLE :
SELECT * FROM GroceryData 

--TO VIEW HOW MANY ROWS :
SELECT COUNT(*) AS NO_OF_ROWS FROM GroceryData

--CLEANING THE DATA :
UPDATE GroceryData
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT DISTINCT (Item_Fat_Content) FROM GroceryData

--KPI'S REQUIREMENT :
--1. TOTAL SALES
SELECT CAST(SUM(Total_Sales) /1000000 AS DECIMAL (10,2)) AS Total_Sales_In_Millions FROM GroceryData

--2. AVERAGE SALES 
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS Average_Sales FROM GroceryData

--3. NO OF ITEMS :
SELECT COUNT(*) AS NO_OF_ITEMS FROM GroceryData

--4. AVERAGE SALES :
SELECT CAST(AVG(Rating) AS DECIMAL (10,2)) AS Ave_Rating FROM GroceryData

--BUSINESS REQUIREMENT :
--1. TOTAL SALES BY FAT CONTENT 
SELECT Item_Fat_Content , CAST(SUM(Total_Sales) /1000 AS DECIMAL(10,2)) AS Total_sales_Thousand FROM GroceryData
GROUP BY Item_Fat_Content
ORDER BY Total_sales_Thousand DESC

--2. TOTAL SALES BY ITEM TYPE :
SELECT TOP 5 Item_Type , CAST(SUM(Total_Sales)/1000 AS DECIMAL (10,2)) AS Total_sales_By_Item FROM GroceryData
GROUP BY Item_Type
ORDER BY Total_sales_By_Item DESC

--3. Fat Content By Outlet for Total Sales
SELECT Outlet_Location_Type,
		ISNULL([Low Fat], 0) AS Low_Fat,
		ISNULL([Regular], 0) AS Regular
FROM
(
    SELECT Outlet_Location_Type, Item_Fat_Content,
	       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
	FROM GroceryData
	GROUP BY Outlet_Location_Type,Item_Fat_Content
) AS SourceTable
PIVOT
(
   SUM(Total_Sales)
   FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type
  
      --(OR)

SELECT Outlet_Location_Type, Item_Fat_Content,
	       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM GroceryData
GROUP BY Outlet_Location_Type,Item_Fat_Content

--4. TOTAL SALES BY OUTLET ESTABLISHMENT :
SELECT Outlet_Establishment_Year , CAST(SUM(Total_Sales) AS DECIMAL (10,2)) AS Total_Sales FROM GroceryData
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC

--5. PERCENTAGE OF SALES BY OUTLET SIZE :
SELECT Outlet_Size,CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
             CAST(SUM(Total_Sales)*100.0 / SUM(SUM(Total_Sales)) OVER() AS DECIMAL(10,2)) AS Sales_Percentage
FROM GroceryData
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC

--SALES BY OUTLET LOCATION :
SELECT Outlet_Location_Type , CAST(SUM(Total_Sales) AS DECIMAL (10,2)) AS Total_Sales FROM GroceryData
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales ASC

--ALL METRICS BY OUTLET TYPE :
SELECT Outlet_Type , CAST(SUM(Total_Sales) AS DECIMAL (10,2)) AS Total_Sales FROM GroceryData
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC
