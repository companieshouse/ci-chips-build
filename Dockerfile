FROM 416670754337.dkr.ecr.eu-west-2.amazonaws.com/ci-base-build:latest

ARG ANT_VERSION
ARG DEPENDENCY_CHECK_VERSION
ARG IVY_VERSION
ARG SONAR_SCANNER_VERSION

ENV TZ="Europe/London"

RUN dnf upgrade -y && \
    dnf install -y \
    findutils \
    java-21-amazon-corretto-devel-21.0.13* \
    nodejs20 && \
    dnf clean all

# Workaround pending release of amazonlinux:2023.12.20261117 to dockerhub
RUN dnf update -y java-21-amazon-corretto-devel java-17-amazon-corretto-headless --releasever 2023.12.20261117

COPY resources/ /resources/

RUN unzip /resources/apache-ant-${ANT_VERSION}-bin.zip -d /usr/share/ && \
    unzip /resources/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-x64.zip -d /usr/share/ && \
    unzip /resources/dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip -d /usr/share && \
    mv /resources/ivy-${IVY_VERSION}.jar /usr/share/apache-ant-${ANT_VERSION}/lib/

RUN rm -rf /resources/

ENV JAVA_HOME=/usr/java/default
ENV PATH="$PATH:/usr/share/apache-ant-${ANT_VERSION}/bin:/usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux-x64/bin:/usr/share/dependency-check/bin"

RUN update-alternatives --remove java "${JAVA_17_HOME}/bin/java"
