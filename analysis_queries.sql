-- RFM Customer Segmentation Analysis
-- Databse: MySQL
-- Dataset: 12 Months Sales Data (2025), 994 Records, 287 Unique customers

-- Table: sales_2025
-- Columns: OrderID, CustomerID, OrderDate, ProductType, OrderValue 


-- RFM Base Metrics
CREATE OR REPLACE VIEW rfm_base 
AS
SELECT
	customerid,
    max(orderdate) as last_order_date,
    datediff('2025-12-31', max(orderdate)) as recency,
    count(*) as frequency,
    sum(ordervalue) as monetary
from sales_2025
Group by CustomerID;

-- RFM Scores Using NTILE(10)
CREATE OR REPLACE VIEW rfm_scores
AS
SELECT customer_id,
	last_order_date,
    recency,
    frequency,
    monetary,
	NTILE(10) OVER (Order by recency ASC) As r_score,
    NTILE(10) OVER (Order by frequency DESC) AS f_score,
    NTILE(10) OVER (Order by monetary DESC) AS m_score
FROM rfm_base;

-- Total RFM Score
CREATE OR REPLACE VIEW rfm_total
AS
SELECT customer_id,
	recency,
    frequency,
    monetary,
	r_score,
    f_score,
    m_score,
	(r_score + f_score + m_score) AS rfm_total_score
FROM rfm_scores;

-- Customer Segmentation Using CASE WHEN 

CREATE OR REPLACE TABLE rfm_segments
AS
SELECT  customer_id,
	recency,
    frequency,
    monetary,
	r_score,
    f_score,
    m_score,
	CASE 
		WHEN rfm_total_score >= 28 THEN 'Champion'
        WHEN rfm_total_score >= 24 THEN 'Loyal VIP'
        WHEN rfm_total_score >= 28 THEN 'Potential Loyalist'
        WHEN rfm_total_score >= 28 THEN 'Promising'
        WHEN rfm_total_score >= 28 THEN 'Engaged'
        WHEN rfm_total_score >= 28 THEN 'Requires Attention'
        WHEN rfm_total_score >= 28 THEN 'At Risk'
        ELSE 'LOST'
	END AS rfm_segment
FROM rfm_total
ORDER BY rfm_total_score DESC;

-- Query: Segment Summary

SELECT rfm_segment,
	COUNT(*) AS customer_count
FROM rfm_segments
GROUP BY rfm_segment
ORDER BY customer_count DESC;

-- Query: Average Monetary Value by Segment

SELECT
	rfm_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(monetary), 2) AS avg_monetary_value,
    ROUND(SUM(monetary), 2) AS total_revenue
FROM rfm_segments
GROUP BY rfm_segments
ORDER BY avg_monetary_value DEC;

-- Query: Top 10 Champion Customers by Monetary Value

SELECT 
	CustomerID,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    rfm_total_score,
    rfm_segment
FROM rfm_segments
WHERE rfm_segment='Champion'
ORDER BY monetary DESC
LIMIT 10;