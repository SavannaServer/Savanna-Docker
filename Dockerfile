FROM debian:bullseye-slim
LABEL org.opencontainers.image.source=https://github.com/ユーザ名/リポジトリ名
WORKDIR /opt/
RUN apt-get update && apt-get install -y openjdk-17-jdk wget curl git && apt-get clean
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.tar.gz \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
COPY setup.sh /opt/
ENV MEMORY=4G
ENV VERSION=1.19.3
ENTRYPOINT ["/bin/sh", "setup.sh"]
