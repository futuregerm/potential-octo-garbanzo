FROM metabase/metabase:latest

# Set database type to PostgreSQL
ENV MB_DB_TYPE=postgres

# Railway will provide these PostgreSQL variables automatically
# We'll use a startup script to pass them to Metabase
COPY --chmod=755 <<EOF /docker-entrypoint.sh
#!/bin/bash
export MB_DB_HOST=\${PGHOST}
export MB_DB_PORT=\${PGPORT:-5432}
export MB_DB_USER=\${PGUSER}
export MB_DB_PASS=\${PGPASSWORD}
export MB_DB_DBNAME=\${PGDATABASE}

# Debug: Print connection info (without password)
echo "Connecting to PostgreSQL:"
echo "Host: \${MB_DB_HOST}"
echo "Port: \${MB_DB_PORT}"
echo "Database: \${MB_DB_DBNAME}"
echo "User: \${MB_DB_USER}"

# Start Metabase
exec /app/run_metabase.sh
EOF

EXPOSE 3000

ENTRYPOINT ["/docker-entrypoint.sh"]