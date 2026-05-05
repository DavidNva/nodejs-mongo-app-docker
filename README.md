# Aplicación de ejemplo para curso de Docker, del canal Hola Mundo.

Curso completo gratis aca: https://www.youtube.com/watch?v=4Dko5W96WHg

### Documentación para entender Docker
# 🐳 curso-docker-node 

> Documentación completa del curso de Docker aplicado a Node.js + MongoDB.  
> Incluye teoría, comandos, ejemplos, errores comunes, ambiente de desarrollo con hot reload y notas actuales al **28 de abril de 2026**.

---

## 📌 Descripción

Este repositorio documenta lo aprendido en el curso de Docker, usando como ejemplo una aplicación en **Node.js** conectada a **MongoDB**.

La idea de este README es que sirva como guía de consulta rápida, pero también como apuntes completos para recordar qué hace cada comando, por qué se usa y qué problemas puede resolver.

---

## 📚 Temario del curso

- 00:00:00 — ¿Por qué aprender Docker?
- 00:01:26 — Teoría
- 00:14:08 — Instalación
- 00:19:57 — Comandos de imágenes
- 00:28:49 — Comandos de contenedores
- 00:46:10 — Conectándose a los contenedores
- 01:04:24 — Docker Compose
- 01:15:28 — Volumes
- 01:21:38 — Ambientes y hot reload
- 01:28:11 — Logro desbloqueado

---

# 1. 🐳 ¿Por qué aprender Docker?

Docker sirve para ejecutar aplicaciones dentro de **contenedores**.

Un contenedor es como un entorno aislado donde vive nuestra aplicación con todo lo que necesita para funcionar.

Docker ayuda a evitar problemas como:

- “En mi máquina sí funciona”
- Diferencias entre versiones de Node, Mongo, Python, etc.
- Tener que instalar muchas herramientas directamente en nuestra PC
- Problemas al pasar una app de desarrollo a producción

La idea es que la aplicación corra igual en diferentes entornos.

---

# 2. 🧠 Teoría básica

## Imagen

Una imagen es como una plantilla o receta.

Ejemplo:

```bash
node:18
mongo
```

Una imagen todavía no está corriendo. Solo es la base desde donde se pueden crear contenedores.

---

## Contenedor

Un contenedor es una imagen en ejecución.

Ejemplo mental:

```text
Imagen  →  Contenedor
mongo   →  monguito corriendo
```

---

## Flujo básico

```text
Dockerfile  →  Imagen  →  Contenedor
```

- El `Dockerfile` contiene instrucciones.
- Con esas instrucciones se construye una imagen.
- A partir de esa imagen se crean contenedores.

---

# 3. ⚙️ Instalación

Para validar que Docker está instalado:

```bash
docker --version
```

Para probar que Docker funciona correctamente:

```bash
docker run hello-world
```

---

# 4. 📦 Comandos de imágenes

Las imágenes son la base para crear contenedores.

---

## Descargar una imagen

```bash
docker pull node
```

Descarga la imagen de Node.

Si no se indica una versión, Docker descarga la última disponible.

---

## Descargar una versión específica

```bash
docker pull node:18
```

Aquí se descarga específicamente la versión `18` de Node.

Esto es importante porque si usamos solo:

```bash
docker pull node
```

Docker puede descargar una versión más nueva en el futuro, y eso podría cambiar el comportamiento del proyecto.

---

## Ver imágenes disponibles

```bash
docker images
```

Muestra las imágenes que tenemos descargadas localmente.

---

## Eliminar una imagen

```bash
docker image rm node:18
```

Elimina una imagen local.

---

## Descargar un modelo AI con Docker

```bash
docker model pull ai/qwen3:4b-UD-Q4_K_KL
```

Este comando descarga un modelo de AI usando Docker.

---

# 5. 📦 Comandos de contenedores

Los contenedores son instancias creadas a partir de imágenes.

---

## Crear un contenedor

```bash
docker create mongo
```

Crea un contenedor usando la imagen `mongo`.

También existe la forma más larga:

```bash
docker container create mongo
```

Ambos comandos cumplen la misma idea, pero la segunda forma especifica claramente que estamos trabajando con contenedores.

---

## Ejemplo

```bash
docker container create mongo
```

Docker devuelve un ID similar a:

```text
b55cd51ef498d0e5996b384cbf5e994dc0c9294ff95186b07665e4396bce3989
```

Ese ID sirve para identificar el contenedor.

---

## Arrancar un contenedor

```bash
docker start <id-o-nombre>
```

Ejemplo:

```bash
docker start b55cd51ef498
```

o si tiene nombre:

```bash
docker start monguito
```

---

## Ver contenedores corriendo

```bash
docker ps
```

Muestra únicamente los contenedores que están corriendo.

---

## Ver todos los contenedores

```bash
docker ps -a
```

Muestra todos los contenedores, sin importar si están corriendo, detenidos o creados.

---

## Detener un contenedor

```bash
docker stop <id-o-nombre>
```

Ejemplo:

```bash
docker stop monguito
```

---

## Eliminar un contenedor

```bash
docker rm <id-o-nombre>
```

Importante: para eliminar un contenedor normalmente primero debe estar detenido.

```bash
docker stop monguito
docker rm monguito
```

---

## Crear contenedor con nombre personalizado

```bash
docker create --name monguito mongo
```

Esto crea un contenedor llamado `monguito`.

Después podemos manejarlo por nombre:

```bash
docker start monguito
docker stop monguito
docker rm monguito
```

Esto es más cómodo que usar el ID completo.

---

# 6. 🚀 Docker run

`docker run` es uno de los comandos más usados.

Hace varias cosas a la vez:

1. Si no existe la imagen, la descarga.
2. Crea un contenedor.
3. Arranca el contenedor.

Es decir, puede reemplazar este flujo:

```bash
docker pull mongo
docker create mongo
docker start <id>
```

por un solo comando:

```bash
docker run mongo
```

---

## Ejemplo con Mongo

```bash
docker run --name monguito -p27017:27017 -d mongo
```

Qué significa:

```text
docker run      → crea y ejecuta un contenedor
--name monguito → le pone nombre al contenedor
-p27017:27017   → mapea puertos
-d              → ejecuta en segundo plano
mongo           → imagen usada
```

---

## ¿Qué significa `-d`?

`-d` significa:

```text
detached mode
```

O sea:

```text
modo desacoplado / segundo plano
```

Ejemplo:

```bash
docker run -d mongo
```

El contenedor:

- corre en background
- no bloquea la terminal
- devuelve el control inmediatamente

Resumen:

```text
sin -d → corre en primer plano
con -d → corre en segundo plano
```

Forma fácil de recordarlo:

```text
-d = ejecútalo y déjame seguir usando la terminal
```

---

# 7. 🌐 Mapeo de puertos

Este tema es MUY importante.

Un contenedor está aislado. Eso significa que, aunque una aplicación dentro del contenedor esté escuchando en un puerto, nuestra PC no puede acceder automáticamente a ese puerto.

Necesitamos abrir una “puerta” entre:

```text
Host              Contenedor
tu PC / servidor  app dentro de Docker
```

---

## Formato general

```bash
-p HOST:CONTENEDOR
```

Ejemplo:

```bash
-p27017:27017
```

Significa:

```text
Puerto 27017 de mi PC  →  Puerto 27017 del contenedor
```

---

## Ejemplo con Mongo

```bash
docker create -p27017:27017 --name monguito mongo
```

Aquí:

```text
primer 27017  → puerto del host / nuestra PC
segundo 27017 → puerto interno del contenedor
```

Mongo por defecto usa el puerto `27017`, por eso se mapea ese puerto.

---

## Cómo se ve en `docker ps -a`

Al revisar:

```bash
docker ps -a
```

Podemos ver algo parecido a:

```text
0.0.0.0:27017 -> 27017/tcp
```

Esto significa:

```text
localhost:27017 de mi PC está conectado al puerto 27017 del contenedor
```

---

## ¿Qué pasa si solo pongo un puerto?

Ejemplo:

```bash
docker create -p27017 --name monguito2 mongo
```

Aquí solo indicamos el puerto del contenedor.

Como no indicamos el puerto del host, Docker asigna uno automáticamente.

Podríamos ver algo como:

```text
0.0.0.0:54918 -> 27017/tcp
```

Eso significa:

```text
Puerto 54918 de mi PC → puerto 27017 del contenedor
```

Docker eligió `54918` automáticamente.

---

## Recomendación

Es mejor mapear puertos manualmente:

```bash
-p27017:27017
```

porque así sabemos exactamente qué puerto corresponde a qué servicio.

Esto es especialmente útil cuando tenemos varias apps o bases de datos corriendo.

---

## Ejemplo con variables de entorno

```bash
docker create -p27017:27017 --name monguito \
-e MONGO_INITDB_ROOT_USERNAME=nico \
-e MONGO_INITDB_ROOT_PASSWORD=password \
mongo
```

Aquí estamos creando Mongo con:

```text
usuario: nico
password: password
```

La bandera `-e` sirve para pasar variables de entorno al contenedor.

---

# 8. 🔗 Logs y conexión con contenedores

## Ver logs

```bash
docker logs monguito
```

Muestra los logs del contenedor.

---

## Ver logs en tiempo real

```bash
docker logs --follow monguito
```

También se puede abreviar con:

```bash
docker logs -f monguito
```

Esto sirve para ver lo que está pasando dentro del contenedor mientras corre.

---

# 9. 🌐 Redes en Docker

Para que dos o más contenedores puedan comunicarse entre sí, necesitan estar en una red de Docker.

Ejemplo:

```text
Node.js container  →  MongoDB container
```

La aplicación Node necesita hablar con Mongo.

---

## ¿Por qué se necesitan redes?

Porque los contenedores están aislados.

Si tengo un contenedor con Node y otro con Mongo, Node no debería conectarse a Mongo usando `localhost`, porque `localhost` dentro del contenedor Node se refiere al mismo contenedor Node, no al contenedor Mongo.

---

## Ejemplo incorrecto dentro de Docker

```js
mongoose.connect('mongodb://nico:password@localhost:27017/miapp?authSource=admin')
```

Esto puede funcionar desde tu PC, pero dentro de un contenedor normalmente está mal, porque `localhost` apunta al propio contenedor.

---

## Ejemplo correcto entre contenedores

```js
mongoose.connect('mongodb://nico:password@monguito:27017/miapp?authSource=admin')
```

Aquí `monguito` es el nombre del contenedor o servicio de Mongo.

Docker permite que los contenedores dentro de la misma red se encuentren usando sus nombres.

---

## Red manual

Se puede crear una red:

```bash
docker network create mired
```

Y luego conectar contenedores a esa red.

La idea es:

```text
mired
├── contenedor Node
└── contenedor Mongo
```

Todos los contenedores dentro de `mired` pueden comunicarse entre sí.

---

## Redes con Docker Compose

Con Docker Compose normalmente no tenemos que crear la red manualmente.

Compose crea una red automática para los servicios definidos en el `.yml`.

Ejemplo:

```yaml
services:
  chanchito:
    ...
  monguito:
    ...
```

Dentro de esa red, `chanchito` puede comunicarse con `monguito` usando el nombre del servicio:

```js
mongodb://nico:password@monguito:27017/miapp?authSource=admin
```

---

## Nota importante

En el curso se usó:

```yaml
links:
  - monguito
```

Eso funcionaba para conectar servicios, pero actualmente Docker Compose ya crea redes automáticamente, por lo cual `links` ya no es necesario y se considera viejo/obsoleto.

---

# 10. 🧱 Dockerfile: cómo meter una app Node en un contenedor

Para tomar una aplicación construida, por ejemplo en Node.js, y meterla dentro de un contenedor, necesitamos crear un archivo llamado:

```text
Dockerfile
```

Este archivo contiene las instrucciones para construir nuestra imagen.

---

## Nombre del archivo

Para producción, el archivo normalmente se llama:

```text
Dockerfile
```

Sin extensión.

---

## Dockerfile de producción usado en el curso

```dockerfile
# Es la imagen base de la cual se crea nuestra imagen
FROM node:18

# Crea la carpeta donde vamos a meter el código fuente de la aplicación.
# Esta ruta vive dentro del contenedor, no en nuestra PC.
# -p crea carpetas padre si no existen y no falla si ya existe.
RUN mkdir -p /home/app

# Copia los archivos desde nuestra PC hacia el contenedor.
# El primer "." representa la carpeta actual del host.
# "/home/app" es la ruta destino dentro del contenedor.
COPY . /home/app

# Expone el puerto 3000.
# Esto es informativo; el mapeo real se hace con -p o con Docker Compose.
EXPOSE 3000

# Comando que se ejecuta cuando inicia el contenedor.
# Es como abrir terminal y ejecutar: node /home/app/index.js
CMD ["node", "/home/app/index.js"]
```

---

## Explicación línea por línea

### `FROM node:18`

Indica la imagen base.

Todas las imágenes que nosotros creemos se basan en otra imagen.

En este caso usamos Node:

```dockerfile
FROM node:18
```

Si fuera Python, SQL Server u otra tecnología, se indicaría otra imagen.

---

### `RUN mkdir -p /home/app`

Ejecuta un comando Linux dentro de la imagen.

```bash
mkdir -p /home/app
```

`-p` significa `parents`.

Sirve para:

- crear toda la ruta si no existe
- no fallar si ya existe

---

### `COPY . /home/app`

Copia archivos del sistema anfitrión hacia el contenedor.

Importante:

```text
.         → carpeta actual del host
/home/app → carpeta destino dentro del contenedor
```

---

### `EXPOSE 3000`

Documenta que el contenedor usa el puerto `3000`.

Pero `EXPOSE` no publica el puerto por sí solo.

Para poder entrar desde nuestra PC usamos:

```bash
-p3000:3000
```

o en Compose:

```yaml
ports:
  - "3000:3000"
```

---

### `CMD ["node", "/home/app/index.js"]`

Es el comando final que corre la app.

En producción usamos `node`, no `nodemon`.

---

# 11. 🏗 Crear nuestras propias imágenes

Una vez que tenemos el `Dockerfile` en la raíz del proyecto, podemos crear nuestra imagen.

---

## Crear imagen

```bash
docker build -t miapp:1 .
```

Explicación:

```text
docker build → construye una imagen
-t           → tag / etiqueta
miapp:1      → nombre de imagen + versión
.            → contexto de construcción
```

---

## ¿Qué significa `-t`?

`-t` significa `tag`.

Sirve para darle nombre y versión a la imagen.

Ejemplo:

```bash
docker build -t miapp:1 .
```

Aquí:

```text
miapp → nombre de la imagen
1     → versión o tag
```

---

## ¿Qué significa el `.`?

El punto significa:

```text
usa la carpeta actual como contexto
```

Docker podrá leer los archivos de esa carpeta para construir la imagen.

---

## Ver imagen creada

```bash
docker images
```

Ahí debería aparecer:

```text
miapp    1
```

---

# 12. ⚙️ Docker Compose

Docker Compose permite definir y levantar varios contenedores usando un solo archivo `.yml`.

En vez de correr muchos comandos manuales, usamos:

```bash
docker compose up
```

---

## Archivo `docker-compose.yml`

```yaml
# .yml / .yaml es un formato de configuración.
# En el curso se usa version: "3.9".
# Actualmente Docker Compose moderno ya no lo necesita, pero lo dejamos porque el curso lo usa.
version: "3.9"

# services define los contenedores que queremos levantar.
services:
  # Servicio de la aplicación Node.
  chanchito:
    # build indica que este servicio se construye desde un Dockerfile.
    # En producción, build: . usa el Dockerfile por defecto en la carpeta actual.
    build: .

    # Mapeo de puertos: host:contenedor
    ports:
      - "3000:3000"

    # links conecta contenedores.
    # En el curso se usa, pero actualmente está obsoleto/no recomendado.
    # Docker Compose ya crea una red automática para los servicios.
    links:
      - monguito

  # Servicio de MongoDB.
  monguito:
    # Usa la imagen oficial de Mongo.
    # Si no se especifica versión, Docker usa latest.
    image: mongo

    # Puerto de Mongo.
    ports:
      - "27017:27017"

    # Variables de entorno para crear usuario root inicial.
    environment:
      - MONGO_INITDB_ROOT_USERNAME=nico
      - MONGO_INITDB_ROOT_PASSWORD=password

    # Volumen para persistir los datos de Mongo.
    volumes:
      - mongo-data:/data/db

# Definición de volúmenes.
volumes:
  mongo-data:
```

---

## ¿Qué es `services`?

Cada `service` representa un contenedor.

En este proyecto:

```yaml
services:
  chanchito:
  monguito:
```

Tenemos dos servicios:

```text
chanchito → app Node.js
monguito  → MongoDB
```

---

## ¿Qué es `build`?

```yaml
build: .
```

Indica que Docker debe construir una imagen para ese servicio usando un Dockerfile.

El `.` significa que el contexto de construcción es la carpeta actual.

---

## ¿Qué es `ports`?

```yaml
ports:
  - "3000:3000"
```

Conecta puertos entre host y contenedor.

```text
localhost:3000 → contenedor:3000
```

---

## ¿Qué es `environment`?

Permite pasar variables de entorno al contenedor.

Ejemplo:

```yaml
environment:
  - MONGO_INITDB_ROOT_USERNAME=nico
  - MONGO_INITDB_ROOT_PASSWORD=password
```

Mongo usa estas variables para crear el usuario root inicial.

---

## ¿Qué es `volumes`?

En Mongo:

```yaml
volumes:
  - mongo-data:/data/db
```

Esto significa:

```text
mongo-data → volumen administrado por Docker
/data/db   → carpeta interna donde Mongo guarda datos
```

---

# 13. 💾 Volúmenes

Los volúmenes sirven para guardar información fuera del contenedor.

Esto es importante porque los contenedores son temporales.

Si borramos un contenedor sin volumen, se pueden perder datos.

---

## Ejemplo con Mongo

```yaml
volumes:
  - mongo-data:/data/db
```

Mongo guarda sus datos en:

```text
/data/db
```

Por eso conectamos el volumen `mongo-data` a esa ruta.

---

## Rutas comunes de bases de datos

```text
MongoDB  → /data/db
MySQL    → /var/lib/mysql
Postgres → /var/lib/postgresql/data
```

---

## Definir volumen

```yaml
volumes:
  mongo-data:
```

Esto declara el volumen para que Docker Compose lo administre.

---

## Borrar contenedores pero conservar volúmenes

```bash
docker compose down
```

---

## Borrar contenedores y volúmenes

```bash
docker compose down -v
```

Cuidado: esto elimina los datos persistidos.

---

# 14. 🔄 Ambientes y Hot Reload

En desarrollo queremos que al cambiar el código, la app se reinicie automáticamente.

Para eso usamos:

```text
nodemon
```

---

## ¿Qué es nodemon?

`nodemon` es una herramienta para Node.js que reinicia automáticamente la aplicación cuando detecta cambios en archivos.

Sin nodemon:

```bash
node index.js
```

Si cambio el código, tengo que reiniciar manualmente.

Con nodemon:

```bash
nodemon index.js
```

Si cambio el código, nodemon reinicia la app.

---

## Dockerfile.dev usado

```dockerfile
# Imagen base oficial de Node.js.
# CURSO: usa node:18.
# HOY: funciona, pero Node 18 ya es viejo para proyectos nuevos.
# Actual: node:20-alpine o node:22-alpine.
FROM node:18

# Instala nodemon globalmente.
# Hoy no es lo ideal porque no queda controlado por package-lock.json.
# Actual: poner nodemon en devDependencies y correrlo con npm run dev.
RUN npm i -g nodemon

# Crea la carpeta donde vivirá la app dentro del contenedor.
# -p crea carpetas padre si no existen y no falla si ya existe.
RUN mkdir -p /home/app

# Define el directorio de trabajo.
# Después de esto, los comandos se ejecutan desde /home/app.
# Así ya no es necesario indicar la ruta completa en CMD, solo index.js.
WORKDIR /home/app

# Expone el puerto interno donde escucha la app.
# No abre el puerto solo; el mapeo real se hace en docker-compose.
EXPOSE 3000

# Ejecuta la app con nodemon.
# -L significa legacy watch.
# Sirve para detectar cambios en Docker + Windows/WSL/OneDrive.
# --watch "." indica que observe cambios en la carpeta actual.
CMD ["nodemon", "-L", "--watch", ".", "index.js"]
```

---

## ¿Qué significa `-L`?

`-L` significa:

```text
legacy watch
```

Nodemon normalmente usa eventos del sistema de archivos para detectar cambios.

Pero con Docker + Windows + WSL + OneDrive, esos eventos pueden no llegar bien al contenedor.

Entonces `-L` usa un modo más compatible basado en revisar cambios constantemente.

---

## docker-compose-dev.yml usado

```yaml
# CURSO especificaba version: "3.9".
# Actualmente Docker Compose moderno ya no lo necesita.
version: "3.9"

services:
  # Servicio = contenedor
  chanchito:
    # Construye una imagen usando Dockerfile.dev.
    # Como no es el Dockerfile por defecto, se especifica.
    build:
      # context indica la carpeta que Docker usará como contexto de construcción.
      # Es decir, desde dónde Docker puede leer archivos para construir la imagen.
      # El punto "." significa: usa la carpeta actual.
      context: .

      # Indica qué Dockerfile usar.
      dockerfile: Dockerfile.dev

    # Mapea puerto de nuestra máquina al contenedor.
    ports:
      - "3000:3000"

    # Curso usaba links.
    # Actualmente está obsoleto/no recomendado.
    links:
      - monguito

    # Monta la carpeta local dentro del contenedor.
    # Esto permite hot reload con nodemon.
    volumes:
      - .:/home/app

  # Servicio de MongoDB.
  monguito:
    image: mongo

    ports:
      - "27017:27017"

    environment:
      - MONGO_INITDB_ROOT_USERNAME=nico
      - MONGO_INITDB_ROOT_PASSWORD=password

    volumes:
      - mongo-data:/data/db

volumes:
  mongo-data:
```

---

## Volumen para hot reload

```yaml
volumes:
  - .:/home/app
```

Significa:

```text
mi carpeta local → /home/app dentro del contenedor
```

Entonces cuando edito `index.js` en mi PC, el contenedor también ve ese cambio.

---

# 15. ⚔️ Diferencia DEV vs PROD

## Producción

En producción usamos:

```dockerfile
CMD ["node", "/home/app/index.js"]
```

Porque queremos que la app corra estable.

---

## Desarrollo

En desarrollo usamos:

```dockerfile
CMD ["nodemon", "-L", "--watch", ".", "index.js"]
```

Porque queremos que la app se reinicie cuando cambiamos código.

---

## Tabla comparativa

| Tema | DEV | PROD |
|---|---|---|
| Comando | nodemon | node |
| Hot reload | Sí | No |
| Código | volumen `.:/home/app` | `COPY . /home/app` |
| Objetivo | programar rápido | correr estable |
| Dockerfile | Dockerfile.dev | Dockerfile |
| Compose | docker-compose-dev.yml | docker-compose.yml |

---

## Frase clave

```text
En dev montamos código con volumen.
En prod copiamos código dentro de la imagen.
```

---

# 16. 🚨 Errores comunes que pasaron

## 1. `/home/app` vs `/home/apps`

Error:

```text
Error: Cannot find module '/home/app/index.js'
```

Causa:

```dockerfile
COPY . /home/apps
CMD ["node", "/home/app/index.js"]
```

Se copió el código en `/home/apps`, pero Node buscaba en `/home/app`.

Solución:

```dockerfile
COPY . /home/app
```

o ajustar el CMD a la ruta correcta.

---

## 2. Nodemon no detecta cambios

Solución usada:

```dockerfile
CMD ["nodemon", "-L", "--watch", ".", "index.js"]
```

---

## 3. No reconstruir después de cambiar Dockerfile

Si se cambia el Dockerfile, hay que correr:

```bash
docker compose -f docker-compose-dev.yml up --build
```

Porque los cambios de Dockerfile afectan la imagen.

---

## 4. Confundir cambios de código con cambios de imagen

Si solo cambia `index.js` y hay volumen, no debería requerir `--build`.

Si cambia Dockerfile, dependencias o CMD, sí requiere `--build`.

---

# 17. 🧪 Cómo correr el proyecto

## Producción

```bash
docker compose up --build
```

---

## Desarrollo

```bash
docker compose -f docker-compose-dev.yml up --build
```

---

## Apagar servicios

```bash
docker compose down
```

---

## Apagar y borrar volúmenes

```bash
docker compose down -v
```

---

# 18. 🔥 Notas actuales al 28 de abril de 2026

El curso tiene aproximadamente 3 años, entonces varias cosas siguen siendo válidas, pero algunas prácticas cambiaron.

---

## Cosas que siguen siendo válidas

- Concepto de imagen
- Concepto de contenedor
- `docker pull`
- `docker run`
- `docker build`
- `docker compose`
- Volúmenes
- Redes
- Mapeo de puertos

---

## Cosas que hoy se ajustarían

### `version: "3.9"`

Antes:

```yaml
version: "3.9"
```

Hoy Docker Compose moderno puede mostrar warning indicando que `version` es obsoleto.

Actualmente se puede omitir.

---

### `links`

Antes:

```yaml
links:
  - monguito
```

Hoy no se recomienda.

Docker Compose crea una red automática entre servicios.

Más actual:

```yaml
depends_on:
  - monguito
```

Nota: `depends_on` indica orden de arranque, pero no garantiza que Mongo ya esté listo para aceptar conexiones.

---

### `image: mongo`

Antes:

```yaml
image: mongo
```

Esto usa `latest`.

Más recomendado:

```yaml
image: mongo:7
```

o una versión específica.

Esto evita que un cambio en la imagen rompa el proyecto.

---

### Node 18

Antes:

```dockerfile
FROM node:18
```

Hoy para proyectos nuevos normalmente se usaría una versión más actual, por ejemplo:

```dockerfile
FROM node:20-alpine
```

o:

```dockerfile
FROM node:22-alpine
```

---

### nodemon global

Antes:

```dockerfile
RUN npm i -g nodemon
```

Hoy se prefiere instalar nodemon como dependencia de desarrollo:

```bash
npm install --save-dev nodemon
```

y usar:

```json
{
  "scripts": {
    "dev": "nodemon --legacy-watch index.js"
  }
}
```

Luego en Dockerfile:

```dockerfile
CMD ["npm", "run", "dev"]
```

---

### `npm install` vs `npm ci`

Para builds reproducibles se recomienda:

```bash
npm ci
```

porque respeta exactamente el `package-lock.json`.

---

# 19. 🧠 Resumen mental

Docker se entiende mejor con estas 4 ideas:

```text
Imagen     → plantilla
Contenedor → instancia corriendo
Volumen    → persistencia de datos
Red        → comunicación entre contenedores
```

---

# 20. 📎 Cheat Sheet

## Imágenes

```bash
docker pull node
docker pull node:18
docker images
docker image rm node:18
```

---

## Contenedores

```bash
docker create mongo
docker container create mongo
docker start <id-o-nombre>
docker stop <id-o-nombre>
docker rm <id-o-nombre>
docker ps
docker ps -a
```

---

## Logs

```bash
docker logs monguito
docker logs --follow monguito
```

---

## Run

```bash
docker run --name monguito -p27017:27017 -d mongo
```

---

## Build

```bash
docker build -t miapp:1 .
```

---

## Compose

```bash
docker compose up
docker compose up --build
docker compose down
docker compose down -v
docker compose -f docker-compose-dev.yml up --build
```

---

# Con este curso ya se vio:

- Descargar imágenes
- Crear contenedores
- Arrancar y detener contenedores
- Mapear puertos
- Pasar variables de entorno
- Ver logs
- Crear imágenes propias
- Usar Dockerfile
- Usar Docker Compose
- Conectar Node con Mongo
- Usar volúmenes
- Crear ambiente dev con hot reload
---#
