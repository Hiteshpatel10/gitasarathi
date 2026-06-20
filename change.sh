ssh -i ~/local/keys/aws/geek_lab_key_pair.pem \
  ubuntu@ec2-13-126-138-232.ap-south-1.compute.amazonaws.com << 'EOF'

for PROJECT in ecosystem.config.js; do
  echo "📦 Syncing $PROJECT..."
  rsync -avz --progress \
    -e "ssh -i ~/.ssh/geek_lab_key_pair.pem -o StrictHostKeyChecking=no" \
    /var/www/$PROJECT \
    ubuntu@ec2-13-232-176-172.ap-south-1.compute.amazonaws.com:/var/www/
done

echo "✅ Sync complete!"
EOF