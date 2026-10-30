-- Launchpad V15 cloud-save table
-- Run once in your Supabase project's SQL Editor.
-- Keep Row Level Security enabled. Do NOT put a service_role key in the HTML file.

create table if not exists public.launchpad_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.launchpad_profiles enable row level security;

drop policy if exists "Users manage their own Launchpad save" on public.launchpad_profiles;
create policy "Users manage their own Launchpad save"
on public.launchpad_profiles
for all to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

grant select, insert, update, delete
on public.launchpad_profiles to authenticated;
