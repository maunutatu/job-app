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
    employment_type TEXT NOT NULL
    );
