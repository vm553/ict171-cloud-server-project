# World Recipe Collection — Cloud Server Project

**Student Number:** 35792964
**Name:** Varshini Murali
**Live site:** https://nicerecipes.duckdns.org/
**Global IP address:** 16.192.57.110 
**GitHub repository:** [Link to this repo]
**Video explainer:** [Link once recorded]

---

## 1. Project Overview

This project extends the World Recipe Collection website, originally built for ICT171,
into a fully documented Infrastructure-as-a-Service (IaaS) cloud server project. The
server runs on an AWS EC2 instance with Apache on Linux, and is now configured with a
custom domain name and SSL/TLS encryption.

---

## 2. Server Setup

### 2.1 Launching the EC2 Instance
- Instance type: [e.g. t2.micro]
- AMI: [e.g. Ubuntu 22.04 LTS]
- Security group rules: allow SSH (22), HTTP (80), HTTPS (443)

### 2.2 Connecting via SSH
```bash
ssh -i your-key.pem ubuntu@your-server-ip
```

### 2.3 Installing Apache
```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
```

### 2.4 Deploying the Website Files
```bash
sudo cp -r ~/recipe-site/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
```

---

## 3. DNS Configuration

- Domain registrar used: [e.g. Namecheap, Route 53]
- DNS record type: A record
- Pointed to: [EC2 public IP]

```
Type: A
Host: @
Value: [your EC2 public IP]
TTL: 3600
```

---

## 4. SSL/TLS Setup (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache -d yourdomain.com
```

This automatically obtains and installs a free SSL certificate, and configures Apache
to redirect HTTP traffic to HTTPS.

---

## 5. Custom Script — Website Backup

A shell script (`backup.sh`) was created to automate backups of the website files.

**What it does:**
Compresses the entire `/var/www/html` directory into a timestamped `.tar.gz` archive
and stores it in a backups folder, so the site can be quickly restored if the server
is deleted or corrupted.

**Verification:**
Run `./backup.sh` and confirm a new archive appears in `/home/ubuntu/backups/` with
the current date in its filename.

See [`backup.sh`](./backup.sh) for the full commented script.

---

## 6. References

- AWS EC2 Documentation: https://docs.aws.amazon.com/ec2/
- Apache HTTP Server Documentation: https://httpd.apache.org/docs/
- Let's Encrypt / Certbot Documentation: https://certbot.eff.org/

---

## 7. Commit History Note

This documentation was developed incrementally over several weeks as the server was
built, configured, and tested. See commit history for the full development timeline.
