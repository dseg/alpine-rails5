FROM alpine:3.3

MAINTAINER Daichi Shinozaki <dsdseg@gmail.com>

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base git cmake bash" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev postgresql-dev libffi-dev libc-dev" \
    RUBY_PACKAGES="ruby ruby-io-console ruby-json yaml nodejs" \
    RAILS_VERSION="5.0.0beta2"

RUN \ 
 apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES && \
  gem install -N bundler

RUN gem install -N nokogiri -- --use-system-libraries && \
  gem install -N rails --version "$RAILS_VERSION" && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  install -m644 ~/.gemrc /etc/gemrc && \

  # cleanup and settings
  bundle config --global build.nokogiri  "--use-system-libraries" && \
  bundle config --global build.nokogumbo "--use-system-libraries" && \
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem


RUN gem install byebug
RUN gem install database_cleaner
RUN gem install codeclimate-test-reporter
RUN gem install capybara
RUN gem install poltergeist
RUN gem install fuubar
RUN gem install rspec-rails
RUN gem install shoulda-matchers
RUN gem install guard-rspec
RUN gem install factory_girl_rails

# pronto integration
RUN gem install pronto
RUN gem install pronto-rubocop
RUN gem install pronto-scss

RUN apk del $DEV_PACKAGES $BUILD_PACKAGES

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
