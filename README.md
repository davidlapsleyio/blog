# Jekyll Blog Development

Self-contained Jekyll environment for local development.

## Requirements

- Ruby 3.x+ (you have Ruby 4.0.1)
- Bundler

## Quick Start

```bash
# Install dependencies (first time only)
make install

# Run development server
make serve

# View your site at http://localhost:4000
```

## Available Commands

```bash
make help      # Show all available commands
make install   # Install/update all dependencies
make serve     # Run local development server with live reload
make build     # Build the site for production
make clean     # Clean generated files
make doctor    # Check Jekyll environment
make update    # Update all gems to latest versions
```

## Environment Details

- **Jekyll Version**: 4.4.1 (latest)
- **Ruby Version**: 4.0.1
- **Bundler Version**: 4.0.3
- **Dependencies**: Installed in `vendor/bundle` (self-contained)

## Development Workflow

1. **Start development server**: `make serve`
2. **Edit content**: Modify files in `_posts/`, `_pages/`, etc.
3. **View changes**: Browser auto-reloads at http://localhost:4000
4. **Stop server**: Press `Ctrl+C`

## Features

- ✅ Latest Jekyll 4.4.1
- ✅ Self-contained environment (vendor/bundle)
- ✅ Live reload enabled
- ✅ Future posts enabled (--future flag)
- ✅ Incremental builds for faster development
- ✅ All dependencies managed by Makefile

## Updating

To update Jekyll and all dependencies to their latest versions:

```bash
make update
```

## Troubleshooting

If you encounter issues:

```bash
# Clean everything and reinstall
make clean
make install
```

## Notes

- All gems are installed in `vendor/bundle` (not system-wide)
- The `vendor/` directory is git-ignored
- Configuration is in `_config.yml`
- Posts go in `_posts/` with format: `YYYY-MM-DD-title.md`
