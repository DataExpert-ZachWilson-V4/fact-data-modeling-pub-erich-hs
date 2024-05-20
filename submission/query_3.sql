-- Query used to populate the table `user_devices_cumulated` with
-- data from the previous day and the new data from the current day.
-- Yesterday's CTE from `user_devices_cumulated`
INSERT INTO user_devices_cumulated
WITH yesterday AS (
    SELECT
        *
    FROM user_devices_cumulated
    WHERE date = DATE('2021-01-01')
),
-- Today's CTE from the source tables `bootcamp.web_events` and `bootcamp.devices`
today AS (
    SELECT
        e.user_id,
        d.browser_type,
        CAST(date_trunc('day', e.event_time) AS DATE) AS event_date,
        COUNT(1) AS event_count
    FROM bootcamp.web_events e
    LEFT JOIN bootcamp.devices d ON e.device_id = d.device_id
    WHERE CAST(date_trunc('day', e.event_time) AS DATE) = DATE('2021-01-02')
    GROUP BY
      e.user_id,
      d.browser_type,
      CAST(date_trunc('day', e.event_time) AS DATE)
)

SELECT
  COALESCE(t.user_id, y.user_id) AS user_id,
  COALESCE(t.browser_type, y.browser_type) AS browser_type,
  CASE WHEN
    -- When a user is present yesterday, concatenate the dates
    y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
    -- When a user is not present yesterday, create a new array
    ELSE ARRAY[t.event_date]
  END AS dates_active,
  DATE('2021-01-02') AS date
FROM today t
FULL OUTER JOIN yesterday y ON t.user_id = y.user_id AND t.browser_type = y.browser_type
LIMIT 100