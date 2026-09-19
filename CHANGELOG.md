## [1.1.0] - 2026-09-20

- The `git` dependency moves from 2.x to 5.x. The gem monkey-patched
  `Git::Base` to add a worktree command, and `Git::Base` is no longer a class in
  5.x, so loading the gem raised `TypeError: Base is not a class`. The patch is
  gone: git 5 has a public `worktree_add`.
- The executable failed with a `LoadError` when run from inside a project that
  uses Bundler, which is most of the repositories this tool exists to inspect.
  It required `bundler/setup`, so it resolved against the inspected project's
  Gemfile instead of its own installed gems.
- `require 'files_in_my_diff'` raised `uninitialized constant Git`. Nothing in
  the library required the `git` gem; it happened to work because the executable
  loaded a file that did.
- The published gem no longer carries the Rakefile, the rubocop config, the TODO
  or the development scripts.

## [1.0.1] - 2024-11-09

- Fix links in gemspec

## [1.0.0] - 2024-11-09

- Initial release
