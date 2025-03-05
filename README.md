# MariaDB Installation and Upgrade Script

This script automates the installation and upgrade of [MariaDB](https://mariadb.org/) on a Debian system. It performs the following tasks:

### Language Detection and Prompt:
  The script detects the system's default language and prompts the user to choose between English and Spanish if the system language is not already one of these two.
  It dynamically updates all output messages based on the selected language.

### Package Installation:
  The script installs necessary dependencies (apt-transport-https and curl) to handle repository keys and secure communication.
  It creates the necessary directories and downloads the MariaDB signing key.

### Repository Configuration:
  A custom [MariaDB repository](https://mariadb.org/download/?t=repo-config) source list is created at /etc/apt/sources.list.d/mariadb.sources to ensure installation and upgrades are done from a trusted [MariaDB mirror](https://downloads.mariadb.org/rest-api/mirrors).

### System Update:
  The script runs apt-get update to refresh the package index and ensures the system is up to date.

### MariaDB Installation or Upgrade:
  If [MariaDB](https://mariadb.org/) is not already installed, the script installs the [MariaDB server](https://mariadb.org/download/). If [MariaDB](https://mariadb.org/) is already installed, it runs an upgrade to ensure the latest version is installed.

### Color-Coded Output:
  The script uses color-coded messages for better user feedback:
  - ![](https://img.shields.io/static/v1?label=&message=&nbsp;&nbsp;&color=green) Green: Success messages
  - ![](https://img.shields.io/static/v1?label=&message=&nbsp;&nbsp;&color=yellow) Yellow: Informational messages
  - ![](https://img.shields.io/static/v1?label=&message=&nbsp;&nbsp;&color=red) Red: Error messages or interruptions

## Usage Instructions:

Download or clone this script to your system.
Make it executable by running:

```console
$ chmod +x mariadb-script.sh
```

Execute the script with:

```console
$ ./mariadb-script.sh
```
