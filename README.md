## Rip Package

This project parses and validates a given [Rip](http://www.rip-lang.org/) package metadata file (`package.toml`).


### Usage

```ruby
require 'rip-package'

package_root = Pathname.new(__dir__)
metadata = Rip::Package.load_file(package_root + 'package.toml')
```
