FROM ruby:3.2.4

WORKDIR /app

# Instala Node.js e Yarn (necessário para asset pipeline)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# Instala bundler
RUN gem install bundler:2.3.26

# Copia e instala as gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia a aplicação
COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]