-- Add rent_amount to vehicles
ALTER TABLE vehicles 
ADD COLUMN IF NOT EXISTS rent_amount NUMERIC DEFAULT 38000.00;

-- Add vehicle_rent_amount and advance_amount to monthly_bills
ALTER TABLE monthly_bills
ADD COLUMN IF NOT EXISTS vehicle_rent_amount NUMERIC DEFAULT 0,
ADD COLUMN IF NOT EXISTS advance_amount NUMERIC DEFAULT 0;
