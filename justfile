default:
    @just --list

# Runs every workspace member with tests.
test-all:
    ./scripts/test-all.sh

# Compiles the Remote Rift Connector API into an executable.
connector-build:
    cd packages/api && dart compile exe lib/src/cli/main.dart -o build/remoterift

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
