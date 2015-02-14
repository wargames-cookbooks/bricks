OWASP Bricks Cookbook
=============
Deploy a bricks environment.
[![Cookbook Version](https://img.shields.io/cookbook/v/bricks.svg)](https://community.opscode.com/cookbooks/bricks) [![Build Status](https://secure.travis-ci.org/wargames-cookbooks/bricks.png)](http://travis-ci.org/wargames-cookbooks/bricks)

Requirements
------------

#### Platform
- `Ubuntu 12.04`
- `Debian 7.6`

#### Cookbooks
- `apache2` - https://supermarket.chef.io/cookbooks/apache2
- `mysql` - https://supermarket.chef.io/cookbooks/mysql
- `php` - https://supermarket.chef.io/cookbooks/php
- `database` - https://supermarket.chef.io/cookbooks/database

#### Supported versions - codename
- 2.2 - Tuivai
- 2.1 - Mora
- 2.0 - Dakatua
- 1.9 - Barak
- 1.8 - Atrai
- 1.7 - Phalgu


Attributes
----------
#### bricks::default
<table>
<tr>
<th>Key</th>
<th>Type</th>
<th>Description</th>
<th>Default</th>
</tr>
<tr>
<td><tt>['bricks']['db']['name']</tt></td>
<td>String</td>
<td>Database name</td>
<td><tt>bricks</tt></td>
</tr>
<tr>
<td><tt>['bricks']['db']['username']</tt></td>
<td>String</td>
<td>Database user name</td>
<td><tt>bricks</tt></td>
</tr>
<tr>
<td><tt>['bricks']['db']['password']</tt></td>
<td>String</td>
<td>Database user password</td>
<td><tt>bricks</tt></td>
</tr>
<tr>
<td><tt>['bricks']['codename']</tt></td>
<td>String|Symbol</td>
<td>Bricks codename to deploy</td>
<td><tt>:tuivai</tt></td>
</tr>
<tr>
<td><tt>['bricks']['path']</tt></td>
<td>String</td>
<td>Path where application will be deployed</td>
<td><tt>/opt/bricks</tt></td>
</tr>
<tr>
<td><tt>['bricks']['showhint']</tt></td>
<td>Boolean</td>
<td>Show bricks hint</td>
<td><tt>false</tt></td>
</tr>
<tr>
<td><tt>['bricks']['server_name']</tt></td>
<td>String</td>
<td>Apache2 server name</td>
<td><tt>bricks</tt></td>
</tr>
<tr>
<td><tt>['bricks']['server_aliases']</tt></td>
<td>Array</td>
<td>Array of apache2 virtualhost aliases</td>
<td><tt>[bricks]</tt></td>
</tr>
</table>

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

- Run Checkstyle and ChefSpec:  
`bundle exec rake`

- Run Kitchen tests:  
`bundle exec rake kitchen`  

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

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
