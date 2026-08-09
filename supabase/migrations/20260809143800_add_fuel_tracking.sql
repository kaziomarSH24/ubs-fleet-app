-- Add fuel tracking columns to daily_logs
ALTER TABLE daily_logs 
ADD COLUMN cng_km NUMERIC DEFAULT 0,
ADD COLUMN lpg_km NUMERIC DEFAULT 0,
ADD COLUMN octane_km NUMERIC DEFAULT 0;
