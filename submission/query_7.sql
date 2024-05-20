-- Monthly host metric values table
CREATE TABLE host_activity_reduced (
  host VARCHAR,
  metric_name VARCHAR,
  metric_array ARRAY(INTEGER),
  month_start VARCHAR
)
WITH (
  partitioning = ARRAY['metric_name', 'month_start']
)