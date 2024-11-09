[![Gem Version](https://badge.fury.io/rb/files_in_my_diff.svg)](https://badge.fury.io/rb/files_in_my_diff)

# FilesInMyDiff

A command line tool that takes a git repository path and revision as input. It creates a temporary worktree, checks out the specified revision, and returns a JSON object containing the worktree path, commit SHA, and list of changed files. The tool helps you inspect changes in any git revision without affecting your current working directory.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add files_in_my_diff
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install files_in_my_diff
```

## Usage

CLI usage as described by the help message:
```
Usage: files_in_my_diff <folder> <revision>

folder   - Path to git repository
revision - Git revision (branch, tag, or commit SHA)
```

If you wish to invoke the logic programmatically, you can use the method `FilesInMyDiff.checkout(folder: <repository path>, revision: <git revision>)`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beatmadsen/files_in_my_diff.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
