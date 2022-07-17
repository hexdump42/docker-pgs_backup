FROM postgres:latest
LABEL version="0.1"
LABEL description="Backup a postgresql database using pg_dump & optionally copy backup to S3."

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install s3cmd

WORKDIR /app

COPY *.sh .

RUN chmod +x *.sh

VOLUME /backup

ENTRYPOINT ["/app/start.sh"]
CMD [""]