default:
    @just --list

# Runs every workspace member with tests.
test-all:
    ./scripts/test-all.sh

# Compiles the Remote Rift Connector API into an executable.
connector-build:
    cd packages/api && dart compile exe lib/src/cli/main.dart -o build/remoterift

# Runs the Connector API with automatic address lookup.
connector-run-resolve-address:
    cd packages/api && dart run lib/src/cli/main.dart --resolve-address

# Runs the Connector API with a custom host and port.
connector-run-custom-address host port="8080":
    cd packages/api && dart run lib/src/cli/main.dart --host {{host}} --port {{port}}

# Runs the desktop application in debug mode.
desktop-run:
    cd apps/desktop && flutter run

# Runs the desktop application in debug mode with a custom Connector address.
desktop-run-custom-address host port="8080":
    cd apps/desktop && flutter run --dart-define=API_HOST={{host}} --dart-define=API_PORT={{port}}

# Runs the mobile application in debug mode.
mobile-run:
    cd apps/mobile && flutter run

# Starts the website development servers.
website-dev:
    ./scripts/website-dev.sh

# Watches and compiles the website Tailwind stylesheet.
website-tailwind-watch:
    cd apps/website && tailwindcss --input styles.tw.css --output web/styles.css --watch

# Serves the website with Jaspr.
website-jaspr-serve:
    cd apps/website && jaspr serve

# Generates code for the core package.
core-build-runner-build:
    cd packages/core && dart run build_runner build

# Watches and generates code for the core package.
core-build-runner-watch:
    cd packages/core && dart run build_runner watch

# Generates mobile localization output.
mobile-slang-generate:
    cd apps/mobile && dart run slang

# Watches and generates mobile localization output.
mobile-slang-watch:
    cd apps/mobile && dart run slang watch
