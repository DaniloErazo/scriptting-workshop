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

modificar_usuario() {
    clear
    echo "Modificar usuario"
    read -p "Ingrese el nombre del usuario a modificar: " usuario_a_modificar

    if id "$usuario_a_modificar" &>/dev/null; then
        read -p "Ingrese el nuevo nombre para el usuario $usuario_a_modificar: " nuevo_nombre_usuario


        if id "$nuevo_nombre_usuario" &>/dev/null; then
            echo "El nuevo nombre de usuario ya está en uso."
        else
            sudo usermod -l "$nuevo_nombre_usuario" "$usuario_a_modificar"
            echo "Usuario $usuario_a_modificar modificado a $nuevo_nombre_usuario correctamente."
        fi
    else
        echo "El usuario $usuario_a_modificar no existe."
    fi

    read -p "Presione Enter para continuar..."
    gestion_usuarios 
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
            modificar_usuario
            ;;
        4)
            main_menu 
            ;;
        *)
            echo "Opción inválida. Intente de nuevo."
            gestion_usuarios 
            ;;
    esac
}


crear_departamento() {
    clear
    echo "Crear departamento"
    read -p "Ingrese el nombre del nuevo departamento: " nuevo_depto


    if grep -q "^$nuevo_depto:" /etc/group; then
        echo "El departamento $nuevo_depto ya existe."
    else
        sudo groupadd "$nuevo_depto"
        echo "Departamento $nuevo_depto creado correctamente."
    fi

    read -p "Presione Enter para continuar..."
    gestion_deptos 
}


eliminar_departamento() {
    clear
    echo "Eliminar departamento"
    read -p "Ingrese el nombre del departamento a eliminar: " depto_a_eliminar

    if grep -q "^$depto_a_eliminar:" /etc/group; then
        sudo groupdel "$depto_a_eliminar"
        echo "Departamento $depto_a_eliminar eliminado correctamente."
    else
        echo "El departamento $depto_a_eliminar no existe."
    fi

    read -p "Presione Enter para continuar..."
    gestion_deptos # 
}

modificar_departamento() {
    clear
    echo "Modificar departamento"
    read -p "Ingrese el nombre del departamento a modificar: " depto_a_modificar

    if grep -q "^$depto_a_modificar:" /etc/group; then
        read -p "Ingrese el nuevo nombre para el departamento $depto_a_modificar: " nuevo_nombre_depto


        if grep -q "^$nuevo_nombre_depto:" /etc/group; then
            echo "El nuevo nombre ya está en uso."
        else
            sudo groupmod -n "$nuevo_nombre_depto" "$depto_a_modificar"
            echo "Departamento $depto_a_modificar modificado a $nuevo_nombre_depto correctamente."
        fi
    else
        echo "El departamento $depto_a_modificar no existe."
    fi

    read -p "Presione Enter para continuar..."
    gestion_deptos
}


gestion_deptos() {
    clear
    echo "Menú de gestión de departamentos"
    echo "1. Crear departamento"
    echo "2. Eliminar departamento"
    echo "3. Modificar departamento"
    echo "4. Volver al menú principal"
    read -p "Ingrese su opción: " opcion_deptos

    case $opcion_deptos in
        1)
            crear_departamento
            ;;
        2)
            eliminar_departamento
            ;;
        3)
            modificar_departamento
            ;;
        4)
            main_menu 
            ;;
        *)
            echo "Opción inválida. Intente de nuevo."
            gestion_deptos
            ;;
    esac
}



assign_depto() {
    clear
    echo "Asignar usuario a departamento"
    read -p "Ingrese el nombre de usuario: " nombre_usuario
    read -p "Ingrese el nombre del departamento al que desea agregar al usuario: " nombre_departamento

    if id "$nombre_usuario" &>/dev/null; then
        if grep -q "^$nombre_departamento:" /etc/group; then
            sudo usermod -aG "$nombre_departamento" "$nombre_usuario"
            echo "Usuario $nombre_usuario agregado al departamento $nombre_departamento."
        else
            echo "El departamento $nombre_departamento no existe."
        fi
    else
        echo "El usuario $nombre_usuario no existe."
    fi

    read -p "Presione Enter para continuar..."
    asignacion_deptos 
}

unassign_depto() {
    clear
    echo "Quitar usuario de departamento"
    read -p "Ingrese el nombre de usuario: " nombre_usuario
    read -p "Ingrese el nombre del departamento del que desea quitar al usuario: " nombre_departamento

    if grep -q "^$nombre_departamento:" /etc/group; then
        sudo gpasswd -d "$nombre_usuario" "$nombre_departamento"
        echo "Usuario $nombre_usuario eliminado del departamento $nombre_departamento."
    else
        echo "El departamento $nombre_departamento no existe."
    fi

    read -p "Presione Enter para continuar..."
    asignacion_deptos
}


asignacion_deptos() {
    clear
    echo "Menú de asignación de departamentos"
    echo "1. Asignar usuario a departamento"
    echo "2. Eliminar usuario de departamento"
    echo "3. Volver al menú principal"
    read -p "Ingrese su opción: " opcion_asign
    
    case $opcion_asign in 
    	1) assign_depto
    	   ;;
    	
    	2) unassign_depto 
    	   ;;
    	   
    	3) main_menu
    	   ;;
    	
    	*) echo "Opción inválida. Intente de nuevo."
            asignacion_deptos
            ;;
    esac
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
            modificar_usuario
            ;;
        4)
            main_menu 
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
    echo "1. Crear departamento"
    echo "2. Eliminar departamento"
    echo "3. Modificar departamento"
    echo "4. Volver al menú principal"
    read -p "Ingrese su opción: " opcion_deptos

    case $opcion_deptos in
        1)
            crear_departamento
            ;;
        2)
            eliminar_departamento
            ;;
        3)
            modificar_departamento
            ;;
        4)
            main_menu 
            ;;
        *)
            echo "Opción inválida. Intente de nuevo."
            gestion_deptos
            ;;
    esac
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

main_menu
