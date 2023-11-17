# Course Registration Application

This Repo contains the code for an application created to manage course registrations. 
Its build as fullstack SvelteKit application, together with another container for cron jobs. 
It has build-in user management, support for sending emails and push notifications.


## Installation

- Install NodeJs from [here](https://nodejs.org/en/download/)
- Install Docker from [here](https://docs.docker.com/get-docker/)
- Install Docker Compose from [here](https://docs.docker.com/compose/install/)
- Clone this repo
- Run `pnpm install` in the `server` folder

## Usage

- Copy the `.env.example` file in the `server` folder to `.env.local` and fill in the values
- Run `docker-compose up` in the root folder for the database
- Run `pnpm dev` in the `server` folder to start the dev server

## Production

- Copy the `.env.example` file in the `server` folder to `.env.local` and fill in the values
- Run `docker-compose up -f docker-compose.prod.yaml up --build` in the root folder for the database

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.