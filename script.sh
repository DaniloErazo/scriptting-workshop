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
    else 
		if grep -q "^$nuevo_usuario:" datos_usuarios; then
            echo "El usuario está deshabilitado"
            read -p "Presione Enter para volver al menu..."
            gestion_usuarios
        else
			# Solicitar contraseña para el nuevo usuario
			read -s -p "Ingrese una contraseña para el nuevo usuario: " passwd
			echo
			# Crear el usuario con el comando useradd
			sudo useradd -m -s /bin/bash "$nuevo_usuario"
			# Establecer la contraseña para el nuevo usuario
			echo "$nuevo_usuario:$passwd" | sudo chpasswd

			#Guardar los datos del usuario en archivo
			archivo=datos_usuarios
			estado=habilitado
			echo "$nuevo_usuario:$passwd:$estado" >> $archivo

			echo "Usuario $nuevo_usuario creado correctamente."
		fi
    fi

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
		
		sed -i "s/^\($usuario_a_borrar:[^:]*:\)habilitado/\1deshabilitado/" datos_usuarios
		sed -i "/$usuario_a_borrar:/d" datos_departamentos_usuarios

        echo "El usuario $usuario_a_borrar ha sido borrado del sistema."
    else
        echo "El usuario $usuario_a_borrar no existe."
    fi

    read -p "Presione Enter para continuar..."
    gestion_usuarios # Volver al menú de gestión de usuarios
}

habilitar_usuario() {
    clear
    echo "Habilitar usuario"
    read -p "Ingrese el nombre del usuario a habilitar: " usuario_a_habilitar

    if id "$usuario_a_habilitar" &>/dev/null; then
        echo "El usuario $usuario_a_habilitar se encuentra habilitado."
    else
        sudo useradd -m -s /bin/bash "$usuario_a_habilitar"
        passwd=$(grep "^$usuario_a_habilitar:" datos_usuarios | cut -d: -f2)
        echo "$usuario_a_habilitar:$passwd" | sudo chpasswd

        sed -i "s/^\($usuario_a_habilitar:[^:]*:\)deshabilitado/\1habilitado/" datos_usuarios

        echo "El usuario $usuario_a_habilitar ha sido habilitado"
    fi

    read -p "Presione Enter para continuar..."
    gestion_usuarios
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
            if grep -q "^$nuevo_nombre_usuario:" datos_usuarios; then
                echo "El nuevo nombre de usuario ya está en uso, pero el usuario está deshabilitado"
            else
                sudo usermod -l "$nuevo_nombre_usuario" "$usuario_a_modificar"
                sudo groupmod -n "$nuevo_nombre_usuario" "$usuario_a_modificar"
				
                sed -i "s/$usuario_a_modificar:/$nuevo_nombre_usuario:/" datos_usuarios
                sed -i "s/$usuario_a_modificar:/$nuevo_nombre_usuario:/" datos_departamentos_usuarios
				
				echo "Usuario $usuario_a_modificar modificado a $nuevo_nombre_usuario correctamente."
            fi
        fi
    else
        echo "El usuario $usuario_a_modificar no existe."
    fi

    read -p "Presione Enter para continuar..."
    gestion_usuarios 
}

crear_departamento() {
    clear
    echo "Crear departamento"
    read -p "Ingrese el nombre del nuevo departamento: " nuevo_depto


    if grep -q "^$nuevo_depto:" /etc/group; then
        echo "El departamento $nuevo_depto ya existe."
    else
        sudo groupadd "$nuevo_depto"
		
		#Guardar los datos del usuario en archivo
			archivo=datos_departamentos
			estado=habilitado
			echo "$nuevo_depto:$estado" >> $archivo
		
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
		
		sed -i "s/^\($depto_a_eliminar:\)habilitado/\1deshabilitado/" datos_departamentos
		sed -i "/$depto_a_eliminar:/d" datos_departamentos_usuarios
		
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
			
			sed -i "s/$depto_a_modificar:/$nuevo_nombre_depto:/" datos_departamentos
            sed -i "s/$depto_a_modificar:/$nuevo_nombre_depto:/" datos_departamentos_usuarios
			
            echo "Departamento $depto_a_modificar modificado a $nuevo_nombre_depto correctamente."
        fi
    else
        echo "El departamento $depto_a_modificar no existe."
    fi

    read -p "Presione Enter para continuar..."
    gestion_deptos
}

assign_depto() {
    clear
    echo "Asignar usuario a departamento"
    read -p "Ingrese el nombre de usuario: " nombre_usuario
    read -p "Ingrese el nombre del departamento al que desea agregar al usuario: " nombre_departamento

    if id "$nombre_usuario" &>/dev/null; then
        if grep -q "^$nombre_departamento:" /etc/group; then
            sudo usermod -aG "$nombre_departamento" "$nombre_usuario"
			
			echo "$nombre_usuario:$nombre_departamento:" >> datos_departamentos_usuarios
			
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
		
		sed -i "/$nombre_usuario:$nombre_departamento:/d" datos_departamentos_usuarios
		
        echo "Usuario $nombre_usuario eliminado del departamento $nombre_departamento."
    else
        echo "El departamento $nombre_departamento no existe."
    fi

    read -p "Presione Enter para continuar..."
    asignacion_deptos
}

gestion_usuarios() {
    clear
    echo "Menú de gestión de usuarios"
    echo "1. Crear usuario"
    echo "2. Deshabilitar usuario"
	echo "3. Habilitar usuario"
    echo "4. Modificar usuario"
    echo "5. Volver al menú principal"
    read -p "Ingrese su opción: " opcion_usuarios

    case $opcion_usuarios in
        1)
            crear_usuario
            ;;
        2)
            deshabilitar_usuario
            ;;
        3)
			habilitar_usuario
			;;
		4)
            modificar_usuario
            ;;
        5)
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

main_menu() {
    clear
    echo "Menú principal de gestión de empresa"
    echo "1. Gestión de usuarios"
    echo "2. Gestión de departamentos"
    echo "3. Asignación de usuarios a departamentos"
    echo "4. Gestión de logs"
    echo "5. Gestión del sistema"
    echo "6. Gestión de actividades de usuarios"
    echo "7. Salir"
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
			gestion_sistema
            ;;
        6) 
            rastrear_actividades
			;;
        7)
            exit 0
            ;;
        *)
            echo "Opción inválida. Intente de nuevo."
            main_menu
            ;;
    esac
}

main_menu
source gestion_logs.sh
source gestion_sistema.sh
source gestion_actividades.sh