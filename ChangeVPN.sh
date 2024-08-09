#!/bin/bash

# Функция для проверки статуса VPN соединения
check_vpn_status() {
    local vpn_name=$1
    nmcli connection show --active | grep -q "$vpn_name"
    return $?
}

# Функция для отключения VPN соединения
disconnect_vpn() {
    local vpn_name=$1
    nmcli connection down "$vpn_name"
}

# Функция для включения VPN соединения
connect_vpn() {
    local vpn_name=$1
    nmcli connection up "$vpn_name"
}

# Проверка статуса VPN соединений
check_vpn_status "USS"
USS_STATUS=$?

check_vpn_status "Primo"
PRIMO_STATUS=$?

# Принятие решений в зависимости от статуса VPN соединений
if [ $USS_STATUS -eq 0 ] && [ $PRIMO_STATUS -eq 0 ]; then
    notify-send "VPN status" "Switched to USS"
    echo "Оба соединения запущены. Отключаем Primo и оставляем USS."
    disconnect_vpn "Primo"
elif [ $USS_STATUS -eq 0 ]; then
    notify-send "VPN status" "Switched from USS to Primo"
    echo "Соединение USS запущено. Primo не запущено. Переключаемся на Primo."
    disconnect_vpn "USS"
    connect_vpn "Primo"
elif [ $PRIMO_STATUS -eq 0 ]; then
    notify-send "VPN status" "Switched from Primo to USS"
    echo "Соединение Primo запущено. Переключаемся на USS."
    disconnect_vpn "Primo"
    connect_vpn "USS"
else
    notify-send "VPN status" "Enable USS"
    echo "Оба соединения не запущены. Запускаем USS."
    connect_vpn "USS"
fi


# Commit diff 123
