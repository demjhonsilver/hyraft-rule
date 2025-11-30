
<div align="center">

# Hyraft Rule

[![Gem Version](https://badge.fury.io/rb/hyraft-rule.svg?icon=si%3Arubygems&icon_color=%23ffffff)](https://badge.fury.io/rb/hyraft-rule)
![Downloads](https://img.shields.io/gem/dt/hyraft-rule)
![License](https://img.shields.io/github/license/demjhonsilver/hyraft-rule)
![Ruby Version](https://img.shields.io/badge/ruby-%3E%3D%203.4.0-red)
![Tests](https://github.com/demjhonsilver/hyraft-rule/actions/workflows/ci.yml/badge.svg)

</div>



This is a standalone command-line interface (CLI) for the Hyraft framework.



## Syntax ( Command KEY )
```bash

- hyraft-rule (standard)
- hyr-rule    (alias)

- hyraft-rule-db (standard / database command)
- hyr-rule-db    (alias / database command)

```


## Usage ( Assemble / Disassemble )


```bash
 assemble  - Creates blueprint structure for templates, engine, and adapters.

 disassemble - Deconstructs the project into its core components.
```

```bash
# Default web-app
hyr-rule assemble articles
hyr-rule disassemble articles

# Specific app folders

hyr-rule assemble {any-folder-name}/users


hyr-rule assemble admin-app/users
hyr-rule disassemble admin-app/users

hyr-rule assemble api-app/products
hyr-rule disassemble api-app/products
```



## Usage ( Engine )

Generate:

```bash

hyr-rule circuit articles

hyr-rule port articles

hyr-rule source article

```

## Usage ( Web Adapter a.k.a Controller )

Generate:

```bash

# Only add the specific web adapter
hyr-rule web-adapter articles
hyr-rule web-adapter admin-app/products

# Only remove the specific web adapter
hyr-rule remove-adapter articles
hyr-rule remove-adapter admin-app/users
```

## Usage ( data-gateway )

Generate:

```bash
hyr-rule data-gateway articles
hyr-rule data-gateway admin-app/products
```




## Usage ( Templates )
- hyr-rule

Generate:

```bash

hyr-rule template articles
hyraft-rule template articles

hyr-rule template admin-app/users
hyraft-rule template admin-app/users
```

## Usage ( For Help )
- hyr-rule

Generate:

```bash

hyr-rule h

hyr-rule help

hyr-rule -h

hyraft-rule h

hyraft-rule help

hyraft-rule -h

```


## Usage ( Database ) 
- hyr-rule-db


Schema:  
      

```bash
      hyr-rule-db generate create_users
      hyr-rule-db generate add_email_to_users

   - Migration Generation Schema Examples:
   
      hyr-rule-db generate create_users
      hyr-rule-db generate create_articles
      hyr-rule-db generate create_products
      hyr-rule-db generate create_categories
      hyr-rule-db generate add_image_file_to_articles
      hyr-rule-db generate add_price_to_products
      hyr-rule-db generate remove_status_from_posts
      hyr-rule-db generate drop_old_tables


    Examples:
     hyr-rule-db generate create_articles title content:text

     hyr-rule-db generate create_products name:string price:decimal description:text user_id:int
     hyr-rule-db generate create_users username:string age:int email:string active:bool created_at:datetime

     hyr-rule-db generate create_products name:string price:decimal description:text user_id:int
     hyr-rule-db generate create_users username age:int email active:bool
     hyr-rule-db generate create_articles title content:text published_at:datetime views:int


```
Migrations:

```bash
    Hyraft Rule Database Commands

    Commands:

      migrate, up        - Run all pending migrations
      rollback, down     - Rollback all migrations
      status             - Show migration status
      reset              - Rollback and re-run all migrations
      generate <name>    - Create a new migration file
      help               - Show this help

    Examples:

      hyr-rule-db migrate
      hyr-rule-db status
      hyr-rule-db rollback
      hyr-rule-db reset
      hyr-rule-db help

    Environment Usage:

      hyr-rule-db migrate                     # Current environment (run: hyr s thin)
      APP_ENV=test hyr-rule-db migrate        # Test environment (run: APP_ENV=test hyr s thin)
      APP_ENV=development hyr-rule-db migrate # Development environment (run: APP_ENV=development hyr s thin)
      APP_ENV=production hyr-rule-db migrate  # Production environment (run: APP_ENV=production hyr s thin)

    Quick Reference:

      # Generate and run migrations for a new table
      hyr-rule-db generate create_users
      hyr-rule-db migrate

      # Add a column to existing table
      hyr-rule-db generate add_email_to_users
      hyr-rule-db migrate

      # Check what needs to be applied
      hyr-rule-db status

      # Rollback if something went wrong
      hyr-rule-db rollback

```









## Development

After checking out the repo, run `bundle install` to install dependencies.

Then, run `rake test` to run the tests.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/demjhonsilver/hyraft-rule. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/demjhonsilver/hyraft-rule/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hyraft::Rule project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/demjhonsilver/hyraft-rule/blob/master/CODE_OF_CONDUCT.md).
