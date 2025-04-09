CREATE OR REFRESH STREAMING TABLE qmc_gold.mart_customer
AS
SELECT *
FROM STREAM(qmc_silver.stg_customer)
WHERE customer_id IS NOT NULL
;

CREATE OR REFRESH STREAMING TABLE qmc_gold.mart_order
AS
SELECT *
FROM STREAM(qmc_silver.stg_order)
WHERE order_id IS NOT NULL
;