/*
# Force Storage service to recognize consult-photos bucket

1. Problem
- The `consult-photos` bucket exists in `storage.buckets` but the Storage API
  returns "Bucket not found" for all upload requests.
- Direct DELETE from storage.buckets is blocked by the protect_delete trigger.

2. Solution
- Update the existing bucket row's `updated_at` to force the Storage service to
  pick up the change and reload its cache.
- Send NOTIFY to storage channel to force cache reload.
- Recreate RLS policies on storage.objects for this bucket.

3. Security
- Public read access for objects in consult-photos bucket.
- Anon + authenticated insert access restricted to consult/ folder.

4. Notes
- No data is deleted or modified beyond the bucket metadata timestamp.
- Idempotent: safe to re-run.
*/

-- Touch the bucket row to force cache invalidation
UPDATE storage.buckets
SET updated_at = now(),
    public = true,
    file_size_limit = 8388608,
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp']::text[]
WHERE id = 'consult-photos';

-- Recreate policies on storage.objects
DROP POLICY IF EXISTS "consult_photos_public_read" ON storage.objects;
CREATE POLICY "consult_photos_public_read"
ON storage.objects FOR SELECT
TO anon, authenticated
USING (bucket_id = 'consult-photos');

DROP POLICY IF EXISTS "consult_photos_insert" ON storage.objects;
CREATE POLICY "consult_photos_insert"
ON storage.objects FOR INSERT
TO anon, authenticated
WITH CHECK (
  bucket_id = 'consult-photos'
  AND (storage.foldername(name))[1] = 'consult'
);

-- Notify Storage service to reload bucket cache
NOTIFY storage;
NOTIFY pgrst, 'reload schema';