# d4_playerdata

> [!NOTE]
> This project is still in development.

Player identifier and data persistence for FXServer.

This resource abstracts away player identifiers, hardware tokens and
framework-dependent character IDs, designed to be an API that new frameworks and
resources can build on.

## Support

For questions or general support, use [GitHub Discussions] or join the
[Discord server].

## Key Features

### User IDs

The [Users API] abstracts player identifiers and provides User IDs, which you
can use instead of keeping track of different identifiers. It improves data
persistence in rare cases where identifiers change over time.

### Data IDs

The [Data API] provides Data IDs for players, giving you a framework-agnostic
way of saving multiple data slots for one User ID.

### Persist IDs

The [Persist API] abstracts player identifiers, hardware tokens and User IDs,
and provides Persist IDs, which you can use to ban players effectively.

## Getting Started

Read the [User Guide] for installation, configuration, and usage instructions.

## Documentation

Full documentation for this project is available in the [`docs/`] directory.

## Security

If you believe you have found a security vulnerability, **DO NOT**
open an issue. Please follow the [Security Policy] instead.

## Contributing

If you are interested in contributing to this project, read the
[Contributing guidelines] to learn more.

## License

This project's source code © 2025 David Malchin is licensed under the
**MIT License (MIT)** provided in the [LICENSE] file.

[github discussions]: https://github.com/D4isDAVID/d4_playerdata/discussions
[discord server]: https://discord.gg/rdjpS2K8hC
[users api]: https://github.com/D4isDAVID/d4_playerdata/blob/main/docs/api/users.md
[data api]: https://github.com/D4isDAVID/d4_playerdata/blob/main/docs/api/data.md
[persist api]: https://github.com/D4isDAVID/d4_playerdata/blob/main/docs/api/persist.md
[user guide]: ./docs/user-guide.md
[`docs/`]: ./docs/README.md
[security policy]: https://github.com/D4isDAVID/d4_playerdata/security/policy
[contributing guidelines]: ./CONTRIBUTING.md
[license]: ./LICENSE
