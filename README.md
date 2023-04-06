# Contacts Importer

Ruby on Rails app that allows the user to sign up and upload CSV files that import contacts

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

- To run the web server, run: `rails s`
- To run the mail server, run the following on another tab: `mailhog`

### Running tests

- Execute: `rspec spec`


### Testing the App

#### Default User

- Email: admin@test.com
- Password: 123456

#### CSVs to upload

- example_happy_path.csv
- example_weird_headers.csv
- example_wrong_fields.csv