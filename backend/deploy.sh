#!/bin/bash
# =====================
# Gitasarathi NestJS — Deploy Script
# =====================
EC2_USER="ubuntu"
EC2_HOST="ec2-13-232-176-172.ap-south-1.compute.amazonaws.com"  # ✅ NEW SERVER
EC2_PATH="/var/www/gitasarathi.hiteshbuilds.com/"  # ✅ RENAMED PATH
LOCAL_DIST="dist"
LOCAL_PACKAGE_JSON="package.json"
LOCAL_PACKAGE_LOCK="package-lock.json"

# SSH Key Locations
SSH_KEYS=(
  "/Users/hitesh/local/keys/aws/geek_lab_key_pair.pem"  # ✅ FIXED PATH
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
  echo "❌ Error: No valid SSH key found!"
  exit 1
fi
echo "✅ Using SSH key: $SSH_KEY"

# =====================
# Build NestJS project locally
# =====================
echo "🚀 Building NestJS project..."
npm install
npm run build

if [ ! -d "$LOCAL_DIST" ]; then
  echo "❌ NestJS build failed. dist/ directory not found."
  exit 1
fi
echo "✅ NestJS build complete."

# =====================
# Ensure remote directory exists
# =====================
echo "📁 Ensuring remote directory exists..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no \
  "$EC2_USER@$EC2_HOST" "mkdir -p $EC2_PATH"

# =====================
# Upload dist/, package files & .env.production to EC2
# =====================
echo "📦 Uploading to EC2..."
rsync -avz \
  -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
  $LOCAL_DIST $LOCAL_PACKAGE_JSON $LOCAL_PACKAGE_LOCK .env.production \
  $EC2_USER@$EC2_HOST:$EC2_PATH

# =====================
# Install dependencies & restart PM2 on server
# =====================
echo "🔧 Installing dependencies & restarting PM2..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" << 'EOF'
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  cd /var/www/gitasarathi.hiteshbuilds.com/
  mv .env.production .env
  npm install --production
  pm2 restart gitasarathi || pm2 start dist/main.js --name gitasarathi
  pm2 save
EOF

echo "✅ Gitasarathi deployed successfully!"
echo "🌐 Live at: https://gitasarathi.hiteshbuilds.com"