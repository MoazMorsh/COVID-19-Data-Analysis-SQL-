-- Q1. Write a code to check NULL values

--There are "35,865" Rows that are null in latitude column Or/And longitude

SELECT * FROM dbo.[Corona Virus Dataset]
WHERE 
	  province is null or 
	  country_region is null or 
	  latitude is null or
	  longitude is null or 
	  date is null or 
	  confirmed is null or 
	  deaths is null or 
	  recovered is null
;



--Q2. If NULL values are present, update them with zeros for all columns. 

--//All the rows that have null values had been updated and  become zero values//--

UPDATE 
	[Corona Virus Dataset]
SET 
	latitude = isnull (latitude, 0),
	longitude = isnull (longitude, 0)
WHERE 
	  province is null or 
	  country_region is null or 
	  latitude is null or
	  longitude is null or 
	  date is null or 
	  confirmed is null or 
	  deaths is null or 
	  recovered is null



-- Q3. check total number of rows

--//By using count function the total_rows are "78,386" Rows//--

SELECT
	count(*) as Total_Rows 
FROM
	[Corona Virus Dataset] ;



-- Q4. Check what is start_date and end_date

--//By checking the minimum value in (Date) as the Start_Date and also the maximum value in (Date) as the End_Date//-- 
--//The start_date 2020-01-22 and the End_date 2021-06-13//-- 

SELECT
	MIN(date) AS Start_Date,
	MAX(date) AS End_Date
FROM
	[Corona Virus Dataset];



-- Q5. Number of month present in dataset

--//By using the count function for the months to know the total number//--
--//as we defined from the nested query that the 12 for the year 2020 and 6 for the year 2021//--
--//The outer select get the total of the 2 years that is "18 months"

SELECT
    SUM(number_of_months) as total_number_of_months
FROM (
    SELECT
        Year(Date) as Year,
        COUNT(DISTINCT DATEPART(month, Date)) as number_of_months
    FROM
        [Corona Virus Dataset]
    GROUP BY
        Year(Date)
) AS TM;




-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    Year(Date) As year,
    Month(Date) AS Month,
    avg(Confirmed) AS Avg_confirmed_per_month,
    avg(Deaths) AS Avg_deaths_per_month,
    avg(Recovered) AS Avg_recovered_per_month
 FROM 
        [Corona Virus Dataset]
 GROUP BY 
        YEAR([Date]), MONTH([Date]);



-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

--//First convert the date to 120 that is"yyyy-mm" format Then get the max for each one by months 

SELECT 
    CONVERT(varchar(7), [Date], 120) AS Year_Month,
    MAX(Confirmed) AS Most_Frequent_Confirmed,
    MAX(Deaths) AS Most_Frequent_Deaths,
    MAX(Recovered) AS Most_Frequent_Recovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    CONVERT(varchar(7), [Date], 120)
ORDER BY 
    Year_Month;



-- Q8. Find minimum values for confirmed, deaths, recovered per year
--There's zero values but i estimated the zero is null and to get the min. value greater than zero by making a condition//--

--//get the min for each one by year, The output equal 1 for each one and the two years so this is the smallest value//--

SELECT 
    YEAR(Date) AS Year,
    MIN(CASE WHEN Confirmed > 0 THEN Confirmed ELSE NULL END) AS MinConfirmed,
    MIN(CASE WHEN Deaths > 0 THEN Deaths ELSE NULL END) AS MinDeaths,
    MIN(CASE WHEN Recovered > 0 THEN Recovered ELSE NULL END) AS MinRecovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(Date)
ORDER BY 
    Year;



-- Q9. Find maximum values of confirmed, deaths, recovered per year

--//get the max for each one by year, The output equal in respesct 823225, 3752, 1123456 for 2020 and 414188, 7374, 422436 for 2021 //--

SELECT 
    YEAR(Date) AS Year,
    MAX(Confirmed) AS MaxConfirmed,
    MAX(Deaths) AS MaxDeaths,
    MAX(Recovered) AS MaxRecovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(Date)
ORDER BY 
    Year;



-- Q10. The total number of case of confirmed, deaths, recovered each month

--//

SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    SUM(Confirmed) AS TotalConfirmed,
    SUM(Deaths) AS TotalDeaths,
    SUM(Recovered) AS TotalRecovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(Date), MONTH(Date)
ORDER BY 
    Year, Month;



-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

--//using each sum, avg, var, stdev functions respectively//--
--//The output in respect (80121099, 1508, 83792665.414442, 9153.83337266099) for 2020, (88944045, 3521, 309167104.641847, 17583.1483142766) for 2021//--

SELECT
	YEAR(Date) AS Year,
    Sum(Confirmed) AS Total_Confirmed,
    AVG(Confirmed) AS Average_Confirmed,
    VAR(Confirmed) AS Variance_Confirmed,
    STDEV(Confirmed) AS Stdev_Confirmed
FROM
    [Corona Virus Dataset]
GROUP BY
    YEAR(Date)
ORDER BY
    Year;




-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

--//using each sum, avg, var, stdev functions respectively//--
--//The output 18 Rows in respect for first row (190, 0, 4.24857598541809, 2.06120740960683)

SELECT
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    Sum(Deaths) AS Total_Deaths,
    AVG(Deaths) AS Average_Deaths,
    VAR(Deaths) AS Variance_Deaths,
    STDEV(Deaths) AS Stdev_Deaths
FROM
    [Corona Virus Dataset]

GROUP BY
    YEAR(Date), MONTH(Date)
ORDER BY
    Year, Month;



-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

--//The output in respect (50435616, 949, 52650148.2454603, 7256.04218878724) for 2020, (62653932, 2480, 219846243.060147, 14827.2129228708) for 2021//--

SELECT
    YEAR(Date) AS Year,
    Sum(Recovered) AS Total_Recovered,
    AVG(Recovered) AS Average_Recovered,
    VAR(Recovered) AS Variance_Recovered,
    STDEV(Recovered) AS Stdev_Recovered
FROM
      [Corona Virus Dataset]

GROUP BY
    YEAR(Date)
ORDER BY
    Year;



-- Q14. Find Country having highest number of the Confirmed case

--//The highest country is "Turkey" with Confirmed case equal "823225"//--

SELECT Top 1
    Country_Region,
    MAX(Confirmed) AS Highest_Confirmed_Cases
FROM 
      [Corona Virus Dataset]
GROUP BY 
    Country_Region
ORDER BY 
    Highest_Confirmed_Cases DESC;



-- Q15. Find Country having lowest number of the death case

--//The lowest Country is "Afghanistan", with Death case equal "1" But there are many other country with that letter but it's the first alphabetically//--

SELECT Top 1
	Country_Region,
	Deaths AS Lowest_Deaths_Cases
FROM	
	  [Corona Virus Dataset]
WHERE 
	Deaths > 0
ORDER BY
	Lowest_Deaths_Cases asc;



-- Q16. Find top 5 countries having highest recovered case

--//The top 5 countries with there Recovered case respectively are (India,28089649), (Brazil, 15400169), (US , 6303715), (Turkey, 5202251), (Russia, 4745756)//--

SELECT Top 5
    Country_Region,
    SUM(Recovered) AS Total_Recovered
FROM 
   [Corona Virus Dataset]
GROUP BY 
    Country_Region
ORDER BY 
    Total_Recovered DESC;