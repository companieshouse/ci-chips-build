FROM 416670754337.dkr.ecr.eu-west-2.amazonaws.com/ci-base-build:1.0.3

ARG ANT_VERSION
ARG DEPENDENCY_CHECK_VERSION
ARG IVY_VERSION
ARG ORACLE_JDK_VERSION
ARG SONAR_SCANNER_VERSION

RUN dnf upgrade -y && \
    dnf install -y \
    findutils \
    java-21-amazon-corretto-headless && \
    dnf clean all

COPY resources/ /resources/

RUN unzip /resources/apache-ant-${ANT_VERSION}-bin.zip -d /usr/share/ && \
    unzip /resources/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-x64.zip -d /usr/share/ && \
    unzip /resources/dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip -d /usr/share && \
    mv /resources/ivy-${IVY_VERSION}.jar /usr/share/apache-ant-${ANT_VERSION}/lib/ && \
    rpm -ivh /resources/jdk-${ORACLE_JDK_VERSION}-linux-x64.rpm

RUN rm -rf /resources/

ENV PATH="$PATH:/usr/share/apache-ant-${ANT_VERSION}/bin:/usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux-x64/bin:/usr/share/dependency-check/bin"
ENV JAVA_HOME=/usr/java/default
ENV JAVA_21_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64

RUN update-alternatives --remove java /usr/lib/jvm/java-21-amazon-corretto.x86_64/bin/java
