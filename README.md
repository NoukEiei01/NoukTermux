```bash
git clone --depth=1 https://github.com/mayTermux/myTermux.git
```

  </details>

  <details>
  <summary><strong>Run Script Installer</strong></summary>

- Move to Folder

```bash
cd NoukTermux
```

- export variable `COLUMNS` and `LINES`

> This variable function so that the installer script can read the
> `column` and `row` widths of Termux Application so that later it
> matches the output during the installation process.

```bash
export COLUMNS LINES
```

- Execute Installer

```bash
./setup.sh
```
