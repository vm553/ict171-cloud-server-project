# World Recipe Collection — Cloud Server Project

**Student Number:** 35792964  
**Name:** Varshini Murali   
**Live site:** https://nicerecipes.duckdns.org  
**Global IP address:** 16.192.57.110  
**GitHub repository:** https://github.com/varshinim11111/ict171-cloud-server-project  
**Video explainer:** [YOUR VIDEO LINK — add after recording]  

---

## 1. Project Overview

This project involved building and hosting a recipe website called the **World Recipe Collection** on a cloud server using AWS EC2. The site brings together recipes from five different cuisines — Indian, Japanese, Italian, Moroccan, and Mexican — in a clean, easy-to-navigate format.

Rather than using a managed hosting service or pre-built image, everything was set up from scratch via SSH on a Ubuntu Linux virtual machine, with Apache as the web server. This approach (Infrastructure as a Service / IaaS) gave full control over the server environment and reflects real-world deployment practices.

---

## 2. Setting Up the EC2 Instance

### 2.1 Instance Details
- **AMI:** Ubuntu 22.04 LTS
- **Instance type:** [e.g. t2.micro]
- **Public IP:** 16.192.57.110
- **Security group:** ports 22 (SSH), 80 (HTTP), 443 (HTTPS) open

### 2.2 Connecting via SSH
```bash
ssh -i your-key.pem ubuntu@16.192.57.110
```

### 2.3 Installing Apache
Apache is the web server software that handles incoming requests and serves the website files.
```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
```

### 2.4 Deploying the Website
The website was built using HTML and CSS, with separate pages for each cuisine. Files were placed in Apache's web root:
```bash
sudo cp -r ~/recipe-site/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

---

## 3. DNS Configuration

A free subdomain was registered through [DuckDNS](https://www.duckdns.org) and pointed at the EC2 server's public IP address. DuckDNS is a free dynamic DNS service — ideal for a project like this where a paid domain isn't required.

- **Domain:** nicerecipes.duckdns.org
- **Record type:** A record
- **Points to:** 16.192.57.110

Once saved, the domain resolved within a few minutes and the site loaded correctly in the browser.

---

## 4. SSL/TLS — Securing the Site with HTTPS

SSL was configured using Certbot with Let's Encrypt, which provides free SSL certificates and integrates directly with Apache.

```bash
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache -d nicerecipes.duckdns.org
```

Certbot automatically obtained and installed the certificate, and configured Apache to redirect all HTTP traffic to HTTPS. The site is now accessible at **https://nicerecipes.duckdns.org** with a valid padlock.

---

## 5. Backup Script

### What It Does
`backup.sh` is a Bash script that automates backups of the website files. It:
- Compresses `/var/www/html` into a timestamped `.tar.gz` archive
- Saves it to `/home/ubuntu/backups/`
- Logs every backup (success or failure) with a timestamp
- Automatically deletes backups older than 7 days to keep disk usage low
- Prints a summary of current backups after each run

This means if the server is ever accidentally deleted or corrupted, the site can be restored from the most recent archive in minutes.

### Running the Script
```bash
chmod +x backup.sh
./backup.sh
```

### Verifying the Output
```bash
# See the backup files
ls /home/ubuntu/backups

# Check the log
cat /home/ubuntu/backups/backup.log
```

A timestamped archive (e.g. `site_backup_2026-07-24_14-30-00.tar.gz`) will appear in the backups directory, and the log will record exactly when it ran and whether it succeeded.

### Scheduling It Automatically (Optional)
To run it every day at 2am without manual intervention:
```bash
crontab -e
# Add this line:
0 2 * * * /home/ubuntu/backup.sh
```

---

## 6. References

[1] AWS EC2 Documentation. Available: https://docs.aws.amazon.com/ec2/  
[2] Apache HTTP Server Documentation. Available: https://httpd.apache.org/docs/  
[3] Certbot / Let's Encrypt Documentation. Available: https://certbot.eff.org/  
[4] DuckDNS Free Dynamic DNS. Available: https://www.duckdns.org/  
