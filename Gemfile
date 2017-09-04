source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.1'

gem 'rails',                           '~> 5.1.3'
gem 'pg',                              '~> 0.18'
gem 'puma',                            '~> 3.7'
gem 'sass-rails',                      '~> 5.0'
gem 'uglifier',                        '>= 1.3.0'
gem 'coffee-rails',                    '~> 4.2'
gem 'turbolinks',                      '~> 5'
gem 'jbuilder',                        '~> 2.5'
gem 'bcrypt',                          '~> 3.1.7'

gem 'bootstrap-sass',                  '3.3.7'
gem 'jquery-rails',                    '4.3.1'
gem 'bootstrap-will_paginate',         '1.0.0'
gem 'will_paginate',                   '3.1.5'
gem 'momentjs-rails',                  '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

group :development, :test do
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop-rails'
  gem 'selenium-webdriver'
end

group :test do
  gem 'capybara',                      '~> 2.13'
  gem 'minitest-reporters',            '1.1.14'
  gem 'simplecov', :require => false
end

group :development do
  gem 'web-console',                   '>= 3.3.0'
  gem 'listen',                        '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen',         '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
