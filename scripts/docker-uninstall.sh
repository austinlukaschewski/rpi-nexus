# Uninstall Docker and rmemove related [immediate] data.

REMOVE_VAR_LIB_LIST=("docker" "containerd");
REMOVE_ETC_APT_LIST=("docker.list" "keyrings/docker.asc");

for dir in "${REMOVE_VAR_LIB_LIST[@]}"; do
    if [ -d "/var/lib/$dir" ]; then
        echo "Removing directory: /var/lib/$dir"
        sudo rm -rf "/var/lib/$dir"
    else
        echo "Directory /var/lib/$dir does not exist, skipping."
    fi
done;

for file in "${REMOVE_ETC_APT_LIST[@]}"; do
    if [ -f "/etc/apt/sources.list.d/$file" ] || [ -f "/etc/apt/$file" ]; then
        echo "Removing file: /etc/apt/sources.list.d/$file or /etc/apt/$file"
        sudo rm -f "/etc/apt/sources.list.d/$file" || sudo rm -f "/etc/apt/$file"
    else
        echo "File /etc/apt/sources.list.d/$file or /etc/apt/$file does not exist, skipping."
    fi
done;