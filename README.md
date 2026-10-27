# AWS EC2 Secure Web Server: World Recipe Collection

A recipe website hosted on my own AWS EC2 server, secured with HTTPS and protected by an automated backup script. Built for ICT171 (Introduction to Server Environments and Architectures) at Murdoch University.

- **Live site:** https://nicerecipes.duckdns.org
- **Author:** Varshini Murali

## Problem

I needed to host a website on the cloud and make it secure, without using a managed hosting service or a pre-built image. I chose to build a recipe site, the World Recipe Collection, with recipes from Indian, Japanese, Italian, Moroccan and Mexican cooking. Setting up the server myself (Infrastructure as a Service) meant I had full control, but also full responsibility for security and backups.

## Tools

| Tool | What I used it for |
| --- | --- |
| AWS EC2 (t3.micro, Ubuntu 22.04 LTS) | The cloud server |
| SSH | Connecting to the server from my laptop |
| Apache | The web server that serves the website |
| HTML and CSS | The website, with a separate page for each cuisine |
| DuckDNS | A free domain name pointing to the server |
| Certbot and Let's Encrypt | A free HTTPS certificate |
| Bash | A backup script, `backup.sh` |

## Action

### 1. Launch the EC2 instance
I created an instance in the AWS Console using the Ubuntu 22.04 LTS image. In the security group I allowed ports 22 (SSH), 80 (HTTP) and 443 (HTTPS), and I created a key pair for SSH access. Never upload your `.pem` key to GitHub.

### 2. Connect with SSH
```bash
ssh -i your-key.pem ubuntu@<your-server-ip>
```

### 3. Install Apache
```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
```

### 4. Deploy the website
I copied the site files into Apache's web root and set the correct owner:
```bash
sudo cp -r ~/recipe-site/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
```

### 5. Set up the domain with DuckDNS
I registered the subdomain `nicerecipes.duckdns.org` and created an A record pointing to the server's public IP address. The domain started working within a few minutes.

### 6. Enable HTTPS with Certbot
```bash
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache -d nicerecipes.duckdns.org
```
Certbot got the certificate, installed it, and set Apache to redirect all HTTP traffic to HTTPS.

### 7. Write the backup script
`backup.sh` backs up the whole website. It:
- compresses the site into a timestamped `.tar.gz` archive
- saves it in a `backups` folder
- deletes backups older than 7 days to save disk space
- writes every run to a log file, with success or failure

```bash
#!/bin/bash
# backup.sh: website backup with cleanup and logging

BACKUP_DIR="/home/ubuntu/backups"
SITE_DIR="/var/www/html"
LOG_FILE="/home/ubuntu/backups/backup.log"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/site_backup_$DATE.tar.gz"
KEEP_DAYS=7

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_FILE" "$SITE_DIR"

if [ $? -eq 0 ]; then
  echo "[$DATE] Backup successful: $BACKUP_FILE" >> "$LOG_FILE"
  echo "Backup completed: $BACKUP_FILE"
else
  echo "[$DATE] Backup FAILED" >> "$LOG_FILE"
  echo "Backup failed. Check the log at $LOG_FILE"
fi

find "$BACKUP_DIR" -name "site_backup_*.tar.gz" -mtime +$KEEP_DAYS -delete
echo "Old backups cleaned up (kept last $KEEP_DAYS days)"
```

To run it and check the result:
```bash
chmod +x backup.sh
./backup.sh
ls /home/ubuntu/backups
cat /home/ubuntu/backups/backup.log
```

## Findings

- The website is live and loads at https://nicerecipes.duckdns.org.
- HTTPS works, the browser shows a padlock, and HTTP requests are redirected to HTTPS.
- The DuckDNS domain resolved to the server within a few minutes of saving the record.
- Each run of `backup.sh` creates a timestamped archive and adds a line to the log, so there is a record of when backups ran and whether they worked.

## Recommendations

- **Limit SSH access.** Port 22 should only allow my own IP address instead of the whole internet.
- **Schedule the backups.** Right now I run `backup.sh` by hand. A cron job would make it run on its own.
- **Keep backups off the server.** Copy them to separate storage such as an S3 bucket, so one failure can't lose both the site and its backups.
- **Keep the server updated.** Run regular `apt` updates and check that the Certbot certificate renews.

## Lessons learned

- Setting up everything myself, from the virtual machine to Apache, gave me a much better understanding of how web hosting works.
- HTTPS is not just a padlock. It encrypts everything between the visitor and the server, and Certbot makes it simple to set up properly.
- Backups need to be tested and logged, not just written. A log shows whether a backup really ran.
- Security is part of the build, from opening only the ports you need to protecting your key file.

## References

1. AWS EC2 Documentation: https://docs.aws.amazon.com/ec2/
2. Apache HTTP Server Documentation: https://httpd.apache.org/docs/
3. Certbot and Let's Encrypt Documentation: https://certbot.eff.org/
4. DuckDNS: https://www.duckdns.org/
