
CREATE OR REPLACE FUNCTION public.set_config(setting_name TEXT, setting_value TEXT, is_local BOOLEAN)
RETURNS VOID AS $$
BEGIN
  PERFORM set_config(setting_name, setting_value, is_local);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;
