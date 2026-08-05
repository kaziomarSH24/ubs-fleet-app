-- Migration: 001_initial_schema
-- Date: 2026-08-05
-- Description: Initial database schema for Fleet Management App

-- 1. Profiles Table (Extended user data)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT NOT NULL,
  employee_id TEXT UNIQUE,
  phone_number TEXT UNIQUE,
  role TEXT DEFAULT 'driver', -- 'driver' or 'admin'
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Vehicles Table
CREATE TABLE vehicles (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  model TEXT NOT NULL,
  plate_number TEXT UNIQUE NOT NULL,
  fuel_type TEXT NOT NULL,
  current_driver_id UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Daily Logs Table (For Duty Start/End)
CREATE TABLE daily_logs (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  driver_id UUID REFERENCES profiles(id) NOT NULL,
  vehicle_id UUID REFERENCES vehicles(id),
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ,
  start_km NUMERIC NOT NULL,
  end_km NUMERIC,
  total_km NUMERIC GENERATED ALWAYS AS (end_km - start_km) STORED,
  status TEXT DEFAULT 'ongoing', -- 'ongoing' or 'completed'
  night_stay BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Expenses Table (Toll & Parking)
CREATE TABLE expenses (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  log_id UUID REFERENCES daily_logs(id) ON DELETE CASCADE,
  driver_id UUID REFERENCES profiles(id) NOT NULL,
  expense_type TEXT NOT NULL, -- 'toll' or 'parking'
  amount NUMERIC NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
