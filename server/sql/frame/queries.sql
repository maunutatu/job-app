-- name: GetJobListings :many
SELECT
    jl.id,
    jl.title,
    jl.description,
    jl.salary,
    c.name AS company,
    jl.date_posted,
    jl.start_date,
    jl.end_date,
    jl.location,
    jl.field,
    jl.working_hours,
    jl.employment_type
FROM
    job_listing jl
        JOIN
    company c ON jl.company = c.id;
