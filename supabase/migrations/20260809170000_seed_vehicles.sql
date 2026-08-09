-- Seeder for Vehicles Table
-- This script adds a few dummy vehicles and assigns the first one to an existing driver.

DO $$ 
DECLARE
  rabbi_driver_id UUID;
BEGIN
  -- Get the driver with employee_id 'DRV-1001' (Your ID)
  SELECT id INTO rabbi_driver_id FROM profiles WHERE employee_id = 'DRV-1001' LIMIT 1;

  -- Insert dummy vehicles
  INSERT INTO vehicles (model, plate_number, fuel_type, current_driver_id)
  VALUES 
    ('Toyota HiAce 2018', 'Dhaka Metro-Cha 11-2233', 'CNG + Octane', rabbi_driver_id),
    ('Nissan Urvan 2020', 'Dhaka Metro-Gha 15-4455', 'Diesel', NULL),
    ('Toyota Noah 2019', 'Dhaka Metro-Kha 12-8899', 'Octane', NULL)
  ON CONFLICT (plate_number) DO UPDATE 
  SET current_driver_id = EXCLUDED.current_driver_id;

END $$;
