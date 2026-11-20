# Project memory

## Product intent & audience

- Expo (React Native) mobile app with Supabase backend and Google OAuth authentication.
- User communicates in Turkish; UI/interaction issues likely reported in Turkish.

## Brand personality & voice

- Not yet inferred from design; assistant responses use direct, problem-solving tone in Turkish.

## Visual design & UX direction

- No visual/UX details inferred this turn.

## Decisions, constraints & rationale

- **Supabase credentials hardcoded into app code** instead of relying on `.env`, because `.env` kept reverting to an old/default Bolt project on each session.
- **`||` fallback for env vars does not work in Expo** — Expo bakes `process.env` at build time; old truthy string values are not `undefined`, so fallbacks never trigger.
- Correct Supabase project reference: `lamqkcipsbrelfadikxb`.
- Symptom: Google OAuth flow sent requests to wrong Supabase project → "Invalid API key" error.
- Only auth/connection code was modified; other screens and features left untouched.

## Open questions & assumptions

- **Google OAuth provider in Supabase Dashboard** must be enabled with valid Google OAuth Client ID/Secret — user needs to verify in Dashboard → Authentication → Providers.
- Root cause of `.env` reverting to default project is unresolved (Bolt environment behavior); workaround is hardcoding, not a true fix.
- Whether hardcoded credentials are appropriate for production or should be migrated to a build-time config mechanism is unaddressed.