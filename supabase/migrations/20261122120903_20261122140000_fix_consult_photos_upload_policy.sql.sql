/*
# Fix consultation photo upload policy

1. Problem
- The current `consult_photos_insert` policy on `storage.objects` checks `metadata->>'mimetype'`,
  but the Supabase JS SDK does not always populate the `metadata.mimetype` field on upload.
  This causes uploads to fail with a policy violation even when the file is a valid image.
- The bucket itself already enforces `allowed_mime_types` (jpeg, png, webp), so the
  metadata-based mimetype check in the policy is redundant and only blocks valid uploads.

2. Changes
- Drop and recreate the `consult_photos_insert` policy on `storage.objects`.
- Remove the `metadata->>'mimetype'` condition; keep the bucket_id and folder prefix checks.
- The bucket-level `allowed_mime_types` constraint still rejects non-image files.

3. Security
- INSERT policy remains scoped to `anon, authenticated` (single-tenant app, no sign-in required).
- Uploads are still restricted to the `consult-photos` bucket and the `consult/` folder prefix.
- The bucket's `allowed_mime_types` and `file_size_limit` (8 MB) constraints remain in force.
- SELECT (public read) policy is unchanged.

4. Notes
- This migration is idempotent: it drops the policy before recreating it.
- No data is deleted or modified.
*/

DROP POLICY IF EXISTS "consult_photos_insert" ON storage.objects;
CREATE POLICY "consult_photos_insert"
ON storage.objects FOR INSERT
TO anon, authenticated
WITH CHECK (
  bucket_id = 'consult-photos'
  AND (storage.foldername(name))[1] = 'consult'
);