# Remote Rift Website

Landing page for **Remote Rift**, an application that lets you queue for League of Legends games from your phone.

Visit the current version of the website at https://tomwyr.github.io/remote-rift.

## Development

The project uses **Jaspr**, a Dart framework for building static websites and web applications. For more information, visit [jaspr.site](https://jaspr.site/).

To run the project locally:

1. Ensure the Dart SDK is installed.
2. Install the Jaspr CLI with `dart pub global activate jaspr_cli`.
3. Install the Tailwind CLI and make `tailwindcss` available on your `PATH`.
4. Run `dart pub get` from the repository root.
5. Start development commands in separate terminals:
   - `tailwindcss --input styles.tw.css --output web/styles.css --watch`
   - `jaspr serve`

> [!NOTE]
> In VS Code, the `Dev: Run` task starts both development commands together.

6. Open your browser at `http://localhost:8080`.

To modify the website content, edit the components, data, and models located under the `lib` directory. Static assets are located under the `web` directory.

After saving changes, Jaspr automatically reloads the site to reflect the updates.

### Styling

The project uses Tailwind CSS as the styling layer. Source styles are defined in `styles.tw.css`, which imports Tailwind and defines the project-level styling shared across components.

Dart components reference Tailwind utility classes directly. The Tailwind CLI processes `styles.tw.css` and writes the compiled stylesheet to `web/styles.css`, which is then served by Jaspr during development and included in production builds.

## Building

Build the static site with:

```sh
tailwindcss --input styles.tw.css --output web/styles.css --minify
jaspr build --dart-define=BASE_PATH=/remote-rift/
```

The output is generated in the `build/jaspr` directory.

## Deployment

Deployment is handled via a GitHub Actions workflow that builds the static site and publishes it to GitHub Pages.  
See the workflow file: [deploy_website.yml](../../.github/workflows/deploy_website.yml).

To release a new version, push changes to the `master` branch or [manually trigger the workflow](https://github.com/tomwyr/remote-rift/actions/workflows/deploy_website.yml) from GitHub.

## Related Projects

- [Remote Rift Connector](../../packages/connector) - A local service that connects to and communicates with the League Client API.
- [Remote Rift Desktop](../desktop) - A desktop application that launches and manages the local connector service.
- [Remote Rift Mobile](../mobile) - A mobile application that allows interaction with the League Client remotely.
- [Remote Rift Packages](../../packages) - Shared packages containing common UI, utilities, and core logic used across Remote Rift projects.
