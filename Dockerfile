FROM ruby:2.4.1

RUN mkdir /gem
WORKDIR /gem

RUN gem install bundler -v 1.16.1
