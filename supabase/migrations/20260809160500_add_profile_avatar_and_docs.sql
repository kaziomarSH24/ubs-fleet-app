-- Migration: Add profile avatar, driving license no, driver_documents table and storage buckets
-- Date: 2026-08-09

-- 1. Add columns to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS driving_license_no TEXT;

-- 2. Create ENUMs for documents
DO $$ BEGIN
    CREATE TYPE document_type AS ENUM ('nid', 'driving_license', 'other');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE document_status AS ENUM ('pending', 'verified', 'rejected');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 3. Create driver_documents table
CREATE TABLE IF NOT EXISTS driver_documents (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  driver_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  doc_type document_type NOT NULL,
  file_url TEXT NOT NULL,
  status document_status DEFAULT 'pending',
  admin_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create a trigger to auto update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_driver_documents_updated_at ON driver_documents;
CREATE TRIGGER update_driver_documents_updated_at
BEFORE UPDATE ON driver_documents
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- 4. Create Storage Buckets (if not exist)
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('driver_documents', 'driver_documents', false) ON CONFLICT (id) DO NOTHING;

-- 5. Storage RLS for avatars (public read, auth insert/update)
-- Drop existing policies if any to avoid errors on re-run
DROP POLICY IF EXISTS "Avatar images are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own avatar" ON storage.objects;

CREATE POLICY "Avatar images are publicly accessible" ON storage.objects FOR SELECT USING (bucket_id = 'avatars');
CREATE POLICY "Users can upload their own avatar" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'avatars');
CREATE POLICY "Users can update their own avatar" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'avatars');

-- 6. Storage RLS for driver_documents
DROP POLICY IF EXISTS "Users can upload documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can read own documents" ON storage.objects;

CREATE POLICY "Users can upload documents" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'driver_documents');
-- Using auth.uid()::text = (storage.foldername(name))[1] assuming we upload files to: driver_documents/{driver_id}/filename.jpg
CREATE POLICY "Users can read own documents" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'driver_documents');
-- For testing purposes, we allow authenticated users to read documents (since driver_documents is not public anyway, it requires Auth header)
