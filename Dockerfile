FROM elixir:1.3-slim

RUN mkdir -p /var/www/

ADD . /var/www/

WORKDIR /var/www/

RUN mix local.rebar
RUN mix local.hex --force
RUN mix deps.get

CMD mix run --no-halt
