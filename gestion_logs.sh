#!/bin/bash

gestion_logs() {
    clear
    echo "Menú de gestión de logs"
    # Lógica para buscar y generar estadísticas en los logs
}

contar_usuarios_creados() {
	clear
	echo "Cantidad de veces que se ha creado un usuario"
	grep "useradd" /var/log/auth.log | grep -v "GID" | awk '{print $NF}' | sort | uniq -c
    read -p "Presione Enter para continuar..."
    rastrear_actividades
}

contar_usuarios_eliminados() {
	clear
	echo "Cantidad de veces que se ha eliminado un usuario"
	grep "delete user" /var/log/auth.log | grep -v "GID" | awk '{print $NF}' | sort | uniq -c
	read -p "Presione Enter para continuar..."
    rastrear_actividades
}

contar_usuario_que_elimina() {
	clear
	echo "Cantidad de veces que un usuario ha eliminado otros usuarios"
	grep "userdel" /var/log/auth.log | grep "COMMAND" | awk '{print $6}' | sort | uniq -c
	read -p "Presione Enter para continuar..."
    rastrear_actividades
}

contar_sesiones_iniciadas() {
	clear
	echo "Cantidad de veces que se ha logeado un usuario"
	grep "Started Session" /var/log/syslog | awk '{print $NF}' | sort | uniq -c
	read -p "Presione Enter para continuar..."
    rastrear_actividades
}