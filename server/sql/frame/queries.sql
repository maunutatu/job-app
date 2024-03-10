-- name: GetJobListings :many
SELECT jl.id,
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
FROM job_listing jl
         JOIN
     company c ON jl.company = c.id;

-- name: GetUser :one
SELECT u.id,
       u.first_name,
       u.last_name,
       u.phone_number,
       u.email,
       u.date_of_birth,
       u.experience,
       u.education,
       u.skills
FROM "user" u
WHERE u.id = $1;

-- name: GetUserJobApplications :many
SELECT ja.id,
       ja."user",
       ja.job_listing,
       ja.cover_letter,
       ja.status,
       ja.sent_date,
       ja.relevant_skills,
       jl.title AS job_title,
       c.name   AS company
FROM job_application ja
         JOIN
     job_listing jl ON ja.job_listing = jl.id
         JOIN
     company c ON jl.company = c.id
WHERE ja.user = $1;

-- name: GetUserFavoriteJobListings :many
SELECT jl.id,
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
FROM user_favorite_job_listing ufl
         JOIN
     job_listing jl ON jl.id = ufl.job_listing
         JOIN
     company c ON jl.company = c.id
WHERE ufl."user" = $1;

-- name: CreateUser :one
INSERT INTO "user" (first_name, last_name, phone_number, email, date_of_birth, experience, education, skills)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: UpdateUser :one
UPDATE "user"
SET first_name    = $2,
    last_name     = $3,
    phone_number  = $4,
    email         = $5,
    date_of_birth = $6,
    experience    = $7,
    education     = $8,
    skills        = $9
WHERE id = $1
RETURNING *;