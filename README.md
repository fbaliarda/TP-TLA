# TP-ReCtas

Para compilar el lenguaje, el usuario tiene que estar ubicado en el directorio src, dentro el proyecto y necesita tener instalado Bison, Flex, gcc y make. Un vez instalados los programas, se debe correr la siguiente instrucción en bash: 

				$> make all
		
Esta instrucción compila el lenguaje y genera el archivo “recetas” que contiene el parser del lenguaje. Una vez generado el lenguaje, para compilar una receta se debe correr la siguiente instrucción: 
  		
				$> ./reCtas.sh nombreReceta.rc

Donde reCtas.sh es el archivo bash que compila y nombreReceta.rc es el nombre del archivo que contiene la receta a compilar. Esto genera el ejecutable nombreReceta y nombreReceta.c que contiene la receta en lenguaje C.
