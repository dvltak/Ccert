#!/bin/bash

echo "========== TLS Certificate Auto Installer for Marznode =========="

# Ask for email
read -p "Enter your Email address: " USER_EMAIL

# Ask for domain
read -p "Enter your Domain name: " DOMAIN

# Certificate path
CERT_PATH="/var/lib/marznode/certs"

echo "-------------------------------------------------------------"
echo "Installing required package (socat)..."
apt install socat -y

echo "-------------------------------------------------------------"
echo "Installing acme.sh..."
curl https://get.acme.sh | sh -s email=$USER_EMAIL

echo "-------------------------------------------------------------"
echo "Creating certificate directory..."
mkdir -p $CERT_PATH

echo "-------------------------------------------------------------"
echo "Issuing certificate for domain: $DOMAIN"
~/.acme.sh/acme.sh \
  --issue --force --standalone -d "$DOMAIN" \
  --fullchain-file "$CERT_PATH/$DOMAIN.cer" \
  --key-file "$CERT_PATH/$DOMAIN.cer.key"

echo "-------------------------------------------------------------"
echo "Certificate has been installed successfully!"
echo ""
echo "Your certificate files are located at:"
echo "Fullchain: $CERT_PATH/$DOMAIN.cer"
echo "Private Key: $CERT_PATH/$DOMAIN.cer.key"
echo ""
echo "Add these to your inbound configuration:"
echo "\"certificateFile\": \"$CERT_PATH/$DOMAIN.cer\","
echo "\"keyFile\": \"$CERT_PATH/$DOMAIN.cer.key\""
echo ""
echo "===================== DONE ====================="
