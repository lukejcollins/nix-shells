# PostgreSQL `nix-shell` Environment

This repository provides a `nix-shell` environment with a PostgreSQL server setup. It allows for quick and reproducible PostgreSQL environments without affecting your host system or needing containers.

## Prerequisites

- [Nix](https://nixos.org/guides/install-nix.html) installed on your system.

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/lukejcollins/nix-shells
   cd nix-shells
   ```

2. Enter the `nix-shell` environment:

   ```bash
   nix-shell
   ```

   This will automatically set up and start a PostgreSQL server listening on port `5433`.

3. Connect to the PostgreSQL server using `psql` or any other PostgreSQL client. For example:

   ```bash
   psql -h localhost -p 5433 -U <your-username>
   ```

## Custom Initialization SQL Script

If you'd like to have the PostgreSQL server initialized with a custom configuration, you can create your own SQL script.

1. Create an `init_db.sql` file at the root of this repository.

2. Add your SQL commands and configurations to this file.

3. When you enter the `nix-shell`, the SQL commands in `init_db.sql` will be automatically executed against the PostgreSQL server.

## Recommendations

- **Security**: The default setup uses a `trust` authentication, which means password-less logins. This is convenient for development but not secure for any production-like environment. Adjust your PostgreSQL configurations accordingly if you plan to use this in a more exposed setting.

- **Data Persistence**: By default, data is stored in the `pgdata` directory in the root of this repository. You might want to include `pgdata` in your `.gitignore` if you don't want to accidentally commit database files.
