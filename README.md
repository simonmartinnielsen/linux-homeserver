# Simple Linux Homeserver

A collection of tested solutions for common problems when starting out self-hosting.  
This repository reflects setups that works for me, based on trial and error, with a focus on **simplicity**.  
It does not cover VM management or OS abstraction.

Contributions are welcome, as long as they stay within the existing problem space.

---

## Functionality

### [Backup](backup)
Automated 3-2-1 backups for system files, Docker volumes, and custom directories.  
Includes scheduling, logging, and remote sync via `rclone`.
Note: I run encrypted backups with Duplicati, see [Private Service Hosting](services/private)  

### [Private Service Hosting](services/private)
Host and share services with family or friends in a secure, private environment.

### Public Service Hosting
Deploy apps and websites securely, without excessive complexity.

---

## Prerequisites

- A Linux OS (tested on Ubuntu Server 24.04 LTS)  
- Bash and `rclone`  
- Docker + Docker Compose  
- Nginx  

---

## Notes

- Focus is on reliable, minimal setups.  
- Scripts and configurations attempt to be **easy to understand and maintain**.  
- The repo is updated as simpler or better solutions are found.