# Sets up tor over SSH

WIP!
Ensures you can access your computer from anywhere in the world with a single
command. See why you need this, and how it works [here](ssh_explanation.md).

## Terminology

Since you SSH from one computer (Leader) into another (Follower):

**Leader** - The pc that you use to control the server.
**Follower** - The pc that follows the orders you give from the Leader.

## Getting started

You can use this repository in 2 ways:

- Run it once on the `Leader` (requires (local) ssh access from `Leader` into
  `Follower`)
- ~~Run it once on the `Follower` and once on the `Leader` (Requires~~
  ~~(physically) copying the onion domain and private key from Leader into~~
  \~~ `Leader`).\~~ (Currently not supported.)

## On Follower

To get the local ip address of the `Follower` device, type:

```sh
hostname -I
```

on it.  Which outputs something like:`15.14.3.42`.
Then type:

```sh
whoami
```

to get the Ubuntu username of the `Follower`, which outputs something like: `somename`.

## Run Once on Leader

Open the terminal on the `Leader` machine and type:

```sh
chmod +x install-dependencies.sh
./install-dependencies.sh

chmod +x src/main.sh
src/main.sh \
--follower-username somename \
--follower-local-ip 15.14.3.42 \
--follower-password the_ubuntu_password_of_the_ubuntu_username
```

- Change these values with the output that you got at [On Follower](#on-follower).
- You can also omit the password with: `--follower-password ""` if you
  don't want to type it in plain text, then you will be prompted for the password.
- If you have to access the device on a specific port, for example for a
  virtualbox system, include `--port 2222` where you change `2222` with the port
  number you need. If you don't include it, it defaults to 22.

That:

- Generates a private and public key pair on the `Leader` machine (and adds it
  to the ssh-agent of the `Leader` machine).
- Gets ssh access into `Follower` over WIFI/LAN.
- Sets up the onion domain on that `Follower` machine.
- Copies the public key from `Leader` into `Follower`.
- Adds the copied public key to the authorised keys in the `Follower` machine.
  The output is the onion domain over which you can SSH into the `Follower`
  machine, like:

```txt
You can ssh into # oncethis server with command:
torsocks ssh follower_ubuntu_username@somelongoniondomainabcdefghikjlmnop.onion
```

You can now SSH from your `Leader` into your `Follower` machine and tell it
what to do.

## Run on Leader, then on Follower

Currently not supported, feel free to send a pull request.

## Developer Information

Below is information for developers, e.g. how to use this as a dependency in
other projects.

### Install this bash dependency in other repo

- In your other repo, include a file named: `.gitmodules` that includes:

```sh
[submodule "dependencies/bash-ssh-over-tor"]
 path = dependencies/bash-ssh-over-tor
 url = https://github.com/hiveminds/bash-ssh-over-tor
```

- Create a file named `install_dependencies.sh` with content:

```sh
# Remove the submodules if they were still in the repo.
git rm --cached dependencies/bash-ssh-over-tor

# Remove and re-create the submodule directory.
rm -r dependencies/bash-ssh-over-tor
mkdir -p dependencies/bash-ssh-over-tor

# (Re) add the BATS submodules to this repository.
git submodule add --force https://github.com/hiveminds/bash-ssh-over-tor dependencies/bash-ssh-over-tor
```

- Install the submodule with:

```sh
chmod +x install-dependencies.sh
./install-dependencies.sh
```

### Call this bash dependency from other repo

After including this dependency you can use the functions in this module like:

```sh
#!/bin/bash

# Source the file containing the functions
source "$(dirname "${BASH_SOURCE[0]}")/src/main.sh"

# Naming conventions:
# server - The pc that you access and control.
# client - The pc that you use to control the server.

# Configure tor and ssh such that allows ssh access over tor.
configure_ssh_over_tor_at_boot
```

The `0` and `1` after the package name indicate whether it will update the
package manager afterwards (`0` = no update, `1` = package manager update after
installation/removal)

### Testing

Put your unit test files (with extension .bats) in folder: `/test/`

### Developer Prerequisites

(Re)-install the required submodules with:

```sh
chmod +x install-dependencies.sh
./install-dependencies.sh
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
