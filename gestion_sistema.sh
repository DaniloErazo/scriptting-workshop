#!/bin/bash

gestion_sistema() {
    clear
    echo "Menú de gestión del sistema"
    echo "1. Estado de la CPU"
    echo "2. Uso de memoria"
    echo "3. Uso de almacenamiento"
    echo "4. Información de red"
    echo "5. Volver al menú principal"
    read -p "Seleccione una opción: " opcion

    case $opcion in
        1)
            estado_cpu
            ;;
        2)
            uso_memoria
            ;;
        3)
            uso_almacenamiento
            ;;
        4)
            info_red
            ;;
        5)
            main_menu # Función que muestra el menú principal
            ;;
        *)
            echo "Opción no válida."
            gestion_sistema
            ;;
            
    esac
}


estado_cpu() {
    echo "Estado de la CPU:"
    top -n 1 | grep "Cpu"
    read -p "Presione Enter para continuar..."
    gestion_sistema
}


uso_memoria() {
    echo "Uso de memoria:"
    free -m
    read -p "Presione Enter para continuar..."
    gestion_sistema
}

uso_almacenamiento() {
    echo "Uso de almacenamiento:"
    df -h
    read -p "Presione Enter para continuar..."
    gestion_sistema
}

info_red() {
    echo "Información de red:"
    ifconfig
    read -p "Presione Enter para continuar..."
    gestion_sistema
}

gestion_sistema