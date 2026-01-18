# Jekyll Blog Makefile
# Self-contained environment for local development

.PHONY: help install update serve build clean doctor

# Default target
help:
	@echo "Jekyll Blog Development Commands:"
	@echo "  make install  - Install/update all dependencies"
	@echo "  make serve    - Run local development server"
	@echo "  make build    - Build the site"
	@echo "  make clean    - Clean generated files"
	@echo "  make doctor   - Check Jekyll environment"
	@echo "  make update   - Update all gems to latest versions"

# Install dependencies
install:
	@echo "Installing Jekyll and dependencies..."
	rm -f Gemfile.lock
	bundle config set --local path 'vendor/bundle'
	bundle install
	@echo "✓ Installation complete"

# Update all gems
update:
	@echo "Updating all gems..."
	rm -f Gemfile.lock
	bundle update
	@echo "✓ Update complete"

# Run development server
serve:
	@echo "Starting Jekyll development server..."
	bundle exec jekyll serve --future --livereload --incremental

# Build the site
build:
	@echo "Building site..."
	bundle exec jekyll build --future
	@echo "✓ Build complete"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -rf _site .jekyll-cache .jekyll-metadata
	@echo "✓ Clean complete"

# Check Jekyll environment
doctor:
	@echo "Checking Jekyll environment..."
	bundle exec jekyll doctor
	@echo "Ruby version: $$(ruby --version)"
	@echo "Bundler version: $$(bundle --version)"
	@echo "Jekyll version: $$(bundle exec jekyll --version)"
