-- Add is_start_time_edited column to daily_logs
ALTER TABLE daily_logs 
ADD COLUMN is_start_time_edited BOOLEAN DEFAULT FALSE;
