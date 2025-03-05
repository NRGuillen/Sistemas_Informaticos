#!/bin/bash

# Script para gestionar usuarios - Solo ejecutable por sysadmin

# Verificar si el usuario es sysadmin
if ! groups | grep -q "sysadmin"; then
    echo "ERROR: Solo los sysadmin pueden ejecutar este script."
    exit 1
fi

# Menú interactivo
while true; do
    echo "=== Gestión de Usuarios ==="
    echo "1. Crear usuario"
    echo "2. Eliminar usuario"
    echo "3. Listar usuarios"
    echo "4. Salir"
    read -p "Selecciona una opción: " opcion

    case $opcion in
        1)
            read -p "Nombre del usuario: " nombre
            read -p "Grupo (sysadmin/devs/office): " grupo
            sudo useradd -m -G "$grupo" -s /bin/bash "$nombre"
            read -s -p "Contraseña: " pass
            echo "$nombre:$pass" | sudo chpasswd
            echo -e "\nUsuario $nombre creado en el grupo $grupo."
            ;;
        2)
            read -p "Nombre del usuario a eliminar: " nombre
            sudo userdel -r "$nombre"
            echo "Usuario $nombre eliminado."
            ;;
        3)
            echo "Usuarios del sistema:"
            cut -d: -f1 /etc/passwd
            echo "Información detallada:"
            getent passwd | grep -E "sysadmin|devs|office"
            ;;
        4)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción inválida."
            ;;
    esac
done