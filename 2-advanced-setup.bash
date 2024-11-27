# Advanced setup
# Execute this script step by step

# Step 1: Download ejabberd installer
wget https://github.com/processone/ejabberd/releases/download/24.10/ejabberd-24.10-1-linux-x64.run

# Step 2: Make the installer executable
chmod +x ./ejabberd-24.10-1-linux-x64.run

# Step 3: Run the installer
./ejabberd-24.10-1-linux-x64.run

# Step 4: Check status of ejabberd
systemctl status ejabberd

# Step 5: Create certificates
# Verify your installation of certbot with nginx plugin
# Verify your subdomains configured in the DNS
mkdir -p /opt/ejabberd/certs

DOMAIN=domain.com

# Set the domain names you want here
declare -a subdomains=("" "muc." "proxy." "pubsub." "upload.")

for i in "${subdomains[@]}"; do
    certbot --nginx -d $i$DOMAIN certonly
    mkdir -p /opt/ejabberd/certs/$i$DOMAIN
    cp /etc/letsencrypt/live/$i$DOMAIN/fullchain.pem /opt/ejabberd/certs/$i$DOMAIN/
    cp /etc/letsencrypt/live/$i$DOMAIN/privkey.pem /opt/ejabberd/certs/$i$DOMAIN/
done

# Add permissions to the certificates
chown -R ejabberd:ejabberd /opt/ejabberd/certs

# Step 6: Add admin user in the configuration file
sudo nano /opt/ejabberd/conf/ejabberd.yml

# Modify the domain name
# hosts:
#   - domain.com            <== Modify this line with your domain name

# Add all certificates in the configuration file
# certfiles:
#   - "/opt/ejabberd/certs/*/*.pem"
#

# Add new port in the configuration file
#  -
#    port: 5380
#    ip: "::"
#    module: ejabberd_http
#    tls: false
#    request_handlers:
#      /.well-known/acme-challenge: ejabberd_acme

# Add admin user in the configuration file
# acl:
#   admin:                    <== Add this line
#     user:                   <== Add this line
#       - "admin@domain.com"  <== Add this line

# Add admin user in the configuration file
# mod_muc:
#   host: "muc.domain.com"

# Step 7: Config nginx
sudo nano /etc/nginx/sites-available/default

# Modify the server with this configuration
#  server {
#    listen 80;
#    server_name domain.site;
#
#    location /.well-known/acme-challenge/ {
#        proxy_pass http://127.0.0.1:5380;
#    }
# }


# Step 8: Restart nginx and ejabberd
sudo systemctl restart nginx
sudo systemctl restart ejabberd

# Step 9: Add admin user
sudo /opt/ejabberd-24.10/bin/ejabberdctl register admin domain.com password

# Step 10: Open
echo "Open http://localhost:5280/admin/ in your browser and login with admin and password"

