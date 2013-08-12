# This source file is part of Bricks's chef cookbook.
#
# Bricks's chef cookbook is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Bricks's chef cookbook is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Bricks's chef cookbook. If not, see <http://www.gnu.org/licenses/gpl-3.0.html>.

name             'bricks'
maintainer       'Sliim'
maintainer_email 'sliim@mailoo.org'
license          'GPLv3'
description      'Installs/Configures Bricks application'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apache2"
depends "mysql"
depends "php"
depends "database"
