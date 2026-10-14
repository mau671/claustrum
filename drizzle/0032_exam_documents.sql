create type evaluation_type as enum ('parcial', 'quiz', 'final', 'reposicion', 'tarea', 'proyecto', 'otro');
create type evaluation_status as enum ('pending', 'approved', 'rejected');

create table course_evaluations (
  id bigserial primary key,
  course_id int not null references public.course(id) on delete cascade,
  academic_term_id int references public.academic_term(id) on delete set null,
  professor_id bigint references public.professor(id) on delete set null,
  uploaded_by uuid not null references auth.users(id) on delete cascade,
  evaluation_type evaluation_type not null default 'otro',
  evaluation_number int,
  custom_name text,
  is_catedra boolean not null default true,
  includes_answers boolean not null default false,
  has_separate_answers boolean not null default false,
  file_key text not null,
  file_size bigint not null,
  file_sha256 text not null,
  answers_file_key text,
  answers_file_size bigint,
  answers_file_sha256 text,
  status evaluation_status not null default 'pending',
  moderation_note text,
  moderated_by uuid references auth.users(id) on delete set null,
  moderated_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_course_evaluations_course_status on course_evaluations(course_id, status);
create index idx_course_evaluations_uploaded_by on course_evaluations(uploaded_by);
create index idx_course_evaluations_pending on course_evaluations(status) where status = 'pending';
create index idx_course_evaluations_created_at on course_evaluations(created_at desc);

alter table course_evaluations enable row level security;

create policy "Anyone can read approved evaluations"
  on course_evaluations
  for select
  using (status = 'approved');

create policy "Users can read their own pending/rejected evaluations"
  on course_evaluations
  for select
  to authenticated
  using (uploaded_by = auth.uid() or status = 'approved');

create policy "Admins can read all evaluations"
  on course_evaluations
  for select
  to authenticated
  using (public.is_admin());

create policy "Authenticated users can upload evaluations"
  on course_evaluations
  for insert
  to authenticated
  with check (uploaded_by = auth.uid());

create policy "Admins can moderate evaluations"
  on course_evaluations
  for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

create policy "Users can delete their own pending evaluations"
  on course_evaluations
  for delete
  to authenticated
  using (uploaded_by = auth.uid() and status = 'pending');

create policy "Admins can delete any evaluation"
  on course_evaluations
  for delete
  to authenticated
  using (public.is_admin());

create or replace function get_course_evaluations(p_course_id int)
returns table (
  id bigint,
  course_id int,
  academic_term_id int,
  professor_id bigint,
  uploaded_by uuid,
  evaluation_type text,
  evaluation_number int,
  custom_name text,
  is_catedra boolean,
  includes_answers boolean,
  has_separate_answers boolean,
  file_key text,
  file_size bigint,
  answers_file_key text,
  status text,
  created_at timestamptz,
  term_display_name text,
  professor_name text
)
language sql
stable
as $$
  select
    e.id,
    e.course_id,
    e.academic_term_id,
    e.professor_id,
    e.uploaded_by,
    e.evaluation_type::text,
    e.evaluation_number,
    e.custom_name,
    e.is_catedra,
    e.includes_answers,
    e.has_separate_answers,
    e.file_key,
    e.file_size,
    e.answers_file_key,
    e.status::text,
    e.created_at,
    at.display_name as term_display_name,
    p.full_name as professor_name
  from course_evaluations e
  left join public.academic_term at on at.id = e.academic_term_id
  left join public.professor p on p.id = e.professor_id
  where e.course_id = p_course_id
    and e.status = 'approved'
  order by e.created_at desc;
$$;

create or replace function get_evaluation_moderation_queue(p_status evaluation_status, p_limit int default 50, p_offset int default 0)
returns table (
  id bigint,
  course_id int,
  course_code text,
  course_name text,
  academic_term_id int,
  term_display_name text,
  professor_id bigint,
  professor_name text,
  uploaded_by uuid,
  uploader_email text,
  evaluation_type text,
  evaluation_number int,
  custom_name text,
  is_catedra boolean,
  includes_answers boolean,
  has_separate_answers boolean,
  file_key text,
  file_size bigint,
  answers_file_key text,
  status text,
  moderation_note text,
  created_at timestamptz,
  total_count bigint
)
language sql
stable
as $$
  with counts as (
    select count(*) as total from course_evaluations where course_evaluations.status = p_status
  )
  select
    e.id,
    e.course_id,
    c.code as course_code,
    c.name as course_name,
    e.academic_term_id,
    at.display_name as term_display_name,
    e.professor_id,
    p.full_name as professor_name,
    e.uploaded_by,
    au.email as uploader_email,
    e.evaluation_type::text,
    e.evaluation_number,
    e.custom_name,
    e.is_catedra,
    e.includes_answers,
    e.has_separate_answers,
    e.file_key,
    e.file_size,
    e.answers_file_key,
    e.status::text,
    e.moderation_note,
    e.created_at,
    (select total from counts) as total_count
  from course_evaluations e
  join public.course c on c.id = e.course_id
  left join public.academic_term at on at.id = e.academic_term_id
  left join public.professor p on p.id = e.professor_id
  left join auth.users au on au.id = e.uploaded_by
  where e.status = p_status
  order by e.created_at desc
  limit p_limit offset p_offset;
$$;
