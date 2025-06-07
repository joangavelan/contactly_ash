# Contactly (Ash/React version)

This is a demo Contacts Application built with the Ash Framework, Phoenix, React, and Inertia, featuring email/password authentication, full CRUD operations, pagination, search functionality, and CSV import/export capabilities.

https://github.com/user-attachments/assets/6898281e-e18c-4980-ae10-6a355cb0c665

## Features

- **Email/Password Authentication**: Complete authentication system with user registration, login, email confirmation, password reset, and forgot password functionality using Ash Authentication.
- **CRUD Operations**: Create, read, update, and delete contacts.
- **Pagination**: Efficiently navigates through contact lists.
- **Search**: Quickly find contacts using the search feature.
- **CSV Import/Export**: Import and export contacts via CSV files.
- **Modern Frontend**: Built with React and Inertia.js for a seamless single-page application experience.

## Entity-Relationship Diagram (ERD)

![contactly_ash_erd](https://github.com/user-attachments/assets/32ccf50e-ff62-4fdf-8cff-2cabf4c9516a)

## Prerequisites

Before setting up the application, ensure you have the following installed:

- **Elixir**: Version 1.14 or later. [Installation Guide](https://elixir-lang.org/install.html)
- **Erlang**: Version 24 or later. [Installation Guide](https://elixir-lang.org/install.html)
- **Node.js**: Version 16 or later. [Installation Guide](https://nodejs.org/)
- **PostgreSQL**: Ensure it's installed and running. [Installation Guide](https://www.postgresql.org/download/)

## Setup Instructions

### Clone the Repository

```bash
git clone https://github.com/joangavelan/contactly_ash.git
cd contactly_ash
```

### Install Dependencies

Fetch and install the necessary Elixir dependencies:

```bash
mix deps.get
```

Install Node.js dependencies for the frontend:

```bash
cd assets
npm install
cd ..
```

### Database Configuration

Configure your database settings in `config/dev.exs`. Ensure the `username`, `password`, `hostname`, and `database` fields match your PostgreSQL setup:

```elixir
config :contactly, Contactly.Repo,
  username: "your_db_username",
  password: "your_db_password",
  hostname: "localhost",
  database: "contactly_dev",
```

### Create and Migrate the Database

Set up the database by running:

```bash
mix ecto.create
mix ecto.migrate
```

### Start the Server

Start the Phoenix server:

```bash
mix phx.server
```

The app will be accessible at [http://localhost:4000](http://localhost:4000).

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request with your improvements or feedback.

---
