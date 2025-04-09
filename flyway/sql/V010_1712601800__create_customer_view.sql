-- Create a customer view in the gold schema
CREATE OR REPLACE VIEW qmc_gold.customer_summary_view AS
SELECT 
  c.customer_id,
  c.customer_name,
  c.city,
  c.country,
  COUNT(o.order_id) AS total_orders,
  SUM(o.total_amount) AS total_spend
FROM qmc_silver.stg_customer c
LEFT JOIN qmc_silver.stg_order o ON c.customer_name = o.customer_name
GROUP BY c.customer_id, c.customer_name, c.city, c.country;