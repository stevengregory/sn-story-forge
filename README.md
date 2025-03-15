# SN Story Forge

An experimental Ruby tool that generates local Markdown files from ServiceNow user stories; capturing acceptance criteria, story points, and other details for offline reference. It organizes them by assignment, product, and archives each story for backup.

## Prerequisites

- [Ruby](https://www.ruby-lang.org/en/)
- [Bundler](https://bundler.io/)

## Installation

```bash
bundle install
```

## Configuration

```bash
cp .env.example .env
```

## Running

```bash
ruby src/run.rb
```

## Project Structure

```
.
├── dist/               # Generated output directory
│   ├── Archive/        # Archived stories in YAML format
│   ├── My Stories/     # All stories assigned to you (across all products)
│   └── Product/        # Stories organized by product
│       └── {product}/  # Product-specific folders with state subfolders
├── src/
│   ├── config.rb       # Configuration settings
│   ├── request.rb      # ServiceNow API request handling
│   ├── run.rb          # Main execution script
│   ├── story.rb        # Story management logic
│   ├── template.rb     # Markdown template generation
│   └── utils.rb        # Utility functions
├── Gemfile             # Ruby dependencies
├── .env                # Environment configuration (create from .env.example)
└── .env.example        # Example environment configuration
```
