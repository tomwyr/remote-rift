# Remote Rift Website

Landing page for **Remote Rift**, an application that lets you queue for League of Legends games from your phone.

Visit the current version of the website at https://tomwyr.github.io/remote-rift-website.

## Development

The project uses **Jaspr**, a Dart framework for building static websites and web applications. For more information, visit [jaspr.site](https://jaspr.site/).

To run the project locally:

1. Ensure the Dart SDK is installed.
2. Install the Jaspr CLI with `dart pub global activate jaspr_cli`.
3. Run `dart pub get`.
4. Run `jaspr serve`.
5. Open your browser at `http://localhost:8080`.

To modify the website content, edit the components, data, and models located under the `lib` directory. Static assets are located under the `web` directory.

After saving changes, Jaspr automatically reloads the site to reflect the updates.

## Building

Build the static site with:

```sh
jaspr build
```

The output is generated in the `build/jaspr` directory.

## Deployment

Deployment is handled via a GitHub Actions workflow that builds the static site and publishes it to GitHub Pages.  
See the workflow file: [.github/workflows/deploy_website.yml](.github/workflows/deploy_website.yml).

To release a new version, push changes to the `master` branch or [manually trigger the workflow](https://github.com/tomwyr/remote-rift-website/actions/workflows/deploy_website.yml) from GitHub.

## Related Projects

- [Remote Rift Connector](https://github.com/tomwyr/remote-rift-connector) - A local service that connects to and communicates with the League Client API.
- [Remote Rift Desktop](https://github.com/tomwyr/remote-rift-desktop) - A desktop application that launches and manages the local connector service.
- [Remote Rift Mobile](https://github.com/tomwyr/remote-rift-mobile) - A mobile application that allows interaction with the League Client remotely.
- [Remote Rift Foundation](https://github.com/tomwyr/remote-rift-foundation) - A set of shared packages containing common UI, utilities, and core logic used across Remote Rift projects.
