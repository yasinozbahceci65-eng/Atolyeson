/*
# Create consult_photos table for photo storage

1. Purpose
- Store consultation photos as base64 text in a database table.
- This bypasses the Supabase Storage API, which cannot find the bucket due to
  a platform-level cache synchronization issue with the publishable key format.

2. New Table
- `consult_photos`
  - `id` (uuid, primary key, auto-generated)
  - `photo_data` (text, not null) — base64-encoded image data
  - `content_type` (text, not null, default 'image/jpeg')
  - `created_at` (timestamptz, default now())

3. Security
- RLS enabled on `consult_photos`.
- Grant SELECT, INSERT to anon + authenticated (single-tenant app, no sign-in required for consult).
- Public read + insert policies (anyone can upload and view consultation photos).
- No update or delete access for app clients.

4. Notes
- Base64 encoding increases size by ~33%, so 8MB image becomes ~11MB text.
- The `photo_data` column is TEXT type to accommodate large base64 strings.
- Idempotent: safe to re-run.
*/

CREATE TABLE IF NOT EXISTS consult_photos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  photo_data text NOT NULL,
  content_type text NOT NULL DEFAULT 'image/jpeg',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE consult_photos ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT ON consult_photos TO anon, authenticated;

DROP POLICY IF EXISTS "anon_select_consult_photos" ON consult_photos;
CREATE POLICY "anon_select_consult_photos"
ON consult_photos FOR SELECT
TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_consult_photos" ON consult_photos;
CREATE POLICY "anon_insert_consult_photos"
ON consult_photos FOR INSERT
TO anon, authenticated WITH CHECK (true);