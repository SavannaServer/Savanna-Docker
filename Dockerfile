FROM debian:bullseye-slim
WORKDIR /opt/
RUN apt-get update && apt-get install -y openjdk-17-jdk wget maven git && apt-get clean
COPY setup.sh /opt/
ENV MEMORY=4G
ENV VERSION=1.19.3
ENTRYPOINT ["/bin/sh", "install-maven.sh", "setup.sh"]
