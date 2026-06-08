# Remote Rift Tools

Scripts and utilities used during development.

## Available Tools

### update_version

Updates the root `pubspec.yaml` and all `pubspec.yaml` files in the `packages` directory to a specified version.

Run the script from the project root directory:

```sh
dart run remote_rift_tools:update_version <version>
```

> [!important]
> The version argument must be a valid [semantic version](https://semver.org/).

### generate_asset

Generates a Dart file that exposes the contents of a selected asset as a runtime-accessible string.

Run the script from the project root directory:

```sh
dart run remote_rift_tools:generate_asset <asset_type> <target_path>
```

Available asset types:

- `pubspec` - The project's `pubspec.yaml` file.

The `target_path` parameter specifies a relative path from the project root where the generated Dart file will be saved.
