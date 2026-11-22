import { createClient } from '@supabase/supabase-js';
import AsyncStorage from '@react-native-async-storage/async-storage';
import 'react-native-url-polyfill/auto';

export const SUPABASE_URL = 'https://lamqkcipsbrelfadikxb.supabase.co';
export const SUPABASE_ANON_KEY = 'sb_publishable_i2obMcXwHRSNZeFDc2nSaQ_-pfRN36W';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
  auth: {
    storage: AsyncStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
  },
});

export type UnitType = 'Litre' | 'Adet' | 'Metre' | 'Kg' | 'Kutu' | 'm²';

export interface Category {
  id: string;
  name: string;
  color: string;
  icon: string;
  created_at: string;
}

export interface Item {
  id: string;
  name: string;
  category_id: string | null;
  quantity: number;
  max_quantity: number;
  unit_type: UnitType;
  barcode_value: string | null;
  critical_level: number;
  image_url: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
  categories?: Category;
}

export interface Project {
  id: string;
  project_name: string;
  project_type: string;
  area_m2: number | null;
  notes: string | null;
  is_completed: boolean;
  created_at: string;
  project_materials?: ProjectMaterial[];
}

export interface ProjectMaterial {
  id: string;
  project_id: string;
  item_id: string | null;
  material_name: string;
  required_quantity: number;
  unit_type: UnitType;
  is_sufficient: boolean;
}

export interface ProSubscription {
  id: number;
  is_pro: boolean;
  plan_id: string | null;
  purchased_at: string | null;
  expires_at: string | null;
  updated_at: string;
  iyzico_payment_id: string | null;
  iyzico_conversation_id: string | null;
  iyzico_last_payment_status: string | null;
}

export interface Profile {
  id: number;
  name: string;
  email: string | null;
  phone: string | null;
  avatar_color: string;
  created_at: string;
  updated_at: string;
}

export interface Payment {
  id: string;
  conversation_id: string;
  plan_id: string;
  amount: number;
  currency: string;
  status: 'pending' | 'success' | 'failed';
  iyzico_payment_id: string | null;
  iyzico_raw_response: any;
  user_email: string | null;
  created_at: string;
  updated_at: string;
}
