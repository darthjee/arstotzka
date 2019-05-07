FROM darthjee/ruby_gems:0.0.2

USER app
COPY --chown=app ./ /home/app/app/

RUN bundle install
