#!/bin/bash

mkdir -p build_dir
cd build_dir

if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "GitHub SSH is configured"
else
    echo "SSH connection with GitHub is not configured, please configure it to make the script work"
    exit 1
fi

echo "Cloning IHM repository"
git clone git@github.com:BOOK-STORE-AND-CIPHER-INFORMATIONS/IHM.git

echo "Cloning Client repository"
git clone git@github.com:BOOK-STORE-AND-CIPHER-INFORMATIONS/Client.git

echo "Cloning API repository"
git clone git@github.com:BOOK-STORE-AND-CIPHER-INFORMATIONS/Server.git

echo "Building Docker images..."

echo "Building API image..."
cp ../.env Server/.env
cd Server
if docker build --target frankenphp_prod --build-arg RELEASE_VERSION=beta -f Dockerfile.prod -t api .; then
    echo "✓ Server image built successfully"
else
    echo "✗ Failed to build Server image"
    exit 1
fi
cd ..

echo "Building IHM image..."
cd IHM
git switch fra_ihm  # TODO : Remove and put working code in main
if docker build -f Dockerfile.dev -t ihm .; then
    echo "✓ IHM image built successfully"
else
    echo "✗ IHM cache image"
    exit 1
fi
cd ..


# Build Chest Opener service image
echo "Building Client image..."
cd Client
git switch deployment # TODO : Remove
if docker build -t client .; then
    echo "✓ Client image built successfully"
else
    echo "✗ Failed to build Client image"
    exit 1
fi
cd ..

echo "All Docker images built successfully!"
echo "Available images:"
docker images | grep -E "(client|api|ihm)"

echo "You can now run the project using docker compose up after having configured the .env"

exit 0