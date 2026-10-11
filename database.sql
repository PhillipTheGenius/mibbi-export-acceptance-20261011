-- Mibbi database plan 73168b919d64fd38398777548c82adeefd6ee8b2d2ffe4ed9ee8463207c1b494
-- All application writes are authenticated and owner-scoped.
begin;
set local lock_timeout = '5s';
set local statement_timeout = '20s';
select pg_advisory_xact_lock(hashtextextended('mb_4be82b6abf534739964887b84f1f5bc8',0));

do $$ begin if to_regclass('public."mb_4be82b6abf534739964887b84f1f5bc8_notes"') is not null and obj_description(to_regclass('public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'),'pg_class') is distinct from 'mibbi:4be82b6a-bf53-4739-9648-87b84f1f5bc8' then raise exception 'Database resource already exists outside Mibbi'; end if; end $$;

create table if not exists public."mb_4be82b6abf534739964887b84f1f5bc8_notes" (id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade, created_at timestamptz not null default now());
comment on table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" is 'mibbi:4be82b6a-bf53-4739-9648-87b84f1f5bc8';

alter table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" add column if not exists "title" text;

do $$ begin if (select format_type(atttypid,atttypmod) from pg_attribute where attrelid='public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'::regclass and attname='title' and not attisdropped) is distinct from 'text' then raise exception 'Existing column type differs from the reviewed plan'; end if; end $$;

do $$ begin if not exists(select 1 from pg_constraint where conrelid='public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'::regclass and conname='mb_length_title') then alter table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" add constraint "mb_length_title" check (char_length("title") <= 10000); end if; end $$;

alter table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" add column if not exists "amount" double precision;

do $$ begin if (select format_type(atttypid,atttypmod) from pg_attribute where attrelid='public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'::regclass and attname='amount' and not attisdropped) is distinct from 'double precision' then raise exception 'Existing column type differs from the reviewed plan'; end if; end $$;

alter table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" add column if not exists "done" boolean;

do $$ begin if (select format_type(atttypid,atttypmod) from pg_attribute where attrelid='public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'::regclass and attname='done' and not attisdropped) is distinct from 'boolean' then raise exception 'Existing column type differs from the reviewed plan'; end if; end $$;

alter table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" add column if not exists "day" date;

do $$ begin if (select format_type(atttypid,atttypmod) from pg_attribute where attrelid='public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'::regclass and attname='day' and not attisdropped) is distinct from 'date' then raise exception 'Existing column type differs from the reviewed plan'; end if; end $$;

alter table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" add column if not exists "attachment" text;

do $$ begin if (select format_type(atttypid,atttypmod) from pg_attribute where attrelid='public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'::regclass and attname='attachment' and not attisdropped) is distinct from 'text' then raise exception 'Existing column type differs from the reviewed plan'; end if; end $$;

do $$ begin if not exists(select 1 from pg_constraint where conrelid='public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'::regclass and conname='mb_length_attachment') then alter table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" add constraint "mb_length_attachment" check (char_length("attachment") <= 10000); end if; end $$;

do $$ begin if exists(select 1 from pg_policy where polrelid='public."mb_4be82b6abf534739964887b84f1f5bc8_notes"'::regclass and polname not in ('mibbi_read','mibbi_insert','mibbi_update','mibbi_delete')) then raise exception 'Existing access policies differ from the reviewed plan'; end if; end $$;

alter table public."mb_4be82b6abf534739964887b84f1f5bc8_notes" enable row level security;
revoke all on public."mb_4be82b6abf534739964887b84f1f5bc8_notes" from public, anon, authenticated;
grant select on public."mb_4be82b6abf534739964887b84f1f5bc8_notes" to authenticated;
grant insert, update, delete on public."mb_4be82b6abf534739964887b84f1f5bc8_notes" to authenticated;
grant all on public."mb_4be82b6abf534739964887b84f1f5bc8_notes" to service_role;

drop policy if exists "mibbi_read" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes";

drop policy if exists "mibbi_insert" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes";

drop policy if exists "mibbi_update" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes";

drop policy if exists "mibbi_delete" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes";

create policy "mibbi_read" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes" for select to authenticated using (owner_id = (select auth.uid()));
create policy "mibbi_insert" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes" for insert to authenticated with check (owner_id = (select auth.uid()));
create policy "mibbi_update" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes" for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
create policy "mibbi_delete" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes" for delete to authenticated using (owner_id = (select auth.uid()));
create index if not exists "mb_4be82b6abf534739964887b84f1f5bc8_notes_owner" on public."mb_4be82b6abf534739964887b84f1f5bc8_notes"(owner_id,created_at desc);

insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('mb_4be82b6abf534739964887b84f1f5bc8','mb_4be82b6abf534739964887b84f1f5bc8',false,5242880,array['image/jpeg','image/png','image/webp','application/pdf']) on conflict(id) do nothing;
do $$ begin if not exists(select 1 from storage.buckets where id='mb_4be82b6abf534739964887b84f1f5bc8' and public=false and file_size_limit=5242880 and allowed_mime_types=array['image/jpeg','image/png','image/webp','application/pdf']) then raise exception 'Storage settings differ from the reviewed plan'; end if; end $$;

drop policy if exists "mb_4be82b6abf534739964887b84f1f5bc8_private" on storage.objects;
create policy "mb_4be82b6abf534739964887b84f1f5bc8_private" on storage.objects as restrictive for all to public using (bucket_id <> 'mb_4be82b6abf534739964887b84f1f5bc8' or (storage.foldername(name))[1]=(select auth.uid())::text) with check (bucket_id <> 'mb_4be82b6abf534739964887b84f1f5bc8' or (storage.foldername(name))[1]=(select auth.uid())::text);
drop policy if exists "mb_4be82b6abf534739964887b84f1f5bc8_no_update" on storage.objects;
create policy "mb_4be82b6abf534739964887b84f1f5bc8_no_update" on storage.objects as restrictive for update to public using (bucket_id <> 'mb_4be82b6abf534739964887b84f1f5bc8') with check (bucket_id <> 'mb_4be82b6abf534739964887b84f1f5bc8');

drop policy if exists "mb_4be82b6abf534739964887b84f1f5bc8_select" on storage.objects;
create policy "mb_4be82b6abf534739964887b84f1f5bc8_select" on storage.objects for select to authenticated using (bucket_id='mb_4be82b6abf534739964887b84f1f5bc8' and (storage.foldername(name))[1]=(select auth.uid())::text);

drop policy if exists "mb_4be82b6abf534739964887b84f1f5bc8_insert" on storage.objects;
create policy "mb_4be82b6abf534739964887b84f1f5bc8_insert" on storage.objects for insert to authenticated with check (bucket_id='mb_4be82b6abf534739964887b84f1f5bc8' and (storage.foldername(name))[1]=(select auth.uid())::text);

drop policy if exists "mb_4be82b6abf534739964887b84f1f5bc8_delete" on storage.objects;
create policy "mb_4be82b6abf534739964887b84f1f5bc8_delete" on storage.objects for delete to authenticated using (bucket_id='mb_4be82b6abf534739964887b84f1f5bc8' and (storage.foldername(name))[1]=(select auth.uid())::text);

notify pgrst, 'reload schema';
commit;