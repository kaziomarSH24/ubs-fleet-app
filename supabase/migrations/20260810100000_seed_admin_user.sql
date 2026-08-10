-- Seeder to create a new Admin User
-- Email: adm-1001@ubsfleet.com (Used internally by Supabase Auth)
-- Phone Number (For App Login): 01811223344
-- PIN: 123456
-- Role: admin

DO $$ 
DECLARE
  new_admin_id UUID := gen_random_uuid();
BEGIN
  -- 1. Insert into auth.users (Supabase Authentication Table)
  -- The password '123456' is securely hashed using pgcrypto
  INSERT INTO auth.users (
    id, instance_id, email, encrypted_password, email_confirmed_at, 
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at, 
    role, confirmation_token, email_change, email_change_token_new, recovery_token
  )
  VALUES (
    new_admin_id, 
    '00000000-0000-0000-0000-000000000000', 
    'adm-1001@ubsfleet.com', 
    crypt('123456', gen_salt('bf')), 
    now(), 
    '{"provider":"email","providers":["email"]}', 
    '{}', 
    now(), 
    now(), 
    'authenticated', 
    '', 
    '', 
    '', 
    ''
  );

  -- 2. Insert into auth.identities (Required by Supabase for login via email/password)
  INSERT INTO auth.identities (provider_id, id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
  VALUES (
    new_admin_id::text,
    gen_random_uuid(), 
    new_admin_id, 
    format('{"sub":"%s","email":"%s"}', new_admin_id::text, 'adm-1001@ubsfleet.com')::jsonb, 
    'email', 
    now(), 
    now(), 
    now()
  );

  -- 3. Insert into public.profiles (Our custom app profiles table)
  INSERT INTO public.profiles (id, full_name, phone_number, employee_id, role)
  VALUES (
    new_admin_id, 
    'System Admin', 
    '01811223344', 
    'ADM-1001', 
    'admin'
  );
END $$;
