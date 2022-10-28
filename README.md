# Helpful Scripts

**These scripts are meant to be run on a local machine and are not intended for use in production environments.** For extra laziness, add an alias to your rc file.

``` bash
alias op-psql="~/scripts/op-psql.sh"
```

## Usage

### `op-psql`

This script uses `op` cli to get credentials from a specified item in a 1password account, and uses those credentials to execute a sql file using `psql`.

Note: the `psql` script will require you to manually enter the host password.

``` bash
op-psql -i op-item-name -f /path/to/file.sql [-v vault-name]
```

#### Options

`-i` : The name or ID of the item you are requesting credentials for.

`-f` : The path to the file being executed.

`-v` : The name or ID of the vault. OP suggests setting this flag so as to not exceed your [rate limit](https://developer.1password.com/docs/events-api/reference/#rate-limits). I recommend setting a default value for this where specified in the script.

`-h` : Help
