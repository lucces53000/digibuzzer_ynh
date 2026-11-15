#!/bin/bash

# Shared helpers for DigiBuzzer lifecycle scripts.

source /usr/share/yunohost/helpers

install_node_dependencies() {
    pushd "$install_dir" >/dev/null
        ynh_hide_warnings ynh_exec_as_app npm ci --no-audit --no-fund
        ynh_hide_warnings ynh_exec_as_app env VITE_DEFAULT_LANGUAGE=fr VITE_LEGAL_TERMS_LINK= npm run build
    popd >/dev/null
}

configure_systemd_runtime() {
    ynh_config_add_systemd
    chown root:root "/etc/systemd/system/$app.service"
    chmod 640 "/etc/systemd/system/$app.service"
}

configure_runtime() {
    mkdir -p "$data_dir/avatars"
    if [ -d "$install_dir/avatars" ] && [ ! -L "$install_dir/avatars" ]; then
        cp -a "$install_dir/avatars/." "$data_dir/avatars/"
        rmdir "$install_dir/avatars" 2>/dev/null || ynh_safe_rm "$install_dir/avatars"
    elif [ -e "$install_dir/avatars" ] && [ ! -L "$install_dir/avatars" ]; then
        ynh_die "avatars existe mais n'est pas un répertoire ou un lien symbolique valide."
    fi
    ln -sfn "$data_dir/avatars" "$install_dir/avatars"

    chown -R "$app:$app" "$data_dir" "$install_dir"
    chmod 750 "$data_dir" "$data_dir/avatars"

    cat > "$data_dir/redis.conf" <<EOF
bind 127.0.0.1
protected-mode yes
port $port_redis
tcp-backlog 128
timeout 0
logfile ""
dir $data_dir
dbfilename dump.rdb
appendonly yes
appendfilename appendonly.aof
appendfsync everysec
pidfile $data_dir/redis.pid
requirepass $db_pwd
EOF
    chown root:"$app" "$data_dir/redis.conf"
    chmod 640 "$data_dir/redis.conf"
}
