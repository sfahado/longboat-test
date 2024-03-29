##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [2.7.4](https://github.com/organization/project-name/blob/master/.ruby-version#L1)
- Rails [6.1.4](https://github.com/organization/project-name/blob/master/Gemfile#L12)

##### 1. Check out the repository

```bash
https://github.com/sfahado/longboat-test
cd longboat-test
```

##### 2. Create database.yml file

Copy the sample database.yml file and edit the database configuration as required.

```bash
change credentials in config/database.yml
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
bundle exec rake db:seed

```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000