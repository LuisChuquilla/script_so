#!/bin/bash

# Archivo de texto para guardar el historial de comandos
HISTORIAL="historial.txt"

# Archivo de texto para guardar la información de usuarios
USUARIOS="usuarios.txt"

# Función para mostrar el menú principal
mostrar_menu_principal() {
  clear
  echo "Menú Principal"
  echo "1. Iniciar sesión"
  echo "2. Registrarse"
  echo "3. Iniciar sesión como invitado"
  echo "4. Salir"
  read -p "Ingrese su opción: " opcion
}

# Función para mostrar el menú de administrador
mostrar_menu_administrador() {
  clear
  echo "Menú de Administrador"
  echo "1. Ver historial de comandos"
  echo "2. Ejecutar comando 'ls'"
  echo "3. Ejecutar comando 'pwd'"
  echo "4. Ejecutar comando 'mkdir'"
  echo "5. Ejecutar comando 'rm'"
  echo "6. Salir"
  read -p "Ingrese su opción: " opcion
}

# Función para mostrar el menú de usuario normal
mostrar_menu_usuario_normal() {
  clear
  echo "Menú de Usuario Normal"
  echo "1. Ver historial de comandos"
  echo "2. Ejecutar comando 'ls'"
  echo "3. Ejecutar comando 'pwd'"
  echo "4. Salir"
  read -p "Ingrese su opción: " opcion
}
function ejecutar_comando2 {
  case $opcion in
    1)
      history
      ;;
    2)
      ls -l
      ;;
    3)
      pwd
      ;;
    4)
      exit
      ;;
    *)
      echo "Opción inválida"
      ;;
  esac
}

# Función para mostrar el menú de invitado
mostrar_menu_invitado() {
  clear
  echo "Menú de Invitado"
  echo "1. Ver historial de comandos"
  echo "2. Ejecutar comando 'cd'"
  echo "3. Ejecutar comando 'ls'"
  echo "4. Salir"
  read -p "Ingrese su opción: " opcion
}

function ejecutar_comando3 {
  case $opcion in
    1)
      history
      ;;
    2)
      read -p "Ingrese el directorio al que desea cambiar: " dir_name
      cd $dir_name
      ;;
    3)
      ls -l
      ;;
    4)
      exit
      ;;
    *)
      echo "Opción inválida"
      ;;
  esac
}

# Función para ejecutar comandos y guardar historial
ejecutar_comando() {
  comando=$1
  echo "$comando" >> $HISTORIAL
  eval $comando
}
function ejecutar_comando {
  case $opcion in
    1)
      history
      ;;
    2)
      ls -l
      ;;
    3)
      pwd
      ;;
    4)
      read -p "Ingrese el nombre del directorio a crear: " dir_name
      mkdir $dir_name
      ;;
    5)
      read -p "Ingrese el nombre del archivo o directorio a eliminar: " file_name
      rm $file_name
      ;;
    6)
      exit
      ;;
    *)
      echo "Opción inválida"
      ;;
  esac
}

# Función para registrar un nuevo usuario
registrar_usuario() {
  read -p "Ingrese su usuario: " usuario
  read -p "Ingrese su contraseña: " contrasena
  read -p "Ingrese su tipo de usuario (admin/usuario): " tipo
  echo "$usuario:$contrasena:$tipo" >> $USUARIOS
  echo "Usuario registrado con éxito"
}

# Función para validar la información de usuario
validar_usuario() {
  usuario=$1
  contrasena=$2
  tipo=$3
  if [ -f $USUARIOS ]; then
    while IFS=: read -r user pass tipo_usuario; do
      if [ "$usuario" = "$user" ] && [ "$contrasena" = "$pass" ] && [ "$tipo" = "$tipo_usuario" ]; then
        return 0
      fi
    done < $USUARIOS
  fi
  return 1
}


while true; do
  mostrar_menu_principal
  case $opcion in
    1)
      read -p "Ingrese su usuario: " usuario
      read -p "Ingrese su contraseña: " contrasena
      if validar_usuario $usuario $contrasena "admin"; then
        while true; do
          mostrar_menu_administrador
          case $opcion in
            1)
              cat $HISTORIAL
              ;;
            2)
              ejecutar_comando "ls"
              ;;
            3)
              ejecutar_comando "pwd"
              ;;
            4)
              ejecutar_comando "mkdir"
              ;;
            5)
              ejecutar_comando "rm"
              ;;
            6)
              break
              ;;
          esac
        done
      elif validar_usuario $usuario $contrasena "usuario"; then
        while true; do
          mostrar_menu_usuario_normal
          case $opcion in
            1)
              cat $HISTORIAL
              ;;
            2)
              ejecutar_comando2 "ls"
              ;;
            3)
              ejecutar_comando2 "pwd"
              ;;
            4)
              break
              ;;
          esac
        done
      else
        echo "Acceso denegado"
      fi
      ;;
    2)
      registrar_usuario
      ;;
    3)
      while true; do
        mostrar_menu_invitado
        case $opcion in
          1)
            cat $HISTORIAL
            ;;
          2)
            ejecutar_comando3 "cd"
            ;;
          3)          
            ejecutar_comando3 "ls"
            ;;
          4)
            break
            ;;
        esac
      done
      ;;
    4)
      echo "Saliendo del sistema"
      exit 0
      ;;
  esac
done





 
