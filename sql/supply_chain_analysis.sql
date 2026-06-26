-- =====================================
-- PHARMACEUTICAL SUPPLY CHAIN ANALYSIS
-- =====================================

-- Author: Stefano La Rosa
-- Tool: BigQuery SQL
-- Objective:
-- Analyze pharmaceutical supply chain delivery performance
-- and identify operational bottlenecks.

-- =====================================
-- 1. DATASET OVERVIEW
-- =====================================

SELECT
  COUNT(*) AS total_shipments,
  COUNT(DISTINCT Vendor) AS total_vendors,
  COUNT(DISTINCT Country) AS total_countries,
  COUNT(DISTINCT Shipment_Mode) AS shipment_modes
FROM `pharma-supply-chain-analysis.supply_chain_data.shipments_analysis`;

-- =====================================
-- 2. DELIVERY PERFORMANCE
-- =====================================

SELECT
  CASE
    WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) < 0 THEN 'Early'
    WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) = 0 THEN 'On Time'
    ELSE 'Late'
  END AS delivery_status,
  COUNT(*) AS shipments
FROM `pharma-supply-chain-analysis.supply_chain_data.shipments_analysis`
GROUP BY delivery_status;

-- =====================================
-- 3. VENDOR ANALYSIS
-- =====================================

SELECT
  Vendor,
  COUNT(*) AS total_shipments,
  SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) AS late_shipments,
  ROUND(SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_percentage
FROM `pharma-supply-chain-analysis.supply_chain_data.shipments_analysis`
GROUP BY Vendor;

-- =====================================
-- 4. SHIPMENT MODE ANALYSIS
-- =====================================

SELECT
  Shipment_Mode,
  COUNT(*) AS total_shipments,
  SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) AS late_shipments,
  ROUND(SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_percentage
FROM `pharma-supply-chain-analysis.supply_chain_data.shipments_analysis`
GROUP BY Shipment_Mode;

-- =====================================
-- 5. COUNTRY ANALYSIS
-- =====================================

SELECT
  Country,
  COUNT(*) AS total_shipments,
  SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) AS late_shipments,
  ROUND(SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_percentage
FROM `pharma-supply-chain-analysis.supply_chain_data.shipments_analysis`
GROUP BY Country;

-- =====================================
-- 6. PRODUCT GROUP ANALYSIS
-- =====================================

SELECT
  `Product Group`,
  COUNT(*) AS total_shipments,
  SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) AS late_shipments,
  ROUND(SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_percentage
FROM `pharma-supply-chain-analysis.supply_chain_data.shipments_analysis`
GROUP BY `Product Group`;

-- =====================================
-- 7. YEAR TREND ANALYSIS
-- =====================================

SELECT
  EXTRACT(YEAR FROM `Scheduled Delivery Date`) AS delivery_year,
  COUNT(*) AS total_shipments,
  SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) AS late_shipments,
  ROUND(SUM(CASE WHEN DATE_DIFF(`Delivered to Client Date`, `Scheduled Delivery Date`, DAY) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_percentage
FROM `pharma-supply-chain-analysis.supply_chain_data.shipments_analysis`
GROUP BY delivery_year
ORDER BY delivery_year;