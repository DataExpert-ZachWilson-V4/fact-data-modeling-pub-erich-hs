-- Cumulative dayly hosts activity table
CREATE TABLE hosts_cumulated (
    host VARCHAR,
    host_activity_datelist ARRAY(DATE),
    date DATE
)
WITH (
  partitioning = ARRAY['date']
)