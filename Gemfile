source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'

gem 'rails',                           '~> 5.1.3'
gem 'pg',                              '~> 0.18'
gem 'puma',                            '~> 3.7'
gem 'sass-rails',                      '~> 5.0'
gem 'uglifier',                        '>= 1.3.0'
gem 'coffee-rails',                    '~> 4.2'
gem 'turbolinks',                      '~> 5'
gem 'jbuilder',                        '~> 2.5'
gem 'bcrypt',                          '~> 3.1.7'
gem 'devise',                          '~> 4.4', '>= 4.4.3'
gem 'pundit',                          '~> 1.1'
gem 'rolify',                          '~> 5.2'
gem 'sucker_punch',                    '~> 2.0', '>= 2.0.4'
gem 'figaro',                          '~> 1.1', '>= 1.1.1'
gem 'gravatar_image_tag',              '~> 1.2'
gem 'inline_svg',                      '~> 1.3', '>= 1.3.1'

# Add type-casting and other features on top of ActiveRecord::Store.store_accessor
gem 'storext',                         '~> 2.2', '>= 2.2.2'

# Bootstrap.
gem 'bootstrap',                       '~> 4.0.0.beta2.1'
gem 'jquery-rails',                    '4.3.1'

# Pagination and breadcrumbs.
gem 'bootstrap-will_paginate',         '1.0.0'
gem 'will_paginate',                   '~> 3.1', '>= 3.1.6'
gem 'breadcrumbs_on_rails',            '~> 3.0', '>= 3.0.1'

# Upload and resize images.
gem 'carrierwave',                     '1.1.0'
gem 'mini_magick',                     '4.7.0'
gem 'fog',                             '1.40.0'

# Forms country select.
gem 'country_select',                  '~> 3.1', '>= 3.1.1'

# Geolocalization.
gem 'geocoder',                        '~> 1.4', '>= 1.4.5'

group :development, :test do
  gem 'faker',                         '~> 1.8', '>= 1.8.7'
  gem 'pry-byebug',                    '~> 3.6'
  gem 'pry-rails',                     '~> 0.3.6'
  gem 'rubocop-rails',                 '~> 1.2', '>= 1.2.1'
end

group :test do
  gem 'capybara',                      '~> 2.14'
  gem 'capybara-webkit',               '~> 1.15'
  gem 'capybara-screenshot',           '~> 1.0', '>= 1.0.18'
  gem 'rails-controller-testing',      '~> 1.0', '>= 1.0.2'
  gem 'guard',                         '2.14.0'
  gem 'guard-minitest',                '2.4.6'
  gem 'minitest-reporters',            '1.1.14'
  gem 'webmock',                       '~> 3.3'
  gem 'simplecov', :require => false
end

group :development do
  gem 'bullet',                        '~> 5.7', '>= 5.7.5'
  gem 'guard-livereload',              '~> 2.5', '>= 2.5.2'
  gem 'rails-erd',                     '~> 1.5', '>= 1.5.2', require: false
  gem 'web-console',                   '>= 3.3.0'
  gem 'listen',                        '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen',         '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
