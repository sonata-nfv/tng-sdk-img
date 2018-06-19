# tng-sdk-img

## Desription

This repository contains the tng-sdk-img component that is part of the European H2020 project 5GTANGO NFV SDK. This component is responsible to generate images for Service Platform.

## Installation

```shell
git clone https://github.com/sonata-nfv/tng-sdk-img
cd tng-sdk-img
sudo sh install.sh
```

## Usage

```shell
tng-sdk-img.sh TOOL_NAME [OPTIONS]
tng-sdk-img.sh --help    		Show this message
tng-sdk-img.sh --version 		Print version
tng-sdk-img.sh --tools   		List available tools
```

## Tools

### Converter

This tool is responsible to convert Docker-based VNFs to Virtual Machine-based. It parses Virtual Network Function Descriptor and creates VMs for each specified Virtual Deployment Unit. Then it installs Docker Engine, configures network and creates a systemd service for appropriate container.

#### Requirements

- wget
- cloud-localds
- kvm
- shyaml
- curl

On Ubuntu 16.04 you can install it using following commands:

```shell
sudo apt install curl wget qemu-kvm cloud-utils
pip install shyaml
```

#### Usage

```shell
Usage:
	tng-sdk-img convert [OPTIONS] VNFD
Options:
	--help
	--version
	--registry   		Run the local docker registry. Specify to use local docker images.
	--base-image <path> 	Path to the base image. Ubuntu 16.04 cloud image will be downloaded to /tmp if not specified.
```

---
#### Developers

The following lead developers are responsible for this repository and have admin rights. They can, for example, merge pull requests.

- Askhat Nuriddinov ([@askmyhat](https://github.com/askmyhat))

#### Feedback-Chanel

* Please use the GitHub issues to report bugs.
