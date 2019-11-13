FROM openshift/base-centos7

WORKDIR /root/

ARG OPENRESTY_RPM_VERSION="1.15.8.1"
ARG LUAROCKS_VERSION="2.3.0"
ARG RESTY_CONFIG_OPTIONS="\
    --with-compat \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    "
ARG RESTY_CONFIG_OPTIONS_MORE=""

WORKDIR /tmp

RUN yum clean all -y \
 && yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo \
 && yum install -y epel-release \
 && yum upgrade -y \
 && yum install -y \
    perl-Test-Nginx perl-TAP-Harness-JUnit \
    perl-local-lib perl-App-cpanminus \
    libyaml-devel \
    gdb vim luarocks geoip-devel\
    ccache gcc make perl systemtap-sdt-devel perl-File-Temp \
 && yum install -y \
        openresty-openssl \
    && echo "Cleaning all dependencies" \
    &&  yum clean all -y

RUN wget https://openresty.org/download/openresty-${OPENRESTY_RPM_VERSION}.tar.gz -O openresty.tar.gz \
  && tar xfz openresty.tar.gz

RUN cd openresty-${OPENRESTY_RPM_VERSION} \
  && ./configure ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE} \
  && make \
  && make install

ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin
