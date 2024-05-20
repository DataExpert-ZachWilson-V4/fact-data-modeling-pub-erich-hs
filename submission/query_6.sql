-- Yesterday's CTE from `hosts_cumulated`
WITH yesterday AS (
  SELECT
    *
  FROM hosts_cumulated
  WHERE date = DATE('2021-01-01')
),
-- Today's CTE from the source table `bootcamp.web_events`
today AS (
  SELECT
    host,
    CAST(date_trunc('day', event_time) AS DATE) AS event_date,
    COUNT(1)
  FROM
    bootcamp.web_events
  WHERE CAST(date_trunc('day', event_time) AS DATE) = DATE('2021-01-02')
  GROUP BY
    host, CAST(date_trunc('day', event_time) AS DATE)
)
SELECT
  COALESCE(t.host, y.host) AS host,
  CASE WHEN
    -- When the host is in yesterday's table, concatenate today's host activity date
    y.host_activity_datelist IS NOT NULL THEN ARRAY[t.event_date] || y.host_activity_datelist
    -- When the host is not in yesterday's table, return today's host activity date
    ELSE ARRAY[t.event_date]
  END AS host_activity_datelist,
  DATE('2021-01-02') AS date
FROM today t
  FULL OUTER JOIN yesterday y ON t.host = y.host