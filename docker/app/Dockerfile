FROM ruby:3.1.2
RUN apt-get --allow-releaseinfo-change update -qq && apt-get install -y build-essential libpq-dev nodejs ssh

# Set an environment variable where the Rails app is installed to inside of Docker image

ENV RAILS_ROOT /var/www/tts_webapp
RUN mkdir -p $RAILS_ROOT
RUN mkdir -p tmp/pids/

# Set working directory
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler --no-document
RUN bundle config set without 'development test'
RUN bundle install --jobs $(nproc) --retry 5 --path=vendor

# Adding project files
COPY . .
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "--pid", "/tmp/server.pid"]

# EXPOSE 5000
# foreman start -f Procfile.dev