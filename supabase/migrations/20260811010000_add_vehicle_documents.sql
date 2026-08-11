-- Add status to vehicles
ALTER TABLE public.vehicles 
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'active';

-- Create vehicle documents table
CREATE TABLE public.vehicle_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id UUID REFERENCES public.vehicles(id) ON DELETE CASCADE,
  doc_type TEXT NOT NULL, -- 'fitness', 'tax_token', 'insurance', 'route_permit', 'other'
  file_url TEXT NOT NULL,
  expiry_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS for vehicle_documents
ALTER TABLE public.vehicle_documents ENABLE ROW LEVEL SECURITY;

-- Admins can manage vehicle documents
CREATE POLICY "Admins can manage vehicle documents" ON public.vehicle_documents
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
    )
  );

-- Drivers can view their assigned vehicle's documents
CREATE POLICY "Drivers can view assigned vehicle documents" ON public.vehicle_documents
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.vehicles 
      WHERE vehicles.id = vehicle_documents.vehicle_id 
      AND vehicles.current_driver_id = auth.uid()
    )
  );

-- Create storage bucket for vehicle documents if it doesn't exist
INSERT INTO storage.buckets (id, name, public) 
VALUES ('vehicle_documents', 'vehicle_documents', false)
ON CONFLICT (id) DO NOTHING;

-- RLS for vehicle_documents bucket
-- Allow authenticated users to view
CREATE POLICY "Authenticated users can view vehicle_documents"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'vehicle_documents');

-- Allow admins to insert/update/delete
CREATE POLICY "Admins can manage vehicle_documents"
ON storage.objects FOR ALL
TO authenticated
USING (
  bucket_id = 'vehicle_documents' AND
  EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
  )
);
