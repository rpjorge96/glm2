# GLM

## Dependencies

Install rvm

```bash
\curl -sSL https://get.rvm.io | bash -s stable
```

Install Ruby

```bash
rvm install 3.3.0
```

Install NVM

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

Install Node

```bash
nvm install 20.18.0
nvm alias default 20.18.0
```

-- Install Postgres 15 (using docker)

```bash
docker run --name postgres -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 postgres:15
```

## Setup

```bash
bundle install
npm install
```

### Database

```bash
rails db:create
rails db:migrate
rails db:seed
```

## Run

```bash
rails s -p 3007
```

```bash
rails tailwindcss:watch
```

## Linters

Ruby

```bash
standardrb
standardrb --fix
```

Javascript

```bash
npm run lint:check
npm run lint:fix
```

**_WIP_**
