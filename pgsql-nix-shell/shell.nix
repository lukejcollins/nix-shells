{ pkgs ? import <nixpkgs> {} }:

let
  pgData = "$(pwd)/pgdata";  # Absolute path
  pgConfig = "${pgData}/postgresql.conf";
  pgHBA = "${pgData}/pg_hba.conf";
in

pkgs.mkShell {
  buildInputs = [ pkgs.postgresql ];

  shellHook = ''
    # Function to start PostgreSQL server
    function start_postgres {
      echo "Starting PostgreSQL server..."
      pg_ctl -D ${pgData} -l ${pgData}/logfile -o "-k ${pgData}" start
      # Give PostgreSQL a few seconds to initialize (optional but can be helpful)
      sleep 3
    }

    # Initialize PostgreSQL data directory if it doesn't exist
    if [ ! -d "${pgData}" ]; then
      echo "Initializing PostgreSQL data directory..."
      initdb -D ${pgData}

      echo "Configuring PostgreSQL..."
      sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" ${pgConfig}
      sed -i "s/#port = 5432/port = 5433/g" ${pgConfig}
      echo "host    all             all             0.0.0.0/0               trust" >> ${pgHBA}

      start_postgres
    else
      # Check if PostgreSQL is running, start if not
      if ! pg_ctl -D ${pgData} status > /dev/null; then
        echo "PostgreSQL server not running. Starting server..."
        start_postgres
      else
        echo "PostgreSQL server is already running."
      fi
    fi

    echo "Configuring PostgreSQL Database..."
    psql -h $(pwd)/pgdata -p 5433 -d postgres -a -f $(pwd)/init_db.sql
  '';
}
