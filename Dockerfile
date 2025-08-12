FROM metabase/metabase:latest

# Configure PostgreSQL as the application database
ENV MB_DB_TYPE=postgres

# Optimize for Railway startup times
ENV JAVA_OPTS="-Xms2g -Xmx4g -Djava.awt.headless=true -Dfile.encoding=UTF-8"

# Create a simple startup wrapper
COPY --chmod=755 <<EOF /startup-wrapper.sh
#!/bin/bash
echo "Starting Metabase for Railway..."

# Start a simple HTTP server on port 3000 immediately for health checks
nohup bash -c 'while true; do echo -e "HTTP/1.1 200 OK\n\nStarting..." | nc -l -p 3000 -q 1; done' &
TEMP_PID=\$!

# Start the actual Metabase
exec /app/run_metabase.sh
EOF

EXPOSE 3000

ENTRYPOINT ["/startup-wrapper.sh"]