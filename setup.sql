-- Supabase > SQL Editor > New query > paste > Run
-- Step 1: change 'CHANGE_ME' below to your own secret PIN (share it only with cleaners)

create table booking (
  id int primary key check (id = 1),
  data jsonb not null default '{}',
  updated_at timestamptz default now()
);
insert into booking (id, data) values (1, '{}');

alter table booking enable row level security;
-- Anyone with the link can VIEW. Nobody can write directly.
create policy "public read" on booking for select using (true);

-- Only this function can write, and only with the correct PIN.
create or replace function save_booking(pin text, payload jsonb)
returns void language plpgsql security definer as $$
begin
  if pin <> 'CHANGE_ME' then raise exception 'wrong pin'; end if;
  update booking set data = payload, updated_at = now() where id = 1;
end $$;
grant execute on function save_booking(text, jsonb) to anon;
