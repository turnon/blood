# Blood

Display bloodline of classes

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blood'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install blood

## Usage

For example, print bloodline of all classes loaded:

```ruby
File.open('tmp/blood.html', 'w') do |f|
  all_classes = ObjectSpace.each_object(Class).to_a
  basic_object = Blood.source(all_classes)
  f.puts(basic_object.tree_html_full)
end
```

