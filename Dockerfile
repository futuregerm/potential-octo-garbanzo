FROM metabase/metabase:latest

# Set database type to PostgreSQL
ENV MB_DB_TYPE=postgres

# Railway startup script to handle both auto-connected and manual PostgreSQL variables
COPY --chmod=755 <<EOF /docker-entrypoint.sh
#!/bin/bash

# First, try Railway's auto-connected PostgreSQL variables
if [ -n "\${PGHOST}" ] && [ -n "\${PGUSER}" ] && [ -n "\${PGDATABASE}" ]; then
    echo "Using Railway's auto-connected PostgreSQL service"
    export MB_DB_HOST="\${PGHOST}"
    export MB_DB_PORT="\${PGPORT:-5432}"
    export MB_DB_USER="\${PGUSER}"
    export MB_DB_PASS="\${PGPASSWORD}"
    export MB_DB_DBNAME="\${PGDATABASE}"
# Fallback to manual environment variables if auto-connection failed
elif [ -n "\${MB_DB_HOST}" ] && [ -n "\${MB_DB_USER}" ] && [ -n "\${MB_DB_DBNAME}" ]; then
    echo "Using manually configured PostgreSQL environment variables"
    # Variables are already set via Railway dashboard
else
    echo "ERROR: No PostgreSQL connection configured!"
    echo "Please either:"
    echo "1. Connect PostgreSQL service in Railway dashboard, OR"
    echo "2. Set manual environment variables: MB_DB_HOST, MB_DB_USER, MB_DB_PASS, MB_DB_DBNAME"
    exit 1
fi

# Debug: Print connection info (without password)
echo "Connecting to PostgreSQL:"
echo "Host: \${MB_DB_HOST}"
echo "Port: \${MB_DB_PORT:-5432}"
echo "Database: \${MB_DB_DBNAME}"
echo "User: \${MB_DB_USER}"
echo "Password: [REDACTED]"

# Start Metabase
exec /app/run_metabase.sh
EOF

EXPOSE 3000

ENTRYPOINT ["/docker-entrypoint.sh"]