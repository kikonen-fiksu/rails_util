# RubyProfHelper

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_prof_helper', git: 'git@github.com:kikonen-fiksu/ruby_prof_helper.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_prof_helper

## Usage

```
RubyProfHelper::profile 'file' do
  ...
end
```

settings.yml:
```
prof:
  enabled: true
  profile_dir: #{Rails.root}/log/profile
  cpu: true
  memory: false
  min_percent: 10.0
  output: graph  #graph | call_stack | flat | call_tree
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
