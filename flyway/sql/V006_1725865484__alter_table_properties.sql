ALTER TABLE qmc_silver.stg_customer SET TBLPROPERTIES ('delta.enableDeletionVectors' = false);
ALTER TABLE qmc_silver.stg_customer SET TBLPROPERTIES(this.is.my.key = 14, 'this.is.my.key2' = false);
ALTER TABLE qmc_silver.stg_order CLUSTER BY (order_id);
ALTER TABLE qmc_silver.fact_order ENABLE PREDICTIVE OPTIMIZATION;