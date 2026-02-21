
-- Create users table (shared across trackers)
CREATE TABLE IF NOT EXISTS public.users (
  id BIGINT PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create sleep_logs table
CREATE TABLE public.sleep_logs (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  bedtime TEXT,
  wake_time TEXT,
  total_minutes INT,
  quality INT CHECK (quality >= 1 AND quality <= 5),
  score INT CHECK (score >= 0 AND score <= 100),
  wake_ups INT DEFAULT 0,
  symptoms JSONB DEFAULT '[]'::jsonb,
  wake_feeling TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, date)
);

-- Create set_config RPC function
CREATE OR REPLACE FUNCTION public.set_config(setting_name TEXT, setting_value TEXT, is_local BOOLEAN)
RETURNS VOID AS $$
BEGIN
  PERFORM set_config(setting_name, setting_value, is_local);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sleep_logs ENABLE ROW LEVEL SECURITY;

-- RLS policies using app.current_user_id setting
CREATE POLICY "Users can view own record" ON public.users
  FOR SELECT USING (id = current_setting('app.current_user_id', true)::BIGINT);

CREATE POLICY "Users can insert own record" ON public.users
  FOR INSERT WITH CHECK (id = current_setting('app.current_user_id', true)::BIGINT);

CREATE POLICY "Users can update own record" ON public.users
  FOR UPDATE USING (id = current_setting('app.current_user_id', true)::BIGINT);

CREATE POLICY "Users can view own sleep logs" ON public.sleep_logs
  FOR SELECT USING (user_id = current_setting('app.current_user_id', true)::BIGINT);

CREATE POLICY "Users can insert own sleep logs" ON public.sleep_logs
  FOR INSERT WITH CHECK (user_id = current_setting('app.current_user_id', true)::BIGINT);

CREATE POLICY "Users can update own sleep logs" ON public.sleep_logs
  FOR UPDATE USING (user_id = current_setting('app.current_user_id', true)::BIGINT);

CREATE POLICY "Users can delete own sleep logs" ON public.sleep_logs
  FOR DELETE USING (user_id = current_setting('app.current_user_id', true)::BIGINT);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_sleep_logs_updated_at BEFORE UPDATE ON public.sleep_logs
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
