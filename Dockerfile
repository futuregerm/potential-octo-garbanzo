FROM metabase/metabase:latest

# Set environment variables to use PostgreSQL when DATABASE_URL is available
ENV MB_DB_TYPE=postgres
ENV MB_DB_CONNECTION_URI=`$DATABASE_URL

EXPOSE 3000