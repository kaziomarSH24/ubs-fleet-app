-- Migration: Add Driver Rates and Monthly Bills tables
-- 1. Add rate columns to profiles table with common default values based on reference
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS octane_rate_per_km NUMERIC DEFAULT 14.00,
ADD COLUMN IF NOT EXISTS cng_rate_per_km NUMERIC DEFAULT 8.50,
ADD COLUMN IF NOT EXISTS lpg_rate_per_km NUMERIC DEFAULT 12.50,
ADD COLUMN IF NOT EXISTS overtime_rate_per_hour NUMERIC DEFAULT 40.00,
ADD COLUMN IF NOT EXISTS night_stay_rate NUMERIC DEFAULT 750.00,
ADD COLUMN IF NOT EXISTS lunch_rate_per_day NUMERIC DEFAULT 70.00,
ADD COLUMN IF NOT EXISTS starting_fuel_rate NUMERIC DEFAULT 1250.00,
ADD COLUMN IF NOT EXISTS replace_day_rate NUMERIC DEFAULT 2100.00,
ADD COLUMN IF NOT EXISTS absent_day_rate NUMERIC DEFAULT 4100.00;

-- 2. Create monthly_bills table
CREATE TABLE IF NOT EXISTS monthly_bills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    driver_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    month_year VARCHAR(7) NOT NULL, -- e.g., "2026-08"
    
    -- Claimed Data (Auto-calculated from app)
    claimed_cng_km NUMERIC DEFAULT 0,
    claimed_octane_km NUMERIC DEFAULT 0,
    claimed_lpg_km NUMERIC DEFAULT 0,
    claimed_overtime_hours NUMERIC DEFAULT 0,
    claimed_night_stays INT DEFAULT 0,
    claimed_working_days INT DEFAULT 0,
    claimed_toll_parking NUMERIC DEFAULT 0,
    
    -- Actual/Verified Data (Admin adjusts if needed)
    actual_cng_km NUMERIC DEFAULT 0,
    actual_octane_km NUMERIC DEFAULT 0,
    actual_lpg_km NUMERIC DEFAULT 0,
    actual_overtime_hours NUMERIC DEFAULT 0,
    actual_night_stays INT DEFAULT 0,
    actual_working_days INT DEFAULT 0,
    actual_toll_parking NUMERIC DEFAULT 0,
    actual_replace_days INT DEFAULT 0,
    actual_absent_days INT DEFAULT 0,
    
    -- Rates Snapshot (Driver's rate at the time of bill generation)
    cng_rate NUMERIC DEFAULT 0,
    octane_rate NUMERIC DEFAULT 0,
    lpg_rate NUMERIC DEFAULT 0,
    overtime_rate NUMERIC DEFAULT 0,
    night_stay_rate NUMERIC DEFAULT 0,
    lunch_rate NUMERIC DEFAULT 0,
    starting_fuel NUMERIC DEFAULT 0,
    replace_day_rate NUMERIC DEFAULT 0,
    absent_day_rate NUMERIC DEFAULT 0,
    
    -- Final Calculation
    total_bill_amount NUMERIC DEFAULT 0,
    
    status VARCHAR(20) DEFAULT 'Verified',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(driver_id, month_year)
);

-- Enable RLS and setup basic policies if needed
ALTER TABLE monthly_bills ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can perform all operations on monthly_bills" ON monthly_bills
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
        )
    );

CREATE POLICY "Drivers can view their own monthly bills" ON monthly_bills
    FOR SELECT USING (driver_id = auth.uid());
