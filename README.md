# shcripts

Collection of simple and tiny shell scripts (<100 lines).

## Dependencies

-   curl
-   fzf
-   jq
-   tealdeer (for tldr.sh)

## Available Scripts

|              |                                                                                                                               |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| `cht.sh`     | fuzzy [cht.sh][cht.sh]                                                                                                        |
| `ignore.sh`  | search and add `.gitignore` templates for various languages from [GitHub gitignore templates API][github_gitignore_templates] |
| `license.sh` | search and add `LICENSE` file for popular licenses from [GitHub Licenses API][github_licenses]                                |
| `tldr.sh`    | fuzzy [tealdeer][tealdeer] (tldr)                                                                                             |

## Install instructions

-   Copy the `.sh` file somewhere in the `$PATH`, and make it executable. (I keep the scripts in `~/.local/bin`)

## Uninstall instructions

-   Simply remove the script from the `$PATH`.

## Usage instructions

-   Simply call the `.sh` file from anywhere after adding them to the `$PATH` (for ex. `ignore.sh`).

## Credits & Thanks to

-   [ThePrimeagen][theprimeagen] for `cht.sh`
-   [Elijah Manor][elijah_manor] for `tldr.sh`
-   [cht.sh][cht.sh] & GitHub for the api's
-   Awesome cli tools - curl, fzf, jq, tealdeer

## Bonus

If you use [Kitty Terminal][kitty], you can add these to the custom keymaps

```sh
## cht.sh
map kitty_mod+space>.>c launch --hold sh -c "if command -v cht.sh >/dev/null 2>&1; then cht.sh; else echo 'cht.sh not found'; fi"

## ignore.sh
map kitty_mod+space>.>i launch --cwd=current --hold sh -c "if command -v ignore.sh >/dev/null 2>&1; then ignore.sh; else echo 'ignore.sh not found'; fi"

## ignore.sh
map kitty_mod+space>.>l launch --cwd=current --hold sh -c "if command -v license.sh >/dev/null 2>&1; then license.sh; else echo 'license.sh not found'; fi"

## tldr.sh
map kitty_mod+space>.>t launch --hold sh -c "if command -v tldr.sh >/dev/null 2>&1; then tldr.sh; else echo 'tldr.sh not found'; fi"
```

[cht.sh]: https://cht.sh
[github_gitignore_templates]: https://api.github.com/gitignore/templates
[github_licenses]: https://api.github.com/licenses
[kitty]: https://github.com/kovidgoyal/kitty/
[tealdeer]: https://github.com/dbrgn/tealdeer
[theprimeagen]: https://www.youtube.com/watch?v=hJzqEAf2U4I
[elijah_manor]: https://www.youtube.com/watch?v=4EE7qlTaO7c
