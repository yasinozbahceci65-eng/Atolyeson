/*
# Allow consultation bucket lookup

1. Purpose
- Allow the consultation screen's public Supabase client to resolve the existing `consult-photos` bucket before uploading an image.

2. Modified storage object
- `storage.buckets`
- No columns or stored files are changed.

3. Security changes
- Add a SELECT policy limited to the single `consult-photos` bucket.
- Keep all upload restrictions on `storage.objects`: uploads remain limited to the `consult/` folder and supported image MIME types.
- No bucket creation, update, or delete access is granted to app clients.

4. Important notes
- This change supports both guest and authenticated consultation submissions.
- No application tables or existing photos are modified.
*/

DROP POLICY IF EXISTS "consult_photos_bucket_lookup" ON storage.buckets;
CREATE POLICY "consult_photos_bucket_lookup"
ON storage.buckets FOR SELECT
TO anon, authenticated
USING (id = 'consult-photos');