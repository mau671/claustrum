CREATE OR REPLACE FUNCTION public.get_academic_units_with_professors()
RETURNS TABLE (
    id INTEGER,
    code TEXT,
    name TEXT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
AS $$
    SELECT DISTINCT au.id, au.code, au.name
    FROM public.academic_unit au
    JOIN public.course_offering co ON co.academic_unit_id = au.id
    JOIN public.course_offering_group cog ON cog.course_offering_id = co.id
    JOIN public.course_offering_group_professor cogp ON cogp.course_offering_group_id = cog.id
    ORDER BY au.name;
$$;
