[![Join the chat at https://gitter.im/sonata-nfv/Lobby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/sonata-nfv/Lobby)
<p align="center"><img src="https://github.com/sonata-nfv/tng-api-gtw/wiki/images/sonata-5gtango-logo-500px.png" /></p>


# tng-sdk-img

This repository contains the tng-sdk-img component that is a part of the European H2020 project 5GTANGO NFV SDK. This component is responsible to generate images for Service Platform.

## Dependencies

- python2.x/3.x
- pip
- wget
- curl
- cloud-utils
- kvm
- shyaml

On Ubuntu 16.04 you can install it with following commands:

```shell
sudo apt install curl wget qemu-kvm cloud-utils
pip install shyaml
```

## Installation

```shell
git clone https://github.com/sonata-nfv/tng-sdk-img
cd tng-sdk-img
sudo sh install.sh
```

## Usage

```shell
tng-sdk-img TOOL_NAME [OPTIONS]
tng-sdk-img --help    		Show this message
tng-sdk-img --version 		Print version
tng-sdk-img --tools   		List available tools
```

## Tools

The functionality of the component is implemented in separate tools. The list of available tools can be viewed with the command `tng-sdk-img --tools`.

### Converter

This tool is responsible to convert Docker-based VNFs to Virtual Machine-based. It parses Virtual Network Function Descriptor and creates VMs for each specified Virtual Deployment Unit. Then it installs Docker Engine, configures network and creates a systemd service for appropriate container.

```shell
Usage:
  tng-sdk-img convert [OPTIONS] VNFD
Options:
  --help
  --registry   		Run the local docker registry. Specify to use local docker images.
  --base-image <path> 	Path to the base image. Ubuntu 16.04 cloud image will be downloaded to /tmp if not specified.
```

---
## License

The 5GTANGO Repositories is published under Apache 2.0 license. Please see the LICENSE file for more details.

## Developers

The following lead developers are responsible for this repository and have admin rights. They can, for example, merge pull requests.

- Askhat Nuriddinov ([@askmyhat](https://github.com/askmyhat))

## Feedback-Chanel

* Please use the GitHub issues to report bugs.

