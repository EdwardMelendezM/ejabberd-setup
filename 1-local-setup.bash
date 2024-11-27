# Local setup
# Execute this script step by step

# Step 1: Download ejabberd installer
wget https://github.com/processone/ejabberd/releases/download/24.10/ejabberd-24.10-1-linux-x64.run

# Step 2: Make the installer executable
chmod +x ./ejabberd-24.10-1-linux-x64.run

# Step 3: Run the installer
./ejabberd-24.10-1-linux-x64.run

# Step 4: Check status of ejabberd
systemctl status ejabberd

# Step 5: Add admin user in the configuration file
sudo nano /opt/ejabberd/conf/ejabberd.yml

# Add the following lines in the configuration file
#
# acl:
#   admin:                   <== Add this line
#     user:                  <== Add this line
#       - "admin@localhost"  <== Add this line
# 

# Step 6: Restart ejabberd
sudo systemctl restart ejabberd

# Step 7: Add admin user
sudo /opt/ejabberd-24.10/bin/ejabberdctl register admin localhost password

# Step 8: Open
echo "Open http://localhost:5280/admin/ in your browser and login with admin and password"