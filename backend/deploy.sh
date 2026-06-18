#!/bin/bash

# =====================
# Configuration
# =====================
EC2_USER="ubuntu"
EC2_HOST="ec2-13-126-138-232.ap-south-1.compute.amazonaws.com"
EC2_PATH="/var/www/gitasarathi.geekaid.in/"
LOCAL_DIST="dist"
LOCAL_PACKAGE_JSON="package.json"
LOCAL_PACKAGE_LOCK="package-lock.json"

# SSH Key Locations
SSH_KEYS=(
  "/Users/user/hp/keys/geek_lab_key_pair.pem"
  "/home/hitesh-patel/Dev/keys/aws/geek_lab_key_pair.pem"
)

# =====================
# Find the first available SSH key
# =====================
for key in "${SSH_KEYS[@]}"; do
  if [ -f "$key" ]; then
    SSH_KEY="$key"
    break
  fi
done

if [ -z "$SSH_KEY" ]; then
  echo "Error: No valid SSH key found!"
  exit 1
fi

echo "Using SSH key: $SSH_KEY"

# =====================
# Build NestJS project locally
# =====================
echo "Building NestJS project..."
npm install
npm run build

# =====================
# Upload files to EC2
# =====================
echo "Uploading dist/ folder and package files to EC2..."
rsync -avz -e "ssh -i $SSH_KEY" $LOCAL_DIST $LOCAL_PACKAGE_JSON $LOCAL_PACKAGE_LOCK .env $EC2_USER@$EC2_HOST:$EC2_PATH

# =====================
# Install dependencies and restart the app on EC2
# =====================
ssh -i $SSH_KEY $EC2_USER@$EC2_HOST <<EOF
  cd $EC2_PATH
  npm install --production
  pm2 restart gitasarathi || pm2 start dist/main.js --name gitasarathi
  pm2 save
EOF

echo "Deployment completed successfully!"
