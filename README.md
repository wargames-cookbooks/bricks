OWASP Bricks Cookbook
=============
Deploy a bricks environment. [![Build Status](https://secure.travis-ci.org/wargames-cookbooks/bricks.png)](http://travis-ci.org/wargames-cookbooks/bricks)

Requirements
------------

#### Platform
- `Ubuntu 10.04`
- `Ubuntu 12.04`

#### Cookbooks
- `apache2` - https://github.com/opscode-cookbooks/apache2.git
- `mysql` - https://github.com/opscode-cookbooks/mysql.git
- `php` - https://github.com/opscode-cookbooks/php.git
- `database` - https://github.com/opscode-cookbooks/database.git

#### Supported versions - codename
- 1.7 - Phalgu
- 1.6 - Raidak
- 1.5 - Lachen
- 1.4 - Punpun
- 1.3 - Torsa
- 1.2 - Feni
- 1.1 - Betwa
- 1.0 - Narmada


Attributes
----------
#### bricks::default
* `['bricks']['db']['name']` - Bricks database name
* `['bricks']['db']['username']` - Bricks username
* `['bricks']['db']['password']` - Bricks user password
* `['bricks']['codename']` - Bricks codename to deploy
* `['bricks']['path']` - Path where application will be deployed
* `['bricks']['server_name']` - Apache2 server name
* `['bricks']['server_aliases']` - Array of apache2 virtualhost aliases

Usage
-----
#### bricks::default

Just include `bricks` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[bricks]"
  ]
}
```

#### Running tests

- First, install dependencies:  
`bundle install`  

- Install cookbook dependencies
`berks install`

- Run strainer tests:  
`bundle exec strainer test`  

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add-component-x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Sliim <sliim@mailoo.org> 

License: See COPYING file.
