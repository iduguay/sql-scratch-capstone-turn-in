--TASK #1

-- one for the number of distinct campaigns
SELECT COUNT(DISTINCT utm_campaign) AS 'distinct_campaigns'
FROM page_visits;

-- one for the number of distinct sources
SELECT COUNT(DISTINCT utm_source) AS 'distinct_sources'
FROM page_visits;

-- one to find how they are related
SELECT 
	DISTINCT utm_campaign AS 'campaigns',
  utm_source AS 'sources'
FROM page_visits;

--TASK #2

-- What pages are on the CoolTShirts website?

SELECT DISTINCT page_name AS 'Pages'
FROM page_visits;


--TASK #3

-- How many first touches is each campaign responsible for?
-- Create a temporary table called first_touch to line up the user_id with the timestamp of their first touch
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),

-- Then join together the first_touch table from above with the page-visits table (source and campaign) in another temporary table called ft_attr
ft_attr AS (
SELECT 
	ft.user_id,
  ft.first_touch_at,
  pv.utm_source,
  pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)

-- Finally, we query the temporary table ft_attr to get the count of first touches organized by source and campaign 
SELECT 
	ft_attr.utm_source AS 'Source',
  ft_attr.utm_campaign AS 'Campaign',
  COUNT(*) AS 'Total'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


--TASK #4

-- How many last touches is each campaign responsible for?
-- Create a temporary table called last_touch to line up the user_id with the timestamp of their first touch
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),

-- Then join together the last_touch table from above with the page-visits table (source and campaign) in another temporary table called lt_attr
lt_attr AS (
SELECT 
	lt.user_id,
  lt.last_touch_at,
  pv.utm_source,
  pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)

-- Finally, we query the temporary table ft_attr to get the count of first touches organized by source and campaign 
SELECT 
	lt_attr.utm_source AS 'Source',
  lt_attr.utm_campaign AS 'Campaign',
  COUNT(*) AS 'Total'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

--TASK #5

-- How many visitors make a purchase?

SELECT COUNT(DISTINCT user_id) AS 'Purchasing Customers'
FROM page_visits
WHERE page_name = '4 - purchase';


--TASK #6

-- How many last touches on the purchase page is each campaign responsible for?
-- Added a WHERE clause in the query to limit to only those customers who purchased - i.e. made it to the purchase page of the website
WITH last_touch AS (
	SELECT 
  	user_id,
  	MAX(timestamp) as last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
lt_attr AS (
SELECT 
	lt.user_id,
  lt.last_touch_at,
  pv.utm_source,
  pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
  ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
)
SELECT 
	lt_attr.utm_source AS 'Source',
  lt_attr.utm_campaign AS 'Campaign',
  COUNT(*) AS 'Total'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;