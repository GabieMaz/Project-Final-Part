# Joomla Project with Docker

# Team Members:
- Gabie mazaltok
- Naama Deshet

# What We Did:
- Created automated scripts for setting up, backing up, restoring, and cleaning a Joomla environment with a MySQL database using Docker.
- Managed container communication using an internal Docker network.
- Built a Joomla site with a login interface and content creation support.

# Step by step:
1. Clone the repository
2. Run `./setup.sh` to start Joomla and MySQL containers
3. Open your browser at http://localhost:8080
4. Run `./backup.sh` to backup the database
5. Run `./restore.sh` to restore the database
6. Run `./cleanup.sh` to clean the environment

# Technologies Used:
- Docker
- Joomla
- Bash
- MySQL
- Git
- Ubuntu(Linux)
  
## Environment:
The scripts are tested on Linux Ubuntu 22.04.
