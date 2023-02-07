FROM ruby:3.1.3

ENV LANG=en_GB.UTF-8
ENV EPB_API_URL=http://epb-register-api
ENV EPB_AUTH_CLIENT_ID=6f61579e-e829-47d7-aef5-7d36ad068bee
ENV EPB_AUTH_CLIENT_SECRET=test-client-secret
ENV EPB_AUTH_SERVER=http://epb-auth-server/auth
ENV EPB_UNLEASH_URI=http://epb-feature-flag/api
ENV JWT_ISSUER=epb-auth-server
ENV JWT_SECRET=test-jwt-secret
ENV STAGE=development

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


COPY . /app
WORKDIR /app

RUN bundle install
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -; \
    apt-get update -qq && apt-get install -qq --no-install-recommends nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN cd /app && npm install && make frontend-build

EXPOSE 80 443

ENTRYPOINT ["bundle", "exec", "rackup", "-p", "80", "-o", "0.0.0.0"]
