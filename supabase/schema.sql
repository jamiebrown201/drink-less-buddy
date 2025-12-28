-- Drink Less Buddy - Supabase Database Schema
-- This schema is designed for cost-efficiency and scalability
-- Use Row Level Security (RLS) for data privacy

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  is_premium BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  has_completed_onboarding BOOLEAN DEFAULT FALSE,
  has_accepted_terms BOOLEAN DEFAULT FALSE,
  is_over_18 BOOLEAN DEFAULT FALSE,
  weekly_goal_units NUMERIC(5,2),
  preferences JSONB DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Drinks table
CREATE TABLE public.drinks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  drink_type TEXT NOT NULL,
  units NUMERIC(4,2) NOT NULL,
  mood TEXT NOT NULL,
  context TEXT NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Intentions table
CREATE TABLE public.intentions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  intention_date DATE NOT NULL,
  activity TEXT NOT NULL,
  time TEXT,
  reason TEXT,
  is_completed BOOLEAN DEFAULT FALSE,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_drinks_user_id ON public.drinks(user_id);
CREATE INDEX idx_drinks_timestamp ON public.drinks(timestamp);
CREATE INDEX idx_drinks_user_timestamp ON public.drinks(user_id, timestamp DESC);
CREATE INDEX idx_intentions_user_id ON public.intentions(user_id);
CREATE INDEX idx_intentions_date ON public.intentions(intention_date);
CREATE INDEX idx_intentions_user_date ON public.intentions(user_id, intention_date);

-- Row Level Security (RLS) Policies
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drinks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.intentions ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view own data"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data"
  ON public.users FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own data"
  ON public.users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Drinks policies
CREATE POLICY "Users can view own drinks"
  ON public.drinks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own drinks"
  ON public.drinks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own drinks"
  ON public.drinks FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own drinks"
  ON public.drinks FOR DELETE
  USING (auth.uid() = user_id);

-- Intentions policies
CREATE POLICY "Users can view own intentions"
  ON public.intentions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own intentions"
  ON public.intentions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own intentions"
  ON public.intentions FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own intentions"
  ON public.intentions FOR DELETE
  USING (auth.uid() = user_id);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_drinks_updated_at
  BEFORE UPDATE ON public.drinks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_intentions_updated_at
  BEFORE UPDATE ON public.intentions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Optional: Analytics view (for premium users or research)
CREATE OR REPLACE VIEW public.user_analytics AS
SELECT
  user_id,
  COUNT(*) as total_drinks,
  SUM(units) as total_units,
  AVG(units) as avg_units_per_drink,
  COUNT(DISTINCT DATE(timestamp)) as drinking_days,
  mode() WITHIN GROUP (ORDER BY mood) as most_common_mood,
  mode() WITHIN GROUP (ORDER BY context) as most_common_context
FROM public.drinks
GROUP BY user_id;

-- Grant access to analytics view
GRANT SELECT ON public.user_analytics TO authenticated;

-- RLS for analytics view
CREATE POLICY "Users can view own analytics"
  ON public.user_analytics FOR SELECT
  USING (auth.uid() = user_id);
