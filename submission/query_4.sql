-- Query to convert the history of user devices into binary format
WITH today AS (
  SELECT
    *
  FROM user_devices_cumulated
  WHERE date = DATE('2021-01-07')
),
date_list AS (
  SELECT
    user_id,
    browser_type,
    -- Sum powers of 2 for each day the user was active
    CAST(
      SUM(
        CASE
          WHEN CONTAINS(dates_active, sequence_date) THEN POW(2, 31 - DATE_DIFF('day', sequence_date, date))
          ELSE 0
        END
      ) AS BIGINT
    ) AS history_int
  FROM today
  -- Unnest the sequence of dates from the first day to the last day
  CROSS JOIN UNNEST(
    SEQUENCE(DATE('2021-01-01'), DATE('2021-01-07'))
  ) AS t(sequence_date)
  GROUP BY user_id, browser_type
)
SELECT
  user_id,
  browser_type,
  -- Convert the integer history to base 2
  TO_BASE(history_int, 2) AS history_in_binary
FROM
  date_list