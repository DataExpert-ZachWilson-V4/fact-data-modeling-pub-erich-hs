-- Cumulative daily active users table per device
CREATE TABLE user_devices_cumulated (
    user_id BIGINT,
    browser_type VARCHAR,
    dates_active ARRAY(DATE),
    date DATE
)
WITH (
  partitioning = ARRAY['date', 'browser_type']
)