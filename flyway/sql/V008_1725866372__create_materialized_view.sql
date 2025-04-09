CREATE MATERIALIZED VIEW qmc_gold.order_trend
AS
SELECT
  order_date, sum(total_amount) AS sum_of_sales
FROM
  qmc_gold.mart_order
GROUP BY
  order_date
;