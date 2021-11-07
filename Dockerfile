FROM ubuntu:18.04
RUN set -xe  \
        && echo '#!/bin/sh' > /usr/sbin/policy-rc.d  \
        && echo 'exit 101' >> /usr/sbin/policy-rc.d  \
        && chmod +x /usr/sbin/policy-rc.d  \
        && dpkg-divert --local --rename --add /sbin/initctl  \
        && cp -a /usr/sbin/policy-rc.d /sbin/initctl  \
        && sed -i 's/^exit.*/exit 0/' /sbin/initctl  \
        && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup  \
        && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean  \
        && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean  \
        && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean  \
        && echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages  \
        && echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes  \
        && echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests
RUN rm -rf /var/lib/apt/lists/*
RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
RUN mkdir -p /run/systemd  \
        && echo 'docker' > /run/systemd/container
CMD ["/bin/bash"]
ENV DEBIAN_FRONTEND=noninteractive TERM=xterm
RUN  apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN buildDeps='software-properties-common'; set -x  \
        # && apt-get --allow-releaseinfo-change update  \
        && apt-get update  \
        && apt-get install -y $buildDeps --no-install-recommends  \
        && add-apt-repository ppa:ts.sch.gr/ppa \
        # && add-apt-repository ppa:webupd8team/java -y  \
        && apt-get update -y  \
                # && apt-get --allow-releaseinfo-change update  \
        && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections  \
        && apt-get install -y oracle-java8-installer  \
        && apt-get install -y oracle-java8-set-default  \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  \
        && apt-get purge -y --auto-remove $buildDeps  \
        && apt-get autoremove -y  \
        && apt-get clean
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/tools_r25.2.5-linux.zip ANDROID_BUILD_TOOLS_VERSION=27.0.0 ANDROID_APIS=android-10,android-15,android-16,android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25,android-26 ANT_HOME=/usr/share/ant MAVEN_HOME=/usr/share/maven GRADLE_HOME=/usr/share/gradle ANDROID_HOME=/opt/android
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/android/tools:/opt/android/platform-tools:/opt/android/build-tools/27.0.0:/usr/share/ant/bin:/usr/share/maven/bin:/usr/share/gradle/bin
WORKDIR /opt
RUN dpkg --add-architecture i386  \
        # && apt-get -qq --allow-releaseinfo-change update  \
        && apt-get -qq update  \
        && apt-get -qq install -y wget curl maven ant gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386  \
        && mkdir android  \
        && cd android  \
        && wget -O tools.zip ${ANDROID_SDK_URL}  \
        && unzip tools.zip  \
        && rm tools.zip  \
        && echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION}  \
        && chmod a+x -R $ANDROID_HOME  \
        && chown -R root:root $ANDROID_HOME  \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  \
        && apt-get autoremove -y  \
        && apt-get clean
ENV NODEJS_VERSION=10.15.1 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/android/tools:/opt/android/platform-tools:/opt/android/build-tools/27.0.0:/usr/share/ant/bin:/usr/share/maven/bin:/usr/share/gradle/bin:/opt/node/bin
WORKDIR /opt/node
RUN apt-get update  \
        # && apt-get --allow-releaseinfo-change update  \
        && apt-get install -y curl git ca-certificates --no-install-recommends  \
        && curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1  \
        && rm -rf /var/lib/apt/lists/*  \
        && apt-get clean
ENV CORDOVA_VERSION=8.0.0
WORKDIR /tmp
RUN npm i -g --unsafe-perm cordova@${CORDOVA_VERSION}
RUN npm install -g @vue/cli  \
        && npm install -g @vue/cli-init  \
        && npm install -g quasar-cli  \
        && npm install -g yarn
WORKDIR /app%  
