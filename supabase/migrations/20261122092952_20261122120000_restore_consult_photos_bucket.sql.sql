/*
# Restore consultation photo storage bucket

1. Purpose
- Recreate the public `consult-photos` storage bucket required by the Usta and Mimar consultation screens.
- The existing migration history contains the consultation storage migration, but the live project currently has no bucket with this id.

2. Storage configuration
- Bucket: `consult-photos`
- Public read access is enabled so the WhatsApp recipient can open the shared image link.
- Maximum file size is 8 MB.
- Accepted file types are JPEG, PNG, and WebP images.

3. Security changes
- Preserve the existing public-read policy for objects in this bucket.
- Preserve anonymous and authenticated upload access only inside the `consult/` folder.
- Restrict uploads to the supported image MIME types.
- Do not add update or delete access for app clients.

4. Important notes
- This migration does not delete existing data or change application tables.
- The bucket operation is idempotent and safe if the bucket already exists.
*/

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'consult-photos',
  'consult-photos',
  true,
  8388608,
  ARRAY['image/jpeg', 'image/png', 'image/webp']::text[]
)
ON CONFLICT (id) DO UPDATE
SET name = EXCLUDED.name,
    public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types;

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
  AND lower(COALESCE(metadata->>'mimetype', '')) IN ('image/jpeg', 'image/png', 'image/webp')
);