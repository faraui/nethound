FROM debian:12.5-slim
RUN apt-get update \
    && apt-get install -y dnsutils \
    && 
