# Contacts Importer

Ruby on Rails app that allows the user to sign up and upload CSV files that import contacts.

This app makes use of **ActiveRecord Encryption**, so it's necessary to have a `config/master.key` (provided externally)

## Getting Started

### Requirements

- `ruby 3.1.2`
- `config/master.key` (Provided externally)

### Installation

#### With Docker (recommended)

- If it's the first time running the project, execute: `sh ./docker/initialize.sh`
- Then only start the container when needed with: `docker compose up`

#### Standalone

- `bundle install`
- `rails db:create db:migrate db:seed`
- `brew update && brew install mailhog` (More info on: [https://github.com/mailhog/MailHog#installation](https://github.com/mailhog/MailHog#installation))

### Running

#### With Docker (recommended)

- `docker compose up`

#### Standalone

- You can use `foreman`: `foreman start -f Procfile.dev`

Or:

- To run the web server, run: `rails s`
- To run the mail server, run the following on another tab: `mailhog`
- To run sidekiq, execute: `sidekiq`

### Running tests

- Execute: `rspec spec`


### Testing the App

#### Default User

- Email: admin@test.com
- Password: 123456

#### CSVs to upload

- [example_happy_path.csv](https://github.com/hepu/contacts-importer/blob/main/example_happy_path.csv): Case when all contacts are imported successfully (if it's the first time)
- [example_weird_headers.csv](https://github.com/hepu/contacts-importer/blob/main/example_weird_headers.csv): Case when CSV has weird headers to pair to
- [example_wrong_fields.csv](https://github.com/hepu/contacts-importer/blob/main/example_wrong_fields.csv): Case when the fields entered in the CSVs have format issues