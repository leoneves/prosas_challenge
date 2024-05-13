# Prosas challenge

### How to run in development

First, up the dependencies services:

```bash
make dependencies.start.dev
```

Inside project directory do:

- bundle install
- RAILS_ENV=development bundle e rails db:create
- RAILS_ENV=development bundle e rails db:migrate
- RAILS_ENV=development bundle e rails s

### How to run tests

First, up the dependencies services:

```bash
make dependencies.start.test
```

Then inside backend project directory do:

- bundle install
- RAILS_ENV=test bundle e rails db:create
- RAILS_ENV=test rails db:migrate
- bundle e rspec

### To run Lints for this project

- make rubocop