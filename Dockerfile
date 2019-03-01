FROM darthjee/ruby_240:0.2.2

USER app
COPY ./ /home/app/app/

RUN gem uninstall bundler
RUN gem install bundler -v '1.17.3'
RUN bundle install
