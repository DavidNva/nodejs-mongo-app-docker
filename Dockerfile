# Es la imagen base de la cual se crea
FROM node:18 
#Aqui se indica la carpeta a crear (como comandos en linux), una carpeta donde vamos a meter el codigo fuente de nuestra aplicacion. Esta ruta, es una ruta dentro del mismo contenedor (no hace referencia a la maquina fisica, sino al contenedor)
#el -p es por si la carpeta no existe (lo cual es correcto) entonces los crea automaticamente, de esta forma no falla, y no pasa nada si ya existiesen
RUN mkdir -p /home/app 

#por supuesto tambien debemos indicar de donde va a sacar el codigo fuente que va a meter dentro de este contenedor: si o si COPY, porque si usamemos RUN recordemos que este ultimo es para ejecutar instrucciones del SO de linux, pero COPY permite acceder a los archivos del SO anfitrion, en nuestro caso Windows (Nuestra PC) para tomar esos archivos y luego colocarlos dentro de nuestro contenedor. Se indica de donde /en este caso decimos de la raiz (ruta del anfitrion (nuestra PC) y sigue la ruta del destino donde colocaremos el codigo fuente que en nuestor caso definimos que es /home/app (este es para el container)
COPY . /home/app

#Una vez configurado lo anterior, ahora debemos exponer un puerto, para que otros contenedores o inclusive, nosotros desde localhost, desde nuestro SO anfitrion podamos contenectarnos a este contenedor. usamos en nuestro ejemplo: 

EXPOSE 3000   

#Ahora indicamos el comando que debe ejecutar para que nuestra aplicacion corra.
#Es decir, practicamente es como si abrieramos CMD y ejecutaramos el node index.js directo, solo que en este caso indicamos primero que comando es (node) y segundo el archivo, en este caso, como ahora estara en al carpeta /home/app/index.js, por ello se escribe de esa forma
CMD ["node", "/home/app/index.js"]
# FROM node:18

# RUN mkdir -p /home/app

# COPY . /home/app

# EXPOSE 3000

# CMD ["node", "/home/app/index.js"]



