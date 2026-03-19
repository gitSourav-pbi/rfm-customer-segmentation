# RFM Customer Segmentation Analysis

## Business Problem
Segment customers based on purchasing behaviour to identify 
Champions, Loyal VIPs, At Risk, and Lost customers for targeted 
marketing and retention strategies.

## Dataset
- 12 monthly sales files (January to December 2025)
- 994 total records, 287 unique customers
- Columns: OrderID, CustomerID, OrderDate, ProductType, OrderValue
- Database: MySQL hosted on FreeSQLdatabase.com

## Methodology — RFM Analysis
- **Recency** — Days since last purchase (lower = better)
- **Frequency** — Number of orders placed (higher = better)  
- **Monetary** — Total spend value (higher = better)

## SQL Approach
4 step MySQL implementation:
1. View — rfm_base: Calculate R, F, M metrics per customer
2. Table — rfm_scores: Score each metric using NTILE(10) — scores 1 to 10
3. View — rfm_total: Sum R+F+M scores for total RFM score (max 30)
4. Table — rfm_segments: CASE WHEN segmentation into 8 categories

## Customer Segments
| Segment | Score Range |
|---------|-------------|
| Champion | 28-30 |
| Loyal VIP | 24-27 |
| Potential Loyalist | 20-23 |
| Promising | 16-19 |
| Engaged | 12-15 |
| Requires Attention | 8-11 |
| At Risk | 4-7 |
| Lost | Below 4 |

## Tools Used
- MySQL Workbench
- FreeSQLdatabase.com (MySQL cloud hosting)
- GitHub

## Repository Structure
- analysis_queries.sql — All SQL queries
- README.md — Project documentation
