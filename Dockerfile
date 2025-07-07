FROM amazonlinux:2

ARG ANT_VERSION
ARG DEPENDENCY_CHECK_VERSION
ARG IVY_VERSION
ARG SONAR_SCANNER_VERSION

ENV TZ="Europe/London"

RUN yum upgrade -y && \
    yum install -y \
    findutils \
    git \
    make \
    java-1.8.0-openjdk \
    java-1.8.0-openjdk-devel \
    java-1.8.0-openjdk-headless \
    java-17-amazon-corretto-headless \
    tar \
    unzip \
    zip && \
    yum clean all

COPY resources/ /resources/

RUN unzip /resources/apache-ant-${ANT_VERSION}-bin.zip -d /usr/share/ && \
    unzip /resources/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-x64.zip -d /usr/share/ && \
    unzip /resources/dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip -d /usr/share && \
    mv /resources/ivy-${IVY_VERSION}.jar /usr/share/apache-ant-${ANT_VERSION}/lib/

RUN rm -rf /resources/

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV JAVA_17_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
ENV PATH="$PATH:/usr/share/apache-ant-${ANT_VERSION}/bin:/usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux-x64/bin:/usr/share/dependency-check/bin"

RUN update-alternatives --remove java "${JAVA_17_HOME}/bin/java"
