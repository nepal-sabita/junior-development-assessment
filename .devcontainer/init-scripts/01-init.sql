-- Create schemas
CREATE SCHEMA IF NOT EXISTS operators;

-- Grant permissions
GRANT ALL ON SCHEMA operators TO postgres;

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Log initialization
DO $$
BEGIN
    RAISE NOTICE 'Database payment_platform initialized successfully';
END $$;
