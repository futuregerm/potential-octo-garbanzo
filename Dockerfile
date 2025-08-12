FROM metabase/metabase:latest

# Configure PostgreSQL as the application database
ENV MB_DB_TYPE=postgres

# Optimize for faster Railway startup
ENV MB_JETTY_HOST=0.0.0.0
ENV MB_JETTY_PORT=3000

# Reduce memory allocation for Railway's smaller containers
ENV JAVA_OPTS="-Xms512m -Xmx1g -Djava.awt.headless=true -Dfile.encoding=UTF-8"

EXPOSE 3000