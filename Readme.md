# Sets up tor over SSH

Ensures you can access your computer from anywhere in the world with a single command.

## Install this bash dependency in other repo

- In your other repo, include a file named: `.gitmodules` that includes:

```sh
[submodule "dependencies/bash-package-installer"]
 path = dependencies/bash-package-installer
 url = https://github.com/hiveminds/bash-package-installer
```

- Create a file named `install_dependencies.sh` with content:

```sh
# Remove the submodules if they were still in the repo.
git rm --cached dependencies/bash-package-installer

# Remove and re-create the submodule directory.
rm -r dependencies/bash-package-installer
mkdir -p dependencies/bash-package-installer

# (Re) add the BATS submodules to this repository.
git submodule add --force https://github.com/hiveminds/bash-package-installer dependencies/bash-package-installer
```

- Install the submodule with:

```sh
chmod +x install-dependencies.sh
./install-dependencies.sh
```

## Call this bash dependency from other repo

After including this dependency you can use the functions in this module like:

```sh
#!/bin/bash

# Source the file containing the functions
source "$(dirname "${BASH_SOURCE[0]}")/src/main.sh"

# Call the desired installation functions.
ensure_apt_pkg "curl" 1
ensure_snap_pkg "brave"
ensure_pip_pkg "twine" 1


# Call the desired installation functions.
apt_remove "curl" 0
snap_remove "brave"
pip_remove "twine" 1
```

The `0` and `1` after the package name indicate whether it will update the
package manager afterwards (`0` = no update, `1` = package manager update after
installation/removal)

## Testing

Put your unit test files (with extension .bats) in folder: `/test/`

### Prerequisites

(Re)-install the required submodules with:

```sh
chmod +x install-bats-libs.sh
./install-bats-libs.sh
```

Install:

```sh
sudo gem install bats
sudo apt install bats -y
sudo gem install bashcov
sudo apt install shfmt -y
pre-commit install
pre-commit autoupdate
```

### Pre-commit

Run pre-commit with:

```sh
pre-commit run --all
```

### Tests

Run the tests with:

```sh
bats test
```

If you want to run particular tests, you could use the `test.sh` file:

```sh
chmod +x test.sh
./test.sh
```

### Code coverage

```sh
bashcov bats test
```

## How to help

- Include bash code coverage in GitLab CI.
- Add [additional](https://pre-commit.com/hooks.html) (relevant) pre-commit hooks.
- Develop Bash documentation checks
  [here](https://github.com/TruCol/checkstyle-for-bash), and add them to this
  pre-commit.
