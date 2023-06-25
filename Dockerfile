FROM ruby:3.2.1

RUN mkdir -p /usr/src/app
ENV APP_HOME /usr/src/app

WORKDIR $APP_HOME

RUN apt-get update && apt-get install -y nodejs postgresql-client nano --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY Gemfile Gemfile.lock $APP_HOME/

RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY . $APP_HOME

RUN bundle exec rake DATABASE_URL=postgresql:does_not_exist assets:precompile

ENTRYPOINT [ "/usr/src/app/bin/docker-entrypoint" ]

EXPOSE 3000
CMD ['rails', 'server', '-b', '0.0.0.0']
