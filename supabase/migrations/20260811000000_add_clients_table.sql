-- Create clients table
CREATE TABLE public.clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  logo_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS for clients
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- Admins can manage clients
CREATE POLICY "Admins can manage clients" ON public.clients
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
    )
  );

-- All authenticated users (drivers) can view clients
CREATE POLICY "Drivers can view clients" ON public.clients
  FOR SELECT
  TO authenticated
  USING (true);

-- Add client_id to profiles (for drivers)
ALTER TABLE public.profiles 
ADD COLUMN client_id UUID REFERENCES public.clients(id) ON DELETE SET NULL;

-- Add client_id to vehicles
ALTER TABLE public.vehicles 
ADD COLUMN client_id UUID REFERENCES public.clients(id) ON DELETE SET NULL;

-- Insert some dummy clients for testing
INSERT INTO public.clients (name) VALUES 
('bKash'),
('Guardian Life Insurance'),
('SIKA');
