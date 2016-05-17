SELECT
  id,
  unique_carrier,
  flight_num,
  tail_num,
  origin,
  dest,
  LEAD(origin) OVER(PARTITION BY tail_num ORDER BY day_of_month, dep_time) AS next_origin,
  to_date(year || '-' || month || '-' || day_of_month, 'YYYY-MM-DD') AS dep_date,
  dep_time,
  arr_time,
  actual_elapsed_time,
  dep_delay,
  arr_delay,
  diverted
FROM departures
WHERE year = 1999
  AND month = 6
  AND cancelled = false;
