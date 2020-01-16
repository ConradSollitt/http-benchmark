FROM ruby:2.6-alpine

WORKDIR /usr/src/app

{{#files}}
  COPY {{{.}}}
{{/files}}

RUN apk add build-base

RUN bundle install --without development test

{{#environment}}
ENV {{{.}}}
{{/environment}}

CMD {{{command}}}
