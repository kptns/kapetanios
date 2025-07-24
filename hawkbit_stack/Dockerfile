FROM docker/compose:1.29.2

WORKDIR /app
COPY docker/hawkbit_monolith_mysql_fixed.yml .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["sh", "./entrypoint.sh"]
