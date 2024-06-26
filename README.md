<div align="center">
<img src="logo.png">
</div>

# LOCKDOWN: LUKS-Based Data at Rest Encryption Tool

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Lockdown is a user-friendly LUKS-based data at rest encryption tool designed for securing databases. It provides an easy-to-use interface for encrypting and decrypting sensitive data stored in databases, ensuring the confidentiality and integrity of your information.

## Features

- **User-Friendly Interface**: Lockdown offers a simple and intuitive command-line interface, making it easy for both beginners and experienced users to encrypt and decrypt database contents using LUKS.

- **Secure LUKS Encryption**: Utilizes the Linux Unified Key Setup (LUKS) standard for disk encryption, providing robust security for your data.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Installation

### Prerequisites

- Python 3.10
- Bash
- LUKS Support (Ensure your system has LUKS installed)

### Installation Steps

1. Clone the repository:

    ```bash
    git clone https://github.com/0xtan3/Lockdown.git
    ```

2. Navigate to the project directory:

    ```bash
    cd Lockdown
    ```
3. Make the script executable:

    ```bash
    sudo chmod +x ./lockdown.sh
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
        ./lockdown.sh --help
        ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

