# Jekyll Blog Makefile
# Containerized environment for local development

.PHONY: help install update serve build clean doctor

IMAGE_NAME = blog-jekyll
DOCKER_RUN = docker run --rm -v "$$(pwd)":/site

# Default target
help:
	@echo "Jekyll Blog Development Commands:"
	@echo "  make install  - Build the Docker image"
	@echo "  make serve    - Run local development server"
	@echo "  make build    - Build the site"
	@echo "  make clean    - Clean generated files"
	@echo "  make doctor   - Check Jekyll environment"
	@echo "  make update   - Rebuild image without cache"

# Build Docker image
install:
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME) .
	@echo "✓ Image built successfully"

# Rebuild image without cache
update:
	@echo "Rebuilding Docker image (no cache)..."
	docker build --no-cache -t $(IMAGE_NAME) .
	@echo "✓ Update complete"

# Run development server
serve:
	@echo "Starting Jekyll development server..."
	$(DOCKER_RUN) -p 4000:4000 -p 35729:35729 $(IMAGE_NAME)

# Build the site
build:
	@echo "Building site..."
	$(DOCKER_RUN) $(IMAGE_NAME) bundle exec jekyll build --future
	@echo "✓ Build complete"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -rf _site .jekyll-cache .jekyll-metadata
	@echo "✓ Clean complete"

# Check Jekyll environment
doctor:
	@echo "Checking Jekyll environment..."
	$(DOCKER_RUN) $(IMAGE_NAME) bundle exec jekyll doctor
