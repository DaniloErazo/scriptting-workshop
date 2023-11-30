#!/bin/bash
#include <stdio.h>

gestion_logs() {
    clear
    echo "Menú de gestión de logs"
    echo "1. Estadísticas de usuarios creados"
    echo "2. Estadísticas de usuarios eliminados"
    echo "3. Estadísticas de usuario que elimina"
    echo "4. Estadísticas de sesiones iniciadas"
    echo "5. Volver al menú principal"
    read -p "Ingrese su opción: " opcion_logs

	case $opcion_logs in
        1)
            contar_usuarios_creados
            ;;
        2)
            contar_usuarios_eliminados
            ;;
        3)
            contar_usuario_que_elimina
            ;;
        4)
            contar_sesiones_iniciadas
            ;;
        5)
            main_menu
            ;;
        *)
            echo "Opción inválida. Intente de nuevo."
            gestion_logs
            ;;
    esac
}

contar_usuarios_creados() {
	clear
	echo "Cantidad de veces que se ha creado un usuario"
	grep "useradd" /var/log/auth.log | grep -v "GID" | awk '{print $NF}' | sort | uniq -c
    read -p "Presione Enter para continuar..."
	gestion_logs
}

contar_usuarios_eliminados() {
	clear
	echo "Cantidad de veces que se ha eliminado un usuario"
	grep "delete user" /var/log/auth.log | grep -v "GID" | awk '{print $NF}' | sort | uniq -c
	read -p "Presione Enter para continuar..."
    gestion_logs
}

contar_usuario_que_elimina() {
	clear
	echo "Cantidad de veces que un usuario ha eliminado otros usuarios"
	grep "userdel" /var/log/auth.log | grep "COMMAND" | awk '{print $6}' | sort | uniq -c
	read -p "Presione Enter para continuar..."
    gestion_logs
}

contar_sesiones_iniciadas() {
	clear
	echo "Cantidad de veces que se ha logeado un usuario"
	grep "Started Session" /var/log/syslog | awk '{print $NF}' | sort | uniq -c
	read -p "Presione Enter para continuar..."
    gestion_logs
}

gestion_logs