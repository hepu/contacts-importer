FROM ruby:3.1.2

RUN apt-get -q update -yqq && apt-get install -yqq --no-install-recommends \
  curl \
  postgresql-contrib

SHELL ["/bin/bash", "-l", "-c"]

# Installing node with n
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
RUN bash n 16.13.2
RUN npm install -g npm@8.13.2

# Moving files
WORKDIR /app
ADD Gemfile* /app/

# Install gems
RUN gem install bundler:2.2.15
RUN bundle install

ADD . /app/

# Add a script to be executed every time the container starts.
COPY ./docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]