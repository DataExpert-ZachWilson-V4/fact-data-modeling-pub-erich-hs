-- This query incrementally populate the `host_activity_reduced` table with
-- data from the source `daily_web_metrics` table.
WITH
    yesterday AS (
        SELECT * FROM host_activity_reduced
        WHERE month_start = '2023-08-01'
    ),
    today AS (
        SELECT * FROM erich.daily_web_metrics
        WHERE DATE = date('2023-08-01')
    )
SELECT
    COALESCE(t.host, y.host) AS host,
    COALESCE(t.metric_name, y.metric_name) AS metric_name,
    COALESCE(
        y.metric_array,
        -- Repeat a null array for the number of days between the start of 
        -- the month and the current date.
        REPEAT(
            NULL,
            CAST(
                DATE_DIFF('day', DATE('2023-08-01'), t.date) AS INTEGER
            )
        )
    ) || ARRAY[t.metric_value] AS metric_array,
    '2023-08-01' AS month_start
FROM
    today t
    FULL OUTER JOIN yesterday y ON t.host = y.host
    AND t.metric_name = y.metric_name