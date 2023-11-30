#!/bin/bash

rastrear_actividades() {
    clear
    echo "Menú de rastreo de actividades de usuarios"
    echo "1. Actividad de inicio de sesión"
    echo "2. Actividad de comandos ejecutados por usuarios"
    echo "3. Actividad de usuarios loggeados"
    echo "4. Archivos modificados recientemente por usuarios"
    echo "5. Volver al menú principal"
    read -p "Seleccione una opción: " opcion

    case $opcion in
        1)
            actividad_inicio_sesion
            ;;
        2)
            actividad_comandos_ejecutados
            ;;
        3) 
            actividad_loggeados
            ;;
        4)
            archivos_modificados
            ;;
        5)
            main_menu 
            ;;
        *)
            echo "Opción no válida."
            rastrear_actividades
            ;;
    esac
}



actividad_inicio_sesion() {
    echo "Actividad de inicio de sesión:"
	echo "1. Ver la actividad de un usuario"
	echo "2. Ver toda la actividad"
	echo "3. Volver al menu de rastrear actividades"
	read -p "Seleccione una opción: " opcion
	
	case $opcion in 
		1)
			read -p "Ingrese el nombre del usuario: " usuario_a_rastrear
			last | grep "$usuario_a_rastrear"
			;;
		2)
			last
			;;
		3)
			rastrear_actividades
			;;
		*)
			echo "Opción no válida."
			rastrear_actividades
			;;
	esac
	
    read -p "Presione Enter para continuar..."
    rastrear_actividades
}

actividad_comandos_ejecutados() {
    echo "Actividad de comandos ejecutados por usuarios:"
    cat /var/log/auth.log | grep 'sudo\|su\|runuser' | grep -E 'COMMAND=' | awk '{print $1, $2, $9, $10, $11, $12, $13, $14}'
    read -p "Presione Enter para continuar..."
    rastrear_actividades
}

archivos_modificados() {
    echo "Archivos modificados recientemente por usuarios:"
    sudo find /home/*/ -type f -not -path '*/\.*' -mtime -1
    read -p "Presione Enter para continuar..."
    rastrear_actividades
}

actividad_loggeados() {
    echo "Usuarios loggeados:"
    who
    read -p "Presione Enter para continuar..."
    rastrear_actividades
}


rastrear_actividades
