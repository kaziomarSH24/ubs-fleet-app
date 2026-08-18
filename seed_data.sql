DO $$
DECLARE
  uid uuid;
  vid uuid;
  client_id uuid;
BEGIN
  -- Get a default client ID if exists
  SELECT id INTO client_id FROM public.profiles WHERE role = 'client' LIMIT 1;

  -- Driver: Sumon
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1135@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Sumon', '1135', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '42-4670', 'Sedan 2012', 'CNG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 113, 113, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 101, 101, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 84, 84, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 104, 104, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 114, 114, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 80, 80, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 117, 117, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 117, 117, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 104, 104, 0, 5, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 101, 101, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 82, 82, 0, 6, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 104, 104, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 84, 84, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 96, 96, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 113, 113, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 115, 115, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 112, 112, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 102, 102, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 112, 112, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 113, 113, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 85, 85, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 118, 118, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 104, 104, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 90, 90, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 87, 87, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 92, 92, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 99, 99, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 85, 85, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 109, 109, 0, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 2000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 1000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2216, 2216, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2181, 2181, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Saddam
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1136@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Saddam', '1136', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '43-2207', 'Sedan 2012', 'CNG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 86, 86, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 107, 107, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 85, 85, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 110, 110, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 111, 111, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 92, 92, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 81, 81, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 100, 100, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 99, 99, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 118, 118, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 118, 118, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 94, 94, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 113, 113, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 107, 107, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 100, 100, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 99, 99, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 84, 84, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 83, 83, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 113, 113, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 86, 86, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 90, 90, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 118, 118, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 101, 101, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 85, 85, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 99, 99, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 80, 80, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 92, 92, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 112, 112, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 3000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2030, 2030, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2268, 2268, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Rahmatullah
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1137@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Rahmatullah', '1137', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '26-3543', 'Sedan 2012', 'LPG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 109, 0, 109, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 89, 0, 89, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 96, 0, 96, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 108, 0, 108, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 81, 0, 81, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 114, 0, 114, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 83, 0, 83, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 116, 0, 116, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 102, 0, 102, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 104, 0, 104, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 103, 0, 103, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 112, 0, 112, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 83, 0, 83, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 111, 0, 111, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 90, 0, 90, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 88, 0, 88, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 93, 0, 93, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 89, 0, 89, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 89, 0, 89, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 109, 0, 109, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 105, 0, 105, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 110, 0, 110, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 105, 0, 105, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 116, 0, 116, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 83, 0, 83, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 84, 0, 84, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 88, 0, 88, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 99, 0, 99, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 99, 0, 99, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 100, 0, 100, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 81, 0, 81, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 85, 0, 85, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 108, 0, 108, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 97, 0, 97, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 100, 0, 100, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 100, 0, 100, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 95, 0, 95, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 80, 0, 80, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 83, 0, 83, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 87, 0, 87, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 82, 0, 82, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 105, 0, 105, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 97, 0, 97, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 108, 0, 108, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 118, 0, 118, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 109, 0, 109, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 103, 0, 103, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-26T08:00:00.000', '2026-06-26T18:00:00.000', 1000, 1000 + 81, 0, 81, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 95, 0, 95, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 113, 0, 113, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 102, 0, 102, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 81, 0, 81, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 95, 0, 95, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 105, 0, 105, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 3000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2289, 0, 2289, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2420, 0, 2420, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Saiful
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1138@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Saiful', '1138', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '43-1649', 'Sedan 2012', 'CNG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 117, 117, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 112, 112, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 94, 94, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 90, 90, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 87, 87, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 93, 93, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 113, 113, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 112, 112, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 80, 80, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 104, 104, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 86, 86, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 112, 112, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 112, 112, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 87, 87, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 105, 105, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 80, 80, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 97, 97, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 101, 101, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 86, 86, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 117, 117, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 94, 94, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 114, 114, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 84, 84, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 87, 87, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 92, 92, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-26T08:00:00.000', '2026-06-26T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 112, 112, 0, 3, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 91, 91, 0, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 2000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2489, 2489, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2093, 2093, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Akash
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1139@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Akash', '1139', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '43-9029', 'Sedan 2012', 'LPG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 108, 0, 108, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 108, 0, 108, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 106, 0, 106, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 104, 0, 104, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 90, 0, 90, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 84, 0, 84, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 94, 0, 94, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 87, 0, 87, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 83, 0, 83, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-07T08:00:00.000', '2026-08-07T18:00:00.000', 1000, 1000 + 90, 0, 90, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 109, 0, 109, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 80, 0, 80, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 93, 0, 93, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 89, 0, 89, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 103, 0, 103, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 103, 0, 103, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 89, 0, 89, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 82, 0, 82, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 102, 0, 102, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 93, 0, 93, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 106, 0, 106, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 86, 0, 86, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 80, 0, 80, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 111, 0, 111, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 116, 0, 116, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 91, 0, 91, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 92, 0, 92, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 110, 0, 110, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 86, 0, 86, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 89, 0, 89, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 111, 0, 111, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 97, 0, 97, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 92, 0, 92, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 102, 0, 102, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 90, 0, 90, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 110, 0, 110, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 81, 0, 81, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 110, 0, 110, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 96, 0, 96, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 81, 0, 81, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 89, 0, 89, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 93, 0, 93, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 99, 0, 99, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 113, 0, 113, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 87, 0, 87, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 86, 0, 86, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 103, 0, 103, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 116, 0, 116, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 111, 0, 111, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 2000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 2000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2234, 0, 2234, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2436, 0, 2436, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Monjur Islam
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1141@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Monjur Islam', '1141', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '32-6463', 'Sedan 2012', 'CNG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 102, 102, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 101, 101, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 81, 81, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 115, 115, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 93, 93, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 109, 109, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 115, 115, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 85, 85, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 115, 115, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 115, 115, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 81, 81, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 102, 102, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 94, 94, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 104, 104, 0, 6, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 84, 84, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 96, 96, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 118, 118, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 100, 100, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 90, 90, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 102, 102, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 114, 114, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 90, 90, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 99, 99, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 98, 98, 0, 5, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 115, 115, 0, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 96, 96, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 89, 89, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 102, 102, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 107, 107, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 118, 118, 0, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 1000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2465, 2465, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2285, 2285, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Shahid
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1142@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Shahid', '1142', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '43-7019', 'Sedan 2012', 'CNG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 104, 104, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 93, 93, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 98, 98, 0, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 114, 114, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 102, 102, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 111, 111, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 105, 105, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 87, 87, 0, 4, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 113, 113, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 96, 96, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 110, 110, 0, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 93, 93, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 115, 115, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 80, 80, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 97, 97, 0, 3, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 82, 82, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 118, 118, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 101, 101, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 117, 117, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 90, 90, 0, 5, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 102, 102, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 80, 80, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 87, 87, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 117, 117, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 85, 85, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-26T08:00:00.000', '2026-06-26T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 113, 113, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 90, 90, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 86, 86, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 96, 96, 0, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 2000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 3000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2331, 2331, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2042, 2042, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Hasim
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1143@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Hasim', '1143', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '32-4614', 'Sedan 2012', 'CNG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 115, 115, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 87, 87, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 104, 104, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 84, 84, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 101, 101, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 100, 100, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 93, 93, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 83, 83, 0, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 113, 113, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 86, 86, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 102, 102, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 101, 101, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 115, 115, 0, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 115, 115, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 90, 90, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 86, 86, 0, 5, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 90, 90, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 96, 96, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 118, 118, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 93, 93, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 85, 85, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 112, 112, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 95, 95, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 96, 96, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 102, 102, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 102, 102, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 117, 117, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 95, 95, 0, 3, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 91, 91, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 111, 111, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-26T08:00:00.000', '2026-06-26T18:00:00.000', 1000, 1000 + 106, 106, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 92, 92, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 85, 85, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 89, 89, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 88, 88, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 104, 104, 0, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 2000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 1000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2000, 2000, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2209, 2209, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Rabbi
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1144@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Rabbi', '1144', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '28-2367', 'Sedan 2012', 'CNG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 110, 110, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 89, 89, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 118, 118, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 105, 105, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 91, 91, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 100, 100, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 107, 107, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 111, 111, 0, 3, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-07T08:00:00.000', '2026-08-07T18:00:00.000', 1000, 1000 + 96, 96, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 100, 100, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 115, 115, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 119, 119, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 112, 112, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 85, 85, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 112, 112, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 93, 93, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 112, 112, 0, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 102, 102, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 103, 103, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 96, 96, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 111, 111, 0, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 96, 96, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 98, 98, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 88, 88, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 97, 97, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 101, 101, 0, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 119, 119, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 117, 117, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 102, 102, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 99, 99, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 116, 116, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 96, 96, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 99, 99, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 93, 93, 0, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 85, 85, 0, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 105, 105, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 109, 109, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 108, 108, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 106, 106, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 102, 102, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-26T08:00:00.000', '2026-06-26T18:00:00.000', 1000, 1000 + 102, 102, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 89, 89, 0, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 86, 86, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 94, 94, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 80, 80, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 83, 83, 0, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 106, 106, 0, 3, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 2000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 2000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2481, 2481, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2214, 2214, 0, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Abdul Azizul
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1149@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Abdul Azizul', '1149', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '37-7218', 'Sedan 2012', 'LPG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 85, 0, 85, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 119, 0, 119, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 104, 0, 104, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 119, 0, 119, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 88, 0, 88, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 91, 0, 91, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 114, 0, 114, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 109, 0, 109, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 118, 0, 118, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 113, 0, 113, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 102, 0, 102, 6, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 90, 0, 90, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 97, 0, 97, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 86, 0, 86, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 109, 0, 109, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 103, 0, 103, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 85, 0, 85, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 99, 0, 99, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 102, 0, 102, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 101, 0, 101, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 81, 0, 81, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 112, 0, 112, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 82, 0, 82, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 81, 0, 81, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 101, 0, 101, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 116, 0, 116, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 96, 0, 96, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 82, 0, 82, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 105, 0, 105, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 104, 0, 104, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 102, 0, 102, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 100, 0, 100, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 87, 0, 87, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 110, 0, 110, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 110, 0, 110, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 112, 0, 112, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 117, 0, 117, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 101, 0, 101, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 96, 0, 96, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 97, 0, 97, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 104, 0, 104, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 112, 0, 112, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 119, 0, 119, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 119, 0, 119, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 84, 0, 84, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 85, 0, 85, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 101, 0, 101, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 110, 0, 110, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 89, 0, 89, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 97, 0, 97, 2, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 80, 0, 80, 4, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 100, 0, 100, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 82, 0, 82, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 108, 0, 108, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 114, 0, 114, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 2000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2297, 0, 2297, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2298, 0, 2298, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Shahidul
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1173@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Shahidul', '1173', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '34-6708', 'Sedan 2012', 'Octane', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 83, 0, 0, 83, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 100, 0, 0, 100, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 81, 0, 0, 81, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 84, 0, 0, 84, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 87, 0, 0, 87, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 105, 0, 0, 105, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-07T08:00:00.000', '2026-08-07T18:00:00.000', 1000, 1000 + 109, 0, 0, 109, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 115, 0, 0, 115, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 91, 0, 0, 91, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 115, 0, 0, 115, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 113, 0, 0, 113, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 87, 0, 0, 87, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 85, 0, 0, 85, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 101, 0, 0, 101, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 82, 0, 0, 82, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 119, 0, 0, 119, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 100, 0, 0, 100, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 106, 0, 0, 106, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 83, 0, 0, 83, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 119, 0, 0, 119, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 110, 0, 0, 110, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 82, 0, 0, 82, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 99, 0, 0, 99, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 89, 0, 0, 89, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 107, 0, 0, 107, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 115, 0, 0, 115, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 81, 0, 0, 81, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 82, 0, 0, 82, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 80, 0, 0, 80, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 101, 0, 0, 101, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 93, 0, 0, 93, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 105, 0, 0, 105, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 97, 0, 0, 97, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 87, 0, 0, 87, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 3000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2337, 0, 0, 2337, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2407, 0, 0, 2407, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Monzur
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1176@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Monzur', '1176', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '45-4482', 'Sedan 2012', 'LPG', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 93, 0, 93, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 94, 0, 94, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 108, 0, 108, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 112, 0, 112, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 103, 0, 103, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 117, 0, 117, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 90, 0, 90, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 107, 0, 107, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 104, 0, 104, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 99, 0, 99, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-07T08:00:00.000', '2026-08-07T18:00:00.000', 1000, 1000 + 104, 0, 104, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 113, 0, 113, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 84, 0, 84, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 87, 0, 87, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 114, 0, 114, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 89, 0, 89, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 118, 0, 118, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 92, 0, 92, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 85, 0, 85, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 107, 0, 107, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 97, 0, 97, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 89, 0, 89, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 112, 0, 112, 2, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 100, 0, 100, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 112, 0, 112, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 111, 0, 111, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 109, 0, 109, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 97, 0, 97, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 89, 0, 89, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 110, 0, 110, 6, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 101, 0, 101, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 116, 0, 116, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 98, 0, 98, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 116, 0, 116, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 84, 0, 84, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 118, 0, 118, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 108, 0, 108, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 84, 0, 84, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 84, 0, 84, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 111, 0, 111, 5, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 87, 0, 87, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 108, 0, 108, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 81, 0, 81, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 110, 0, 110, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 96, 0, 96, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 90, 0, 90, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 112, 0, 112, 3, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 84, 0, 84, 4, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 103, 0, 103, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 109, 0, 109, 0, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 115, 0, 115, 0, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 108, 0, 108, 0, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 2000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 3000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2455, 0, 2455, 100, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2004, 0, 2004, 100, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Shahin
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1177@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Shahin', '1177', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '26-2774', 'Sedan 2012', 'Octane', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 105, 0, 0, 105, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 109, 0, 0, 109, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 98, 0, 0, 98, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 105, 0, 0, 105, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 110, 0, 0, 110, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 104, 0, 0, 104, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-07T08:00:00.000', '2026-08-07T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 104, 0, 0, 104, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 83, 0, 0, 83, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 89, 0, 0, 89, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 93, 0, 0, 93, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 84, 0, 0, 84, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 119, 0, 0, 119, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 119, 0, 0, 119, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 80, 0, 0, 80, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 80, 0, 0, 80, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 84, 0, 0, 84, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 106, 0, 0, 106, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 115, 0, 0, 115, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 89, 0, 0, 89, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 98, 0, 0, 98, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 101, 0, 0, 101, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 82, 0, 0, 82, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 96, 0, 0, 96, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 98, 0, 0, 98, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 103, 0, 0, 103, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 83, 0, 0, 83, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 113, 0, 0, 113, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 107, 0, 0, 107, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 109, 0, 0, 109, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 85, 0, 0, 85, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 94, 0, 0, 94, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 82, 0, 0, 82, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 88, 0, 0, 88, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 93, 0, 0, 93, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-26T08:00:00.000', '2026-06-26T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 88, 0, 0, 88, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 82, 0, 0, 82, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 100, 0, 0, 100, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 93, 0, 0, 93, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 106, 0, 0, 106, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 2000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 2000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2064, 0, 0, 2064, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2067, 0, 0, 2067, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Mahadi
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1193@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Mahadi', '1193', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '24-3197', 'Sedan 2012', 'Octane', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 104, 0, 0, 104, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 109, 0, 0, 109, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 103, 0, 0, 103, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 89, 0, 0, 89, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 118, 0, 0, 118, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 87, 0, 0, 87, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 96, 0, 0, 96, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 87, 0, 0, 87, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 98, 0, 0, 98, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 119, 0, 0, 119, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 107, 0, 0, 107, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 105, 0, 0, 105, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 100, 0, 0, 100, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 110, 0, 0, 110, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 105, 0, 0, 105, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 80, 0, 0, 80, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 87, 0, 0, 87, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 93, 0, 0, 93, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 118, 0, 0, 118, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 110, 0, 0, 110, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 107, 0, 0, 107, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 84, 0, 0, 84, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 84, 0, 0, 84, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 113, 0, 0, 113, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 97, 0, 0, 97, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 83, 0, 0, 83, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 109, 0, 0, 109, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 81, 0, 0, 81, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 107, 0, 0, 107, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-03T08:00:00.000', '2026-07-03T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 89, 0, 0, 89, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 105, 0, 0, 105, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 101, 0, 0, 101, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 113, 0, 0, 113, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 118, 0, 0, 118, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 113, 0, 0, 113, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 85, 0, 0, 85, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 2000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2404, 0, 0, 2404, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2095, 0, 0, 2095, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Hafizur Rahman
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1194@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Hafizur Rahman', '1194', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '36-4484', 'Sedan 2012', 'Octane', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 88, 0, 0, 88, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 118, 0, 0, 118, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 96, 0, 0, 96, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 80, 0, 0, 80, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 93, 0, 0, 93, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 84, 0, 0, 84, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 80, 0, 0, 80, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 101, 0, 0, 101, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 96, 0, 0, 96, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 104, 0, 0, 104, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 103, 0, 0, 103, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 109, 0, 0, 109, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-31T08:00:00.000', '2026-07-31T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 104, 0, 0, 104, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 110, 0, 0, 110, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 99, 0, 0, 99, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 93, 0, 0, 93, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 89, 0, 0, 89, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 118, 0, 0, 118, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 119, 0, 0, 119, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 101, 0, 0, 101, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 115, 0, 0, 115, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-17T08:00:00.000', '2026-07-17T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 101, 0, 0, 101, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 118, 0, 0, 118, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 115, 0, 0, 115, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 94, 0, 0, 94, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 89, 0, 0, 89, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 91, 0, 0, 91, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 116, 0, 0, 116, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 103, 0, 0, 103, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 119, 0, 0, 119, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 98, 0, 0, 98, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 89, 0, 0, 89, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 98, 0, 0, 98, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 110, 0, 0, 110, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 118, 0, 0, 118, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', false);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 1000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 3000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2171, 0, 0, 2171, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2338, 0, 0, 2338, 10, 2, 26, 300, 26, 2000, 38000);

  -- Driver: Ashraful Alom
  uid := gen_random_uuid();
  vid := gen_random_uuid();
  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) 
  VALUES (uid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'driver1205@ubs.com', crypt('123456', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)
  VALUES (uid, 'Ashraful Alom', '1205', 'driver', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);
  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)
  VALUES (vid, uid, '28-5947', 'Sedan 2012', 'Octane', 38000);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-18T08:00:00.000', '2026-08-18T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-17T08:00:00.000', '2026-08-17T18:00:00.000', 1000, 1000 + 94, 0, 0, 94, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-16T08:00:00.000', '2026-08-16T18:00:00.000', 1000, 1000 + 110, 0, 0, 110, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-15T08:00:00.000', '2026-08-15T18:00:00.000', 1000, 1000 + 97, 0, 0, 97, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-14T08:00:00.000', '2026-08-14T18:00:00.000', 1000, 1000 + 94, 0, 0, 94, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-13T08:00:00.000', '2026-08-13T18:00:00.000', 1000, 1000 + 115, 0, 0, 115, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-12T08:00:00.000', '2026-08-12T18:00:00.000', 1000, 1000 + 100, 0, 0, 100, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-11T08:00:00.000', '2026-08-11T18:00:00.000', 1000, 1000 + 93, 0, 0, 93, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-10T08:00:00.000', '2026-08-10T18:00:00.000', 1000, 1000 + 83, 0, 0, 83, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-09T08:00:00.000', '2026-08-09T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-08T08:00:00.000', '2026-08-08T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-07T08:00:00.000', '2026-08-07T18:00:00.000', 1000, 1000 + 94, 0, 0, 94, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-06T08:00:00.000', '2026-08-06T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-05T08:00:00.000', '2026-08-05T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-04T08:00:00.000', '2026-08-04T18:00:00.000', 1000, 1000 + 88, 0, 0, 88, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-03T08:00:00.000', '2026-08-03T18:00:00.000', 1000, 1000 + 104, 0, 0, 104, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-02T08:00:00.000', '2026-08-02T18:00:00.000', 1000, 1000 + 98, 0, 0, 98, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-08-01T08:00:00.000', '2026-08-01T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-30T08:00:00.000', '2026-07-30T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-29T08:00:00.000', '2026-07-29T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-28T08:00:00.000', '2026-07-28T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-27T08:00:00.000', '2026-07-27T18:00:00.000', 1000, 1000 + 118, 0, 0, 118, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-26T08:00:00.000', '2026-07-26T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-25T08:00:00.000', '2026-07-25T18:00:00.000', 1000, 1000 + 111, 0, 0, 111, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-24T08:00:00.000', '2026-07-24T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-23T08:00:00.000', '2026-07-23T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-22T08:00:00.000', '2026-07-22T18:00:00.000', 1000, 1000 + 117, 0, 0, 117, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-21T08:00:00.000', '2026-07-21T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-20T08:00:00.000', '2026-07-20T18:00:00.000', 1000, 1000 + 88, 0, 0, 88, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-19T08:00:00.000', '2026-07-19T18:00:00.000', 1000, 1000 + 112, 0, 0, 112, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-18T08:00:00.000', '2026-07-18T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-16T08:00:00.000', '2026-07-16T18:00:00.000', 1000, 1000 + 91, 0, 0, 91, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-15T08:00:00.000', '2026-07-15T18:00:00.000', 1000, 1000 + 92, 0, 0, 92, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-14T08:00:00.000', '2026-07-14T18:00:00.000', 1000, 1000 + 110, 0, 0, 110, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-13T08:00:00.000', '2026-07-13T18:00:00.000', 1000, 1000 + 80, 0, 0, 80, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-12T08:00:00.000', '2026-07-12T18:00:00.000', 1000, 1000 + 83, 0, 0, 83, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-11T08:00:00.000', '2026-07-11T18:00:00.000', 1000, 1000 + 84, 0, 0, 84, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-10T08:00:00.000', '2026-07-10T18:00:00.000', 1000, 1000 + 100, 0, 0, 100, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-09T08:00:00.000', '2026-07-09T18:00:00.000', 1000, 1000 + 99, 0, 0, 99, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-08T08:00:00.000', '2026-07-08T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-07T08:00:00.000', '2026-07-07T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-06T08:00:00.000', '2026-07-06T18:00:00.000', 1000, 1000 + 114, 0, 0, 114, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-05T08:00:00.000', '2026-07-05T18:00:00.000', 1000, 1000 + 105, 0, 0, 105, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-04T08:00:00.000', '2026-07-04T18:00:00.000', 1000, 1000 + 95, 0, 0, 95, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-02T08:00:00.000', '2026-07-02T18:00:00.000', 1000, 1000 + 84, 0, 0, 84, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-07-01T08:00:00.000', '2026-07-01T18:00:00.000', 1000, 1000 + 119, 0, 0, 119, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-30T08:00:00.000', '2026-06-30T18:00:00.000', 1000, 1000 + 102, 0, 0, 102, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-29T08:00:00.000', '2026-06-29T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-28T08:00:00.000', '2026-06-28T18:00:00.000', 1000, 1000 + 90, 0, 0, 90, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-27T08:00:00.000', '2026-06-27T18:00:00.000', 1000, 1000 + 108, 0, 0, 108, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-26T08:00:00.000', '2026-06-26T18:00:00.000', 1000, 1000 + 87, 0, 0, 87, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-25T08:00:00.000', '2026-06-25T18:00:00.000', 1000, 1000 + 106, 0, 0, 106, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-24T08:00:00.000', '2026-06-24T18:00:00.000', 1000, 1000 + 97, 0, 0, 97, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-23T08:00:00.000', '2026-06-23T18:00:00.000', 1000, 1000 + 86, 0, 0, 86, 'completed', true);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-22T08:00:00.000', '2026-06-22T18:00:00.000', 1000, 1000 + 99, 0, 0, 99, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-21T08:00:00.000', '2026-06-21T18:00:00.000', 1000, 1000 + 99, 0, 0, 99, 'completed', false);
  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)
  VALUES (uid, vid, '2026-06-20T08:00:00.000', '2026-06-20T18:00:00.000', 1000, 1000 + 81, 0, 0, 81, 'completed', true);
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-08-15', 2000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-07-15', 3000, 'Advance');
  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)
  VALUES (uid, '2026-06-15', 3000, 'Advance');
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-07', 2107, 0, 0, 2107, 10, 2, 26, 300, 26, 2000, 38000);
  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)
  VALUES (uid, '2026-06', 2147, 0, 0, 2147, 10, 2, 26, 300, 26, 2000, 38000);
END $$;
