# Plantilla base rackslabs utilizando next13 con app router nextauth y shadcn

## SETUP PROYECTO

El proyecto viene con un crud muy básico en el que hay usuarios y post, de esta manera se puede observar como funciona la lógica de la apliación y como está organizada la estructura de carpetas.

El core de la aplicación reside en la carpeta src, ahi podemos encontrar el app reouter de next así como los componentes librerias de utilidades y módulos de la aplicación

Responsabilidad de cada una de las carpetas

### app

App router de next, aqui estará incluido el router de nuestra apliación es decir las vistas de la misma y donde se renderizarán los componentes visuales.

### components

Aquí encontraremos los componentes visuales de la aplicación así como los componentes de shadcn instalados, separaremos los componentes de manera semantica por carpetas, por ejemplo crearemos una carpeta auth para guardar los componentes relativos a las paginas de autenticación ( formularios, pantallas de login...)

### hooks

aquí guardaremos los hooks de react que vayamos utilizando y creando a lo largo del desarrollo, echar un vistazo a https://usehooks.com/ para ver hooks comunes en apps de react

### lib

aquí encontraremos distintas funciones de utilidad que usaremos a lo largo de la aplicación, por ejemplo el singleton para conectarse a la base de datos, funciones de cryptografia para hashear contraseñas...

### modules

aqui encontraremos el core lógico de nuestra aplicación, donde encontraremos carpetas nombradas en funcion del area de dominio que ataque la lógica ubicada dentro. Dentro de cada una de estas carpetas encontraremos las subcarpetas services y domain, en services se encontrarán las funciones que ejecuten la logica que modificará ese area de negocio y en domain se encontraran las definiciones y tipos de esas entidades. Por ejemplo en la carpeta de negocio user dentro de services encontrariamos las funciones createUser() y dentro de domain encontraríamos por ejemplo la interfaz de User.

Esta metodologia de organización esta en fase beta, ya que es una simplificación de ddd pero sin abstraer la infraestructura al 100%, el objetivo es que una persona que se incorpore al equipo o que tenga que tocar código de otro pierda la menor cantidad de tiempo posible entendiendo que es lo que tiene que hacer y donde están ubicadas esas funciones, y reducir su tasa de equivocación ya que las entidades estarán bien definidas de forma previa.

### styles

Los estilos globales de la app

### types

archivos para tipar clases "especiales" como por ejemplo la session de nextauth

# Convenciones de Mensajes de Commit

Este documento describe las convenciones de mensajes de commit que se utilizan en este proyecto siguiendo el estándar de `conventional-changelog`. Estas convenciones ayudan a mantener un registro organizado de los cambios en el proyecto y generan automáticamente un registro de cambios (changelog) fácil de leer.

## Tipos de Commit

Los siguientes tipos de commit se utilizan en este proyecto:

1. **`build`**: Se utiliza cuando se hacen cambios relacionados con el sistema de compilación o construcción (por ejemplo, ajustes en configuraciones de Webpack o scripts de construcción).

2. **`chore`**: Normalmente se usa para tareas de mantenimiento, refactorización o cambios que no afectan al comportamiento del usuario final. Pueden ser actualizaciones de dependencias, cambios en archivos de configuración, etc.

3. **`ci`**: Relacionado con las configuraciones y scripts de integración continua (por ejemplo, acciones de GitHub, Travis CI, Jenkins, etc.).

4. **`docs`**: Usado para cambios en la documentación, como agregar, actualizar o corregir documentación en el código o en archivos README.

5. **`feat`** (feature): Indica que se ha agregado una nueva característica o funcionalidad al proyecto.

6. **`fix`**: Se utiliza cuando se corrige un error o bug en el código.

7. **`perf`** (performance): Se refiere a cambios que mejoran el rendimiento de la aplicación sin agregar nuevas funcionalidades.

8. **`refactor`**: Usado para cambios que no agregan ni corrigen ninguna funcionalidad, pero mejoran la estructura del código, la legibilidad o la eficiencia.

9. **`revert`**: Se utiliza cuando se revierte un commit anterior. El mensaje debe explicar por qué se revierte y hacer referencia al commit que se está deshaciendo.

10. **`style`**: Cambios relacionados con la presentación del código, como reformateo, ajustes en la sangría, eliminación de espacios en blanco, etc.

11. **`test`**: Relacionado con la adición o modificación de pruebas unitarias o pruebas automatizadas.

## Ejemplos de Commit

A continuación, se presentan ejemplos de mensajes de commit siguiendo estas convenciones:

- `feat: Agregar autenticación de usuario`
- `fix: Corregir error de validación en el formulario de registro`
- `docs: Actualizar la documentación del API`
- `chore: Actualizar las dependencias`
- `test: Agregar pruebas unitarias para el componente 'Button'`

Recuerda seguir estas convenciones al escribir tus mensajes de commit para mantener un registro claro y consistente de los cambios en el proyecto.

Claro, aquí tienes la descripción en formato Markdown para ejecutar el proyecto SPNP:

## 1. Instalar Dependencias

Dentro del directorio del proyecto, utiliza el siguiente comando para instalar todas las dependencias requeridas:

```bash
npm install
```

## 3. Ejecutar Docker Compose

Asegúrate de tener Docker instalado en tu sistema. Luego, ejecuta el siguiente comando para construir y levantar los contenedores del proyecto en segundo plano:

```bash
docker-compose up -d --build
```

Este comando construirá las imágenes de Docker necesarias y pondrá en marcha los contenedores definidos en el archivo `docker-compose.yml`.
