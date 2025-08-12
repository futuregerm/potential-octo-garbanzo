FROM metabase/metabase:latest

# Configure PostgreSQL as the application database
ENV MB_DB_TYPE=postgres

EXPOSE 3000