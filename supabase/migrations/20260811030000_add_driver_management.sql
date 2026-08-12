-- 1. Modify `profiles`
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS client_id UUID;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- 2. Create Sequence for employee_id
CREATE SEQUENCE IF NOT EXISTS driver_employee_id_seq START 1001;

-- 3. Create driver_documents
CREATE TABLE IF NOT EXISTS driver_documents (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  driver_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  doc_type TEXT NOT NULL,
  file_url TEXT NOT NULL,
  expiry_date DATE,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Enable pgcrypto for UUID and password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 5. Create an RPC to securely create a Driver Account
CREATE OR REPLACE FUNCTION admin_create_driver(
  driver_password TEXT,
  driver_phone TEXT,
  driver_full_name TEXT,
  assign_client_id UUID DEFAULT NULL
) RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  new_user_id UUID;
  new_employee_id TEXT;
  dummy_email TEXT;
BEGIN
  new_user_id := gen_random_uuid();
  new_employee_id := 'DRV-' || nextval('driver_employee_id_seq');
  dummy_email := lower(new_employee_id) || '@ubsfleet.com';

  -- Insert into auth.users
  INSERT INTO auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, 
    created_at, updated_at, raw_app_meta_data, raw_user_meta_data, phone
  ) VALUES (
    '00000000-0000-0000-0000-000000000000', new_user_id, 'authenticated', 'authenticated', 
    dummy_email, crypt(driver_password, gen_salt('bf')), NOW(), 
    NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{}', driver_phone
  );

  -- Insert into auth.identities
  INSERT INTO auth.identities (
    provider_id, id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at
  ) VALUES (
    new_user_id::text, gen_random_uuid(), new_user_id, format('{"sub":"%s","email":"%s"}', new_user_id, dummy_email)::jsonb, 
    'email', NOW(), NOW(), NOW()
  );

  -- Insert into public.profiles
  INSERT INTO public.profiles (
    id, full_name, employee_id, phone_number, role, client_id, is_active
  ) VALUES (
    new_user_id, driver_full_name, new_employee_id, driver_phone, 'driver', assign_client_id, true
  );

  RETURN new_employee_id;
END;
$$;
