FROM darthjee/ruby_gems:0.5.4 as base
FROM darthjee/scripts:0.1.8 as scripts

######################################

FROM base as builder

COPY --chown=app ./ /home/app/app/
COPY --chown=app:app --from=scripts /home/scripts/builder/bundle_builder.sh /usr/local/sbin/

ENV HOME_DIR /home/app
RUN bundle_builder.sh

#######################
#FINAL IMAGE
FROM base
RUN mkdir lib/arstotzka -p

COPY --chown=app:app --from=builder /home/app/bundle/ /usr/local/bundle/

COPY --chown=app ./*.gemspec ./Gemfile /home/app/app/
COPY --chown=app ./lib/arstotzka/version.rb /home/app/app/lib/arstotzka/

RUN bundle install
