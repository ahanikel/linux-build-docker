FROM linux-builder-base:1.0.0
COPY build-linux-internal .
RUN git pull origin master && git fetch --tags
