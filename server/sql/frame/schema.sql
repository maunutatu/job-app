CREATE TABLE IF NOT EXISTS company (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    website TEXT NOT NULL,
    email TEXT NOT NULL,
    phone_number TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS job_listing (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    company INTEGER REFERENCES company(id) NOT NULL,
    date_posted DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    location TEXT NOT NULL,
    field TEXT NOT NULL,
    working_hours TEXT NOT NULL,
    employment_type TEXT NOT NULL,
    schedule TEXT NOT NULL
    );

CREATE TABLE IF NOT EXISTS "user" (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number TEXT NOT NULL,
    email TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    experience TEXT NOT NULL,
    education TEXT NOT NULL,
    skills TEXT[] NOT NULL
    );

CREATE TABLE IF NOT EXISTS job_application (
    id SERIAL PRIMARY KEY,
    "user" INTEGER REFERENCES "user"(id) NOT NULL,
    job_listing INTEGER REFERENCES job_listing(id) NOT NULL,
    cover_letter TEXT,
    status TEXT NOT NULL,
    sent_date DATE,
    relevant_skills TEXT[]
    );

CREATE TABLE IF NOT EXISTS user_favorite_job_listing (
    id SERIAL PRIMARY KEY,
    "user" INTEGER REFERENCES "user"(id) NOT NULL,
    job_listing INTEGER REFERENCES job_listing(id) NOT NULL,
    UNIQUE ("user", job_listing)
    );