-- Run once in Supabase SQL Editor. Private groups, member-only chat and sessions.
create extension if not exists pgcrypto with schema extensions;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 30),
  created_at timestamptz not null default now()
);
create table if not exists public.study_groups (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 2 and 50),
  invite_code text not null unique,
  owner_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
create table if not exists public.group_members (
  group_id uuid not null references public.study_groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null default 'member' check (role in ('owner','member')),
  joined_at timestamptz not null default now(), primary key(group_id,user_id)
);
create table if not exists public.group_messages (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.study_groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 1000),
  created_at timestamptz not null default now()
);
create index if not exists group_messages_group_created_idx on public.group_messages(group_id,created_at desc);
create table if not exists public.study_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  group_id uuid references public.study_groups(id) on delete set null,
  subject text not null check (char_length(subject) between 1 and 50),
  study_seconds integer not null check (study_seconds > 0),
  break_seconds integer not null default 0 check (break_seconds >= 0),
  started_at timestamptz not null, finished_at timestamptz not null default now()
);
create index if not exists study_sessions_group_finished_idx on public.study_sessions(group_id,finished_at desc);

create or replace function public.handle_new_studyspace_user()
returns trigger language plpgsql security definer set search_path=public as $$
begin
  insert into public.profiles(id,display_name) values (
    new.id,
    left(coalesce(nullif(trim(new.raw_user_meta_data->>'display_name'),''),split_part(coalesce(new.email,'Student'),'@',1)),30)
  ) on conflict(id) do nothing;
  return new;
end; $$;
drop trigger if exists on_studyspace_user_created on auth.users;
create trigger on_studyspace_user_created after insert on auth.users
for each row execute procedure public.handle_new_studyspace_user();

create or replace function public.is_studyspace_member(p_group_id uuid)
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.group_members gm where gm.group_id=p_group_id and gm.user_id=auth.uid());
$$;
create or replace function public.is_studyspace_owner(p_group_id uuid)
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.study_groups g where g.id=p_group_id and g.owner_id=auth.uid());
$$;
create or replace function public.can_view_studyspace_profile(p_user_id uuid)
returns boolean language sql stable security definer set search_path=public as $$
  select p_user_id=auth.uid() or exists(
    select 1 from public.group_members mine join public.group_members theirs on theirs.group_id=mine.group_id
    where mine.user_id=auth.uid() and theirs.user_id=p_user_id
  );
$$;
create or replace function public.create_studyspace_group(p_name text)
returns table(group_id uuid,invite_code text) language plpgsql security definer set search_path=public,extensions as $$
declare v_id uuid; v_code text;
begin
  if auth.uid() is null then raise exception 'Sign in first.'; end if;
  if char_length(trim(p_name))<2 or char_length(trim(p_name))>50 then raise exception 'Group names must be 2–50 characters.'; end if;
  v_code:=upper(encode(gen_random_bytes(8),'hex'));
  insert into public.study_groups(name,invite_code,owner_id) values(trim(p_name),v_code,auth.uid()) returning id into v_id;
  insert into public.group_members(group_id,user_id,role) values(v_id,auth.uid(),'owner');
  return query select v_id,v_code;
end; $$;
create or replace function public.join_studyspace_group(p_code text)
returns uuid language plpgsql security definer set search_path=public as $$
declare v_id uuid;
begin
  if auth.uid() is null then raise exception 'Sign in first.'; end if;
  select g.id into v_id from public.study_groups g where g.invite_code=upper(trim(p_code));
  if v_id is null then raise exception 'That invite code was not found.'; end if;
  insert into public.group_members(group_id,user_id,role) values(v_id,auth.uid(),'member') on conflict do nothing;
  return v_id;
end; $$;

alter table public.profiles enable row level security;
alter table public.study_groups enable row level security;
alter table public.group_members enable row level security;
alter table public.group_messages enable row level security;
alter table public.study_sessions enable row level security;
create policy "profiles visible to self and groupmates" on public.profiles for select to authenticated using(public.can_view_studyspace_profile(id));
create policy "users update own profile" on public.profiles for update to authenticated using(id=auth.uid()) with check(id=auth.uid());
create policy "members read private groups" on public.study_groups for select to authenticated using(public.is_studyspace_member(id));
create policy "owners update groups" on public.study_groups for update to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());
create policy "owners delete groups" on public.study_groups for delete to authenticated using(owner_id=auth.uid());
create policy "members see group roster" on public.group_members for select to authenticated using(public.is_studyspace_member(group_id));
create policy "members leave or owners remove" on public.group_members for delete to authenticated using(user_id=auth.uid() or public.is_studyspace_owner(group_id));
create policy "members read group chat" on public.group_messages for select to authenticated using(public.is_studyspace_member(group_id));
create policy "members send group chat" on public.group_messages for insert to authenticated with check(user_id=auth.uid() and public.is_studyspace_member(group_id));
create policy "authors or owners delete chat" on public.group_messages for delete to authenticated using(user_id=auth.uid() or public.is_studyspace_owner(group_id));
create policy "read own and joined group sessions" on public.study_sessions for select to authenticated using(user_id=auth.uid() or (group_id is not null and public.is_studyspace_member(group_id)));
create policy "insert own sessions" on public.study_sessions for insert to authenticated with check(user_id=auth.uid() and (group_id is null or public.is_studyspace_member(group_id)));
create policy "edit own sessions" on public.study_sessions for update to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid() and (group_id is null or public.is_studyspace_member(group_id)));
create policy "delete own sessions" on public.study_sessions for delete to authenticated using(user_id=auth.uid());

grant select,update on public.profiles to authenticated;
grant select,update,delete on public.study_groups to authenticated;
grant select,delete on public.group_members to authenticated;
grant select,insert,delete on public.group_messages to authenticated;
grant select,insert,update,delete on public.study_sessions to authenticated;
grant execute on function public.create_studyspace_group(text) to authenticated;
grant execute on function public.join_studyspace_group(text) to authenticated;
grant execute on function public.is_studyspace_member(uuid) to authenticated;
grant execute on function public.is_studyspace_owner(uuid) to authenticated;
grant execute on function public.can_view_studyspace_profile(uuid) to authenticated;
revoke execute on function public.create_studyspace_group(text) from public, anon;
revoke execute on function public.join_studyspace_group(text) from public, anon;

-- Allow private realtime presence only to signed-in members of that group.
create policy "members receive group presence" on realtime.messages for select to authenticated using(
  extension='presence' and realtime.topic() ~ '^study-group:[0-9a-fA-F-]{36}$'
  and public.is_studyspace_member(substring(realtime.topic() from 13)::uuid)
);
create policy "members publish group presence" on realtime.messages for insert to authenticated with check(
  extension='presence' and realtime.topic() ~ '^study-group:[0-9a-fA-F-]{36}$'
  and public.is_studyspace_member(substring(realtime.topic() from 13)::uuid)
);

-- Enable database-change events used to refresh chat, rosters, and rankings.
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='group_messages') then
    alter publication supabase_realtime add table public.group_messages;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='group_members') then
    alter publication supabase_realtime add table public.group_members;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='study_sessions') then
    alter publication supabase_realtime add table public.study_sessions;
  end if;
end; $$;
