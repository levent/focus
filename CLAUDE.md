# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Focus is a daily productivity app built with Rails 8.1 and Ruby 3.4.8. It has a single resource (`FocusEntry`) with a state-aware workflow: morning check-in (set focus + blockers) -> evening review (achieved yes/no + reason) -> read-only summary. One entry per day, enforced by a unique index on `entry_date`.

## Commands

```bash
bin/dev                          # Start dev server (Rails + Tailwind watcher via Procfile.dev)
bundle exec rspec                # Run full test suite
bundle exec rspec spec/models    # Run model specs only
bundle exec rspec spec/requests  # Run request specs only
bundle exec rspec spec/system    # Run system specs (headless Chrome via Cuprite)
bundle exec rspec spec/models/focus_entry_spec.rb:42  # Run a single test by line number
bundle exec rubocop              # Lint (rubocop-rails-omakase style)
bundle exec rubocop -a           # Lint with auto-correct
bundle exec brakeman             # Security scan
bundle exec bundler-audit check --update  # Gem vulnerability audit
bin/rails db:create db:migrate   # Set up database (SQLite)
```

## Architecture

- **Single-resource app**: One controller (`FocusEntriesController`), one model (`FocusEntry`), singular resource routing (`resource :focus_entry`). Root URL points to `focus_entries#show`.
- **State-driven views**: The `show` action renders one of three partials based on entry state: `_morning_form` (no entry yet), `_evening_form` (morning complete, not reviewed), `_summary` (reviewed). The controller uses `load_or_build_today_entry` to find or initialize today's entry.
- **Model logic**: `FocusEntry` validates `non_achievement_reason` presence only when `achieved == false`. The `reviewed?` method checks whether `achieved` is non-nil. `morning_complete?` checks if `primary_focus` is present.
- **Frontend**: Tailwind CSS 4, Hotwire (Turbo + Stimulus), Importmap (no Node build step). Assets via Propshaft.
- **Database**: SQLite for all environments. Solid Cache and Solid Queue for cache/job backends.
- **Deployment**: Docker + Kamal. Secrets in `.kamal/secrets`.

## Testing

- RSpec with transactional fixtures. System tests use Capybara + Cuprite (headless Chrome).
- Test support files auto-loaded from `spec/support/`.
- CI runs Brakeman, Bundler Audit, importmap audit, and RuboCop (no test job in CI yet).

## Style

- Uses rubocop-rails-omakase with no custom overrides.
