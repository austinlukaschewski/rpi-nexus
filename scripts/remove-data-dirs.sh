DATA_DIRS=("/var/minio", "/var/mongodb", "/var/postgresql")

for dir in "${DATA_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "Removing directory: $dir"
        sudo rm -rf "$dir"
        echo "Directory $dir removed."
    else
        echo "Directory $dir does not exist, skipping."
    fi
done