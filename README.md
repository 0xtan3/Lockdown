# LOCKDOWN: LUKS-Based Data at Rest Encryption Tool for Databases

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

LOCKDOWN is a user-friendly LUKS-based data at rest encryption tool designed for securing databases. It provides an easy-to-use interface for encrypting and decrypting sensitive data stored in databases, ensuring the confidentiality and integrity of your information.

## Features

- **User-Friendly Interface**: LOCKDOWN offers a simple and intuitive command-line interface, making it easy for both beginners and experienced users to encrypt and decrypt database contents using LUKS.

- **Secure LUKS Encryption**: Utilizes the Linux Unified Key Setup (LUKS) standard for disk encryption, providing robust security for your data.

- **Database Support**: LOCKDOWN is designed to work with popular database systems, including MySQL, PostgreSQL, and SQLite.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Installation

### Prerequisites

- Python 3.x
- Bash
- LUKS Support (Ensure your system has LUKS installed)

### Installation Steps

1. Clone the repository:

    ```bash
    git clone https://github.com/akileshjayaraman/LOCKDOWN.git
    ```

2. Navigate to the project directory:

    ```bash
    cd LOCKDOWN
    ```

## Usage

1. Encryption:

    ```bash
    ./lockdown.sh --encrypt -m <mount_point>
    ```

2. Decryption:

    ```bash
    ./lockdown.sh --decrypt -m <mount_point>
    ```

3. Additional Options:

    - View help:

        ```bash
        ./lockdown --help
        ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

