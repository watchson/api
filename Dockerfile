FROM ruby:2.6

WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install --without development test
COPY . /app
EXPOSE 8080

ENV PORT $PORT

HEALTHCHECK --interval=60s --timeout=60s --retries=3 \
  CMD curl -f "http://0.0.0.0:${PORT}/health" || exit 1

CMD foreman start
