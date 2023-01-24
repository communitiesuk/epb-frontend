FROM ruby:3.1.2

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

EXPOSE 80

ENTRYPOINT ["bundle", "exec", "rackup", "-p", "80", "-o", "0.0.0.0"]
