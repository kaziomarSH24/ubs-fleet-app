-- Create vehicle models table
CREATE TABLE public.vehicle_models (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.vehicle_models ENABLE ROW LEVEL SECURITY;

-- Admins can manage vehicle models
CREATE POLICY "Admins can manage vehicle models" ON public.vehicle_models
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
    )
  );

-- All authenticated users can view vehicle models
CREATE POLICY "Users can view vehicle models" ON public.vehicle_models
  FOR SELECT
  TO authenticated
  USING (true);

-- Insert default models
INSERT INTO public.vehicle_models (name) VALUES 
('Toyota HiAce'),
('Toyota Noah'),
('Toyota X-Noah'),
('Sedan'),
('Pickup'),
('Microbus')
ON CONFLICT (name) DO NOTHING;
