# encoding: utf-8
#
# Cookbook Name:: bricks
# Attributes:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Database configuration
default["bricks"]["db"]["name"]     = "bricks"
default["bricks"]["db"]["username"] = "bricks"
default["bricks"]["db"]["password"] = "bricks"

# Bricks application
default["bricks"]["codename"] = "barak"
default["bricks"]["path"]     = "/opt/bricks"

# Apache2 configuration
default["bricks"]["server_name"]    = "bricks"
default["bricks"]["server_aliases"] = [ "bricks" ]
