source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'

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
gem 'pg_search',                       '~> 2.1', '>= 2.1.2'
gem 'figaro',                          '~> 1.1', '>= 1.1.1'
gem 'gravatar_image_tag',              '~> 1.2'
gem 'inline_svg',                      '~> 1.3', '>= 1.3.1'
gem 'faker', github: 'stympy/faker'
gem 'friendly_id',                     '~> 5.2', '>= 5.2.4'
gem 'nokogiri',                        '~> 1.8', '>= 1.8.2'
gem 'local_time',                      '~> 2.0', '>= 2.0.1'
gem 'octicons_helper',                 '~> 7.3'

# Used for bulk inserting data into database using ActiveRecord.
gem 'activerecord-import',             '~> 0.23.0'

# Used to round time to the nearest hour.
gem 'rounding',                        '~> 1.0', '>= 1.0.1'

# Add type-casting and other features on top of ActiveRecord::Store.store_accessor
gem 'storext',                         '~> 2.2', '>= 2.2.2'

# Bootstrap.
gem 'bootstrap',                       '~> 4.1', '>= 4.1.1'
gem 'jquery-rails',                    '~> 4.3', '>= 4.3.3'

# Pagination and breadcrumbs.
gem 'bootstrap-will_paginate',         '1.0.0'
gem 'will_paginate',                   '~> 3.1', '>= 3.1.6'
gem 'breadcrumbs_on_rails',            '~> 3.0', '>= 3.0.1'

# Upload, process and store images.
gem 'carrierwave',                     '~> 1.2', '>= 1.2.2'
gem 'cloudinary',                      '~> 1.9', '>= 1.9.1'
gem 'mini_magick',                     '~> 4.8'

# Forms country select.
gem 'country_select',                  '~> 3.1', '>= 3.1.1'

# Geolocalization.
gem 'geocoder',                        '~> 1.4', '>= 1.4.5'

group :development, :test do
  gem 'awesome_print',                 '~> 1.8'
  gem 'factory_bot_rails',             '~> 4.10'
  gem 'pry-byebug',                    '~> 3.6'
  gem 'pry-rails',                     '~> 0.3.6'
  gem 'rubocop-rails_config',          '~> 0.1.3'
end

group :test do
  gem 'database_cleaner',              '~> 1.7'
  gem 'mocha',                         '~> 1.5'
  gem 'capybara',                      '~> 2.14'
  gem 'capybara-webkit',               '~> 1.15'
  gem 'capybara-screenshot',           '~> 1.0', '>= 1.0.18'
  gem 'rails-controller-testing',      '~> 1.0', '>= 1.0.2'
  gem 'guard',                         '2.14.0'
  gem 'guard-minitest',                '2.4.6'
  gem 'minitest-reporters',            '~> 1.3'
  gem 'webmock',                       '~> 3.3'
  gem 'simplecov', :require => false
end

group :development do
  gem 'annotate',                      '~> 2.7', '>= 2.7.4'
  gem 'better_errors',                 '~> 2.4'
  gem 'binding_of_caller',             '~> 0.8.0'
  gem 'bullet',                        '~> 5.7', '>= 5.7.5'
  gem 'guard-rubycritic',              '~> 2.9', '>= 2.9.3'
  gem 'rails-erd',                     '~> 1.5', '>= 1.5.2', require: false
  gem 'web-console',                   '~> 3.6', '>= 3.6.2'
  gem 'listen',                        '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen',         '~> 2.0.0'

  # Profiling.
  gem 'rack-mini-profiler',            '~> 1.0'
  gem 'scout_apm',                     '~> 2.4', '>= 2.4.14'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
