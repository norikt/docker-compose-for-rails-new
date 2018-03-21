FROM ruby:2.5.0-alpine

ENV BUILD_PACKAGES="build-base bash" \
    DEV_PACKAGES="curl-dev ruby-dev zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev curl mariadb-client" \
    RUBY_PACKAGES="ruby-json yaml nodejs yarn" \
    RAILS_ROOT="/myapp"

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories \
    && apk update && apk add --no-cache \
    $BUILD_PACKAGES \
    $DEV_PACKAGES \
    $RUBY_PACKAGES \
    && apk add --no-cache --virtual gem_dep_packages \
    mariadb-dev \
    imagemagick6 \
    imagemagick6-dev \
    linux-headers \
    git \
    ### TZ
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    ###
    && mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT
COPY . $RAILS_ROOT
EXPOSE 3000
RUN bundle config build.nokogiri --use-system-libraries \
    && bundle install -j4 \
    && bundle clean \
