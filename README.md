# Rescoped

[![Build Status](https://travis-ci.org/gadogado/rescoped.svg?branch=master)](https://travis-ci.org/gadogado/rescoped)

Rescoped allows you to remove specific relations from an activerecord `:joins` or `:includes` with some new utilities: `remove_includes`, `remove_joins`, and `remove_left_outer_joins`

### Usage

Consider the following scope:

```ruby
class Photo < ApplicationRecord

  scope :public_api, lambda {
    includes(
      :users,
      :likes,
      :region
    ).viewable.recent
  }
end
```

Rescoped let's you keep an existing scope but **without** the same relations structure.  Here's an example of keeping the `:public_api` scope but removing one of the relations from the `:includes`

  ```ruby
 # Avoid an includes(:relation).joins(:relation) and instead restructure as a simple INNER JOIN

  Photo.public_api.remove_includes(:region).joins(:region)
  ```

  Some other **simple** examples:

  1. Remove any number of relations from `:left_outer_joins`. 

  ```ruby
  Photo.left_outer_joins(:users, :likes, :region).remove_left_outer_joins(:users, :likes)
  ```

  2. Remove a single relation from the `:joins`
  ```ruby
  Photo.joins(:users, :likes).remove_joins(:users)
  ```

  3. The rescoped utilities can be used anywhere in the chain:

  ```ruby
  Photo.includes(:users, :likes).left_joins(:regions).viewable.recent.remove_includes(:users)
  ```

## Installation

```ruby
gem 'rescoped'
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Author

Geoff Ereth (github@geoffereth.com)