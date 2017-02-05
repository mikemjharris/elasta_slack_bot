FROM elixir:1.3-slim

RUN apt-get update
RUN apt-get install -y git

RUN mkdir -p /var/www/

ADD . /var/www/

WORKDIR /var/www/

RUN mix local.rebar
RUN mix local.hex --force
RUN mix deps.get

CMD mix run --no-halt
