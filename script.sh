#!/bin/bash

crear_usuario() {
    clear
    echo "Creación de usuario"
    read -p "Ingrese el nombre del nuevo usuario: " nuevo_usuario

    # Verificar si el usuario ya existe
    if id "$nuevo_usuario" &>/dev/null; then
        echo "El usuario $nuevo_usuario ya existe."
        read -p "Presione Enter para continuar..."
        gestion_usuarios 
    fi

    # Solicitar contraseña para el nuevo usuario
    read -s -p "Ingrese una contraseña para el nuevo usuario: " passwd
    echo

    # Crear el usuario con el comando useradd
    sudo useradd -m -s /bin/bash "$nuevo_usuario"

    # Establecer la contraseña para el nuevo usuario
    echo "$nuevo_usuario:$passwd" | sudo chpasswd

    echo "Usuario $nuevo_usuario creado correctamente."
    read -p "Presione Enter para continuar..."
    gestion_usuarios # Volver al menú de gestión de usuarios
}


deshabilitar_usuario() {
    clear
    echo "Borrar usuario"
    read -p "Ingrese el nombre de usuario a borrar: " usuario_a_borrar

    # Verificar si el usuario existe antes de intentar borrarlo
    if id "$usuario_a_borrar" &>/dev/null; then
    	
        # Eliminar el usuario y su directorio de inicio
        sudo userdel -f "$usuario_a_borrar"  

        echo "El usuario $usuario_a_borrar ha sido borrado del sistema."
    else
        echo "El usuario $usuario_a_borrar no existe."
    fi

    read -p "Presione Enter para continuar..."
    gestion_usuarios # Volver al menú de gestión de usuarios
}

gestion_usuarios() {
    clear
    echo "Menú de gestión de usuarios"
    echo "1. Crear usuario"
    echo "2. Deshabilitar usuario"
    echo "3. Modificar usuario"
    echo "4. Volver al menú principal"
    read -p "Ingrese su opción: " opcion_usuarios

    case $opcion_usuarios in
        1)
            crear_usuario
            ;;
        2)
            deshabilitar_usuario
            ;;
        3)
            # Lógica para modificar un usuario
            ;;
        4)
            main_menu # Volver al menú principal
            ;;
        *)
            echo "Opción inválida. Intente de nuevo."
            gestion_usuarios # Volver al menú de gestión de usuarios
            ;;
    esac
}





gestion_deptos() {
    clear
    echo "Menú de gestión de departamentos"
    # Mostrar opciones para gestionar departamentos y lógica similar a la gestión de usuarios
}


asignacion_deptos() {
    clear
    echo "Menú de asignación de usuarios a departamentos"
    # Lógica para asignar y desasignar usuarios a departamentos
}


gestion_logs() {
    clear
    echo "Menú de gestión de logs"
    # Lógica para buscar y generar estadísticas en los logs
}


main_menu() {
    clear
    echo "Menú principal de gestión de empresa"
    echo "1. Gestión de usuarios"
    echo "2. Gestión de departamentos"
    echo "3. Asignación de usuarios a departamentos"
    echo "4. Gestión de logs"
    echo "5. Salir"
    read -p "Ingrese su opción: " opcion

    case $opcion in
        1)
            gestion_usuarios
            ;;
        2)
            gestion_deptos
            ;;
        3)
            asignacion_deptos
            ;;
        4)
            gestion_logs
            ;;
        5)
            exit 0
            ;;
        *)
            echo "Opción inválida. Intente de nuevo."
            main_menu
            ;;
    esac
}

# Llamar a la función principal para iniciar el programa
main_menu
