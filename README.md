<div align="center">

# asdf-mercury

[mercury](https://www.mercurylang.org/index.html) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add mercury
# or
asdf plugin add mercury https://github.com/AntonyBlakey/asdf-mercury.git
```

mercury:

```shell
# Show all installable versions
asdf list-all mercury

# Install specific version
asdf install mercury latest

# Set a version globally (on your ~/.tool-versions file)
asdf global mercury latest

# Now mercury commands are available
mmc --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/AntonyBlakey/asdf-mercury/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [susurri](https://github.com/AntonyBlakey/)
