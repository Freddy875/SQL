Tipos de datos primitivos
-Caracteres
	SQL CHAR VARCHAR TEXT
	RDBMS NVARCHAR, VARCHARN, VARCHAR2, ETC
-Numero
	SQL   NUMERIC, DECIMAL
	RDBMS INT; INTEGER,  SAMLLINT, FLOAT, TINYINT, BIGINT, MONEY
-Tiempos 
	SQL TIME, DATE, TIMESTAMP
	RDBMS   DATETIME, YEAR, MONTH, DAY 

-Especiales 
	SQL BLOB, BOOLEAN
	RDBMS IMAGE, CLOB, BIT

Busquedas

> Numericos, tiempos
< Numericos, tiempos
>= Numericos, tiempos
<= Numericos, tiempos
=  Todo tipo de datos
!= Todo tipo de datos

Relacionales/ especiales 

BETWEEN     Numeros/Tiempo
NOT BETWEEN Numeros/Tiempo
IN          Todo tipo de dato
NOT IN      Todo tipo de dato
IS NULL     Todo tipo de dato
IS NOT NULL Todo tipo de dato
LIKE        Caracteres
NOT LIKE    Caracteres

----------------------------------------------------------
BETWEEN

Es hacer busqueda por medio de un rango y lo solicita en un rango inicial 
y adem�s de ser un rango cerrado.

WHERE <nombreCol> BETWEEN <valorInicial> AND <ValorFinal>

SELECT *
FROM asignatura
WHERE alumnos BETWEEN 50 AND 150

SELECT *
FROM asignatura
WHERE alumnos NOT BETWEEN 50 AND 150

---------------------------------------------

Es un operador que trea varios valores a evaluar para un solo atributo
Es la union de varios OR sobre el mismo atributo

WHERE <nombreCol> IN (<valor>[,...])

SELECT *
FROM profesor
WHERE dedicacion IN ('TC', '3 h');

-----------------------------------------------------------

IS NULL/ IS NOT NULL
Es un operador de busqueda que regresa los atributos cuyo valor sea NULL


WHERE <nombreCol> IS NULL | IS NOT NULL

SELECT * 
FROM profesor
WHERE categoria IS NULL;

SELECT *
FROM asignatura
WHERE alumnos IS NULL;

--------------------------------------------------------------

LIKE/ NOT LIKE

Es un operador de busqueda que trabaja con comodines para hacer patrones.


%	0 o mas caracter
_	1 caracter forzoso	
[]	* postresq text::[exp regual] 


*/

SELECT *
FROM departamento
WHERE codigo LIKE 'E%';


SELECT *
FROM departamento
WHERE codigo LIKE 'E__';

------------------------------------------------------------
Operadores logicos
Uni0n de restricciones
	
()
AND
OR

------------------------------------------------------------
Para hacer un cast

SELECT codigo, local
FROM docencia
WHERE local NOT LIKE '%1 %'
AND CAST(codigo AS CHAR(3)) NOT LIKE '%1' ;

SELECT codigo, local
FROM docencia
WHERE local NOT LIKE '%1 %'
AND CAST(codigo AS CHAR(3)) NOT LIKE '__1' ;

------------------------------------------------------------

Sintaxis general y estandar de DATABASE

CREATE DATABASE <nombreBD>;

--------------------------------------------

Sintaxis para cambiar de BD

\c <nombreBD>;
---------------------------------------------

Sintaxis general y estandar TABLE

CREATE TABLE <nombreTbl>
(
	<nombreCol> <tipoDato>[(long)] [NOT NULL|NULL],
	{...},
	
	[CONSTRAINT [...]],
	{...}
);

------------------------------------------------

Sintaxis general y estandar para borrar TABLE

DROP TABLE <nombreTbl>;

------------------------------------------------

Sintaxis para describir la estructura de un tabla

\d <nombreTbl>;

-------------------------------------------------

Sintaxis general y estandar del CONSTRAINT FK

CONSTRAINT <nombreCons>
FOREIGN KEY (<nombreCol>[,...])
REFERENCES <nombreTbl>(<nombreCol>[,...])
[ON DELETE CASCADE | ON DELETE RESTRICT]
[ON UPDATE CASCADE | ON UPDATE RESTRICT]

-------------------------------------------------

Sintaxis general y estandar para el CONSTRAINT CHECK

CONSTRAINT <nombreCons>
CHECK (<nombreCol> <RESTRICCION>)

CONSTRAINT ckCarRegister_dateInventory_date
CHECK (register_date < inventory_date),
	
CONSTRAINT ckCarNo_Active_Yn
CHECK (no_active_yn IN ('y','n','Y','N')),

CONSTRAINT ckCarPrice
CHECK (price BETWEEN 1000 AND 50000)

--------------------------------------------------

Sintaxis general y estandar para CONSTRAINT UNIQUE

CONSTRAINT <nombreCons>
UNIQUE (<nombreCol>[,...])

--------------------------------------------------

Instruccion estandar y general para INSERT

INSERT INTO <nombreTbl>
VALUES (<valor1>[,...]);

INSERT INTO project_status_type
VALUES (1, 'Activo', NULL, NULL);

-- Insert implicito
INSERT INTO <nombreTbl>
VALUES (<valor1>[,...]);

-- Insert explicito
INSERT INTO <nombreTbl> (<nombreCol>[,..)]
VALUES (<valor1>[,...]);

---------------------------------------------------

SELECT *
FROM project_status_type;

---------------------------------------------------

Sintaxis general y estandar para UPDATE

UPDATE <nombreTbl>
SET <nombreCol>=<nuevoVal>[,...]
[WHERE <condicion>];

UPDATE project_status_type
SET id = 10
WHERE id = 1;

----------------------------------------------------

Sintaxis general y estandar para DELETE

DELETE FROM <nombreTbl>
[WHERE <condicion>];

DELETE FROM project_status_type
WHERE id = 10;

----------------------------------------------------

Sintaxis general y estandar para crear un TYPE

CREATE TYPE <nombreTipo> FROM <tipoDato>[(long)] [CONSTRAINT];

--Postgresql
CREATE DOMAIN <nombreTipo> AS <tipoDato>[(long)] [CONSTRAINT];

CREATE DOMAIN descripcion AS VARCHAR(250) 
	CHECK (VALUE != 'Sin descripcion');

CREATE DOMAIN nombre AS CHAR(10) CHECK (VALUE  IN ('juan', 'ana', 'paco', 'luis'));

CREATE DOMAIN cantidad AS NUMERIC(5,0) CHECK (VALUE BETWEEN 2000 AND 20000);

----------------------------------------------------

Listar los DOMAIN

\dD

----------------------------------------------------

Sintaxis general y estandar para un DEFAULT


<nombreCol> <tipoDato>[(long)] [CONSTRAINT] DEFAULT <valorDf>

bandera CHAR(1) NOT NULL DEFAULT '1'

----------------------------------------------------

Sintaxis general y estandar para crear INDEX

CREATE [UNIQUE] INDEX <nombreIdx> ON <nombreTbl>(<nombreCol>[,..]);

CREATE INDEX idxEjemploBandera ON ejemplo(bandera);

CREATE UNIQUE INDEX idxEjemploPkFechaRegistro ON ejemploPk(fechaRegistro);

----------------------------------------------------

Fución en postgresql  para calcular una tupla

pg_column_size(<atributo>)

SELECT pg_column_size(clients.*)
FROM clients;

----------------------------------------------------

Función en postgresql para cuanto ocupa
un o varios indices */

pg_indexes_size('<nombreTbl>');

SELECT pg_indexes_size('clients');

----------------------------------------------------

Función para retornar en KB un valor

pg_size_pretty()

SELECT pg_size_pretty((pg_indexes_size('clients')));

----------------------------------------------------

Calculo de un BDR en Postgresql

1. Tienen que saber el tamaño del renglón de datos (tupla)
	a. Renglón con solamente datos
	b. El tamaño de los indices por renglón de datos.

	D se calcula con pg_column_size
	I se calcula con pg_indexes_size

	TRD = D + I
	
	D se devuelve en KB
	I se devuelve en B, por lo se tiene que se tiene
	que hacer el pg_size_pretty para convertir a KB,
	si solo tenemos un indice PK 16Kb

2. El TRD de una tabla se multiplica por el número de registros que va a tener esa tabla (USUARIO)

	TT = TRD * numReg

	TT es calculado en KB

3. Todos los tamaños de la tabla se suman y se obtiene
el tamaño aproximado de la BD en KB, por lo se calcula a GB.


Si BD es ANT	3 años

156

TB / 2 = 78 = 1 año

78 * 3 = 234 gb

TTP = TTB + Proyeccion

TTP = 156 + 234 = 390 gb

Si BD es BNT   	5 años

78 * 5 = 390 gb

TTP = TTB + Proyeccion

TTP = 156 + 390 =  546 gb

---------------------------------------------------------

Sintaxis general y estandar para agregar un CONSTRAINT 

ALTER TABLE <nombreTbl>
ADD CONSTRAINT <sintaxisCons>;

ALTER TABLE history_person
ADD CONSTRAINT pkHistory_person
PRIMARY KEY (id);

ALTER TABLE history_person
ADD CONSTRAINT uqHistory_personTime_start
UNIQUE (time_start);

ALTER TABLE history_person
ADD status CHAR(3) NULL;

ALTER TABLE history_person
ADD CONSTRAINT ckHistory_personActive_yn
CHECK (active_yn IN ('Y','N'));

---------------------------------------------------------

Sintaxis general y estandar quitar en un tabla CONSTRAINT

ALTER TABLE <nombreTbl>
DROP CONSTRAINT <nombreCons>;

----------------------------------------------------------

Hacer una relación 1 a 1 completamente d�bil entre person y history_person

ALTER TABLE history_person
ADD person_id INT NULL;

ALTER TABLE history_person
ADD CONSTRAINT fkHistory_personPerson
FOREIGN KEY (person_id)
REFERENCES person(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE history_person
ADD CONSTRAINT uqHistory_personPerson_id
UNIQUE (person_id);

-----------------------------------------------------------

Sintaxis general y estándar para agregar COLUMN atributos

ALTER TABLE <nombreTbl>
ADD [COLUMN] <nombreCol> <tipoDato>[(long)] [NOT NULL|NULL];

ALTER TABLE history_person
ADD status CHAR(3) NULL;

-----------------------------------------------------------

Sintaxis estandar y general para borrar una COLUMN atributo.

ALTER TABLE <nombreTbl>
DROP COLUMN <nombreCol>;

-----------------------------------------------------------

Sintaxis general de un cambio de tipo de dato

ALTER TABLE <nombreTbl>
ALTER COLUMN <nombreCol> TYPE <nuevoTipoDato>[(nuevaLong)];

-----------------------------------------------------------

Sintaxis general para cambiar la long es la misma que para cambiar el tipo de dato

ALTER TABLE history_person
ALTER COLUMN status TYPE VARCHAR(10);

-----------------------------------------------------------

Sintaxis para cambiar el nombre de una tabla 

ALTER TABLE history_person
RENAME TO historyPerson;

------------------------------------------------------------

Sintaxis general para cambiar el nombre COLUMN (atributo)

ALTER TABLE <nombreTbl>
RENAME COLUMN <nombreCol> TO <nombreNuevo>;

-------------------------------------------------------------

Sintaxis general para cambiar el nombre de CONSTRAINT


ALTER TABLE <nombreTbl>
RENAME CONSTRAINT <nombreCons> TO <nombreNuevo>;

ALTER TABLE historyPerson
RENAME CONSTRAINT ckhistory_personactive_yn TO ckHistoryPersonActiveYn;

-------------------------------------------------------------

Sintaxis general para cambiar de NO NULO a NULO

ALTER TABLE <nombreTbl>
ALTER COLUMN <nombreCol> DROP NOT NULL;

ALTER TABLE historyPerson
ALTER COLUMN registry DROP NOT NULL;

-------------------------------------------------------------

Sintaxis general para cambiar de NULO a NO NULO

ALTER TABLE <nombreTbl>
ALTER COLUMN <nombreCol> SET NOT NULL;

ALTER TABLE historyPerson
ALTER COLUMN personId SET NOT NULL;

-------------------------------------------------------------

--Buscar un valor en la table

SELECT nombre
FROM profesor
WHERE dedicacion = '6 h ';

--Mostrar el numero de elementos guardado en la tabla
SELECT COUNT (*) FROM departamento;
SELECT COUNT (*) FROM area;


-------------------------------------------------------------

ALTER SESSION SET nls_date_format='DD/MM/YYYY';

-------------------------------------------------------------

Agrupamientos

SELECT 
FROM
WHERE 
	AND
	OR
GRUOP BY	-- despues WHERE o FROM
-------------------------------------------------------------
Agrupamientos

SELECT
FROM
WHERE
	AND 
	OR
GROUP BY	-- despues WHERE o FROM



SELECT creditos, COUNT(*) 
FROM asignatura
GROUP BY creditos;

COUNT Todo tipo de dato
MAX	Todo tipo de dato
MIN	Todo tipo de dato
AVG	Números
SUM	Números

-------------------------------------------------------------

HAVING  Es el restricción del agrupamiento

-- Error porque el where trabaja con restriccion simple

-- Having no hace restricciones simples

-------------------------------------------------------------

ORDER BY
Es una claúsula que ordena ascendente y descendente

Order by es la última instrucción

ORDER BY <atributo> ASC|DESC [,..]

-------------------------------------------------------------

SELECT 
FROM
	WHERE
		AND | OR
	GROUP BY
		HAVING
			AND | OR
	ORDER BY
-------------------------------------------------------------

Funciones de agregado sql 92

MATEMATICAS
	SQRT, ABS, CEILING, FLOOR, ROUND
CARACTER
TIEMPO

--------------------------------------------------------------

ABS 

Saca el valor absoluto de un n�mero

ABS(<valor>)

--------------------------------------------------------------

SQRT

Devuelve la raiz cuadrada de un valor

SQRT(<valor>)

--------------------------------------------------------------

ROUND

Rendondeo de un valor

ROUND(<valor>, <#dec>)

---------------------------------------------------------------

CEILING

Elevar a una unidad arriba a aquellos que tengan decimal

SELECT CEILING(8.000000001);

--9

----------------------------------------------------------------

FLOOR

Es la forma estandar de aplicar un truncado

FLOOR(<valor>)

SELECT FLOOR(8.000000001);

--8

-----------------------------------------------------------------

Ámbitos Funciones de Agregado
FLOOR, ABS, SUBTRING, POSITION, DATE_PART, CURRENT_TIME
SELECT
WHERE
HAVING

------------------------------------------------------------------

Ámbitos Funciones de Agrupado
MAX, MIN, COUNT, SUM, AVG
SELECT
HAVING

------------------------------------------------------------------

MATEMATICAS
Siempre reciben un valor numerico y su valor de retorno siempre es uno y es tambien numerico. 
SQRT(), ABS(), CEILING(), ROUND(),
FLOOR() 
-------------------------------------------------------------------

CARACTER/TEXTO
Reciben al menos un valor y el valor de retorno puede ser o caracter o numerico.

--------------------------------------------------------------------

Convierten de minusculas a mayasculas o viceversa.

UPPER(<cadena>)
LOWER(<cadena>)

Valor de retorno es un caracter

---------------------------------------------------------------------

TRIM
Función que quita caracteres al inicio y/o al final de una cadena.

TRIM(LEADING|TRAILING|BOTH '<caracterQuitar>' FROM <'cadenaOriginal'>)

Valor de retorno es un caracter

----------------------------------------------------------------------

CHAR_LENGTH

Función regresa en n�mero de long de una cadena

CHAR_LENTGH(<cadena>);

Valor de retorno un número

----------------------------------------------------------------------

POSITION

Función que devuelve el valor posicional de una cadena respecto a otra

POSITION(<'cadena'> IN <'cadenaOriginal'>)

Valor de retorno es un número

----------------------------------------------------------------------

SUBSTRING

Función que substrae un cadena o caracter de otra.

SUBSTRING(<cadena> FROM <numeroInicio> FOR <#caracteres>)

Valor de retorno caracter

----------------------------------------------------------------------

CONCAT
Es una función que concatena dos cadenas.

CONCAT(<cadena>, <cadena>)

Valor de retorno cadena


Operadores de concatenación
||
+
*/

SELECT 	'Profesor: ' 
	|| nombre
	|| ' usted fue contratado en '
	|| CAST(fecha_contratacion AS CHAR(10))
FROM profesor;

----------------------------------------------------------------------

Funciones de agregado

Agrupado (MAX, MIN, COUNT, AVG, SUM)

Tipo de dato(ABS, ROUND, CEILING, FLOOR, CONCAT, CAST, TRIM, 

SUBSTRING,POSITION, SQRT, CHAR_LENTGH, UPPER, LOWER)

UPDATE profesor
SET contrasenia =  activo
		|| UPPER(SUBSTRING(TRIM(TRAILING ' ' FROM nombre) FROM CHAR_LENGTH(TRIM(TRAILING ' ' FROM nombre))-1 FOR 2))
		|| LOWER(SUBSTRING(ape_pat FROM 1 FOR 1))
		|| SUBSTRING(dedicacion FROM 1 FOR 1)
		|| 'prof';


-----------------------------------------------------------------------

CASE	
	WHEN 	<restriccion>	THEN  <resultado>
	...
	ELSE <resultado>
END AS <alias>	


SELECT 	nombre, 		
	CASE
		WHEN activo = '1' THEN 'Activo'
		ELSE 'Inactivo'
	END AS activo,
	dedicacion
FROM 	profesor;

------------------------------------------------------------------------

AGE

AGE([timestamp <fechaFinal>,] timestamp <fechaInicial>))

SELECT AGE(TIMESTAMP '2000-12-31', TIMESTAMP '1975-01-04');


-- No se debe poner timestamp cuando lo que se le pasa a funcion es una fecha
SELECT AGE(TIMESTAMP CURRENT_TIMESTAMP, TIMESTAMP fecha_contratacion)
FROM profesor;


SELECT AGE(CURRENT_TIMESTAMP, fecha_contratacion)
FROM profesor;

--------------------------------------------------------------------------

SELECT DATE_PART('CENTURY' , TIMESTAMP '2000-12-12 13:02');

CENTURY		siglo
DAY		el día de la fecha
DECADE		decada
DOW		el de la semana (L)	
ISODOW		el de la semana (D)
DOY		el día del año
HOUR		la hora
MICROSECONDS	microsegundos
MILLENNIUM	milenio
MILLISECONDS
MINUTE
MONTH
QUARTER		
SECOND
WEEK		número de la semana
YEAR

----------------------------------------------------------------------------

Algebra relacional
Es la forma en que se aplica SQL a las tablas para manejar los datos.

Es conjunto de 8 operadores.
Conjuntos:
UNION B		UNION
INTERSECCIÓN B	INTERSECT
DIFERENCIA B	EXCEPT/MINUS
PRODUCTO CARTESIANO B	CROSS JOIN
Relacionales:
PROYECCIÓN U	SELECT
RESTRICCIÓN U	WHERE
JOIN	B	INNER JOIN
DIVISIÓN  U/B	SUBCONSULTA

----------------------------------------------------------------------------

UNION
Es la unión de los registros /tuplas de dos relaciones sin repitidos.

SELECT ...
UNION
SELECT ...;

Pre-requisitos:

1. Es que las tablas a operar deben de ser del mismo grado.
2.  Los atributos a unir deben ser del mismo tipo o mapeable
3. El encabezado de resultado siempre sera el encabezado de la primer relaci�n.

SELECT ...
UNION ALL
SELECT ...;

---------------------------------------------------------------------------


INTERSECT
Es indicar que tuplas están en ambas tablas.

SELECT ...
INTERSECT
SELECT ...;

----------------------------------------------------------------------------

MINUS/EXCEPT
Son las tuplas que están en la primer relación y que no aparezcan en la segunda relación.

SELECT ...
EXCEPT
SELECT ...;

-----------------------------------------------------------------------------

CROSS JOIN
Es la creación de parejas ordenas de tuplas entre dos relaciones.

1. El grado resultante será suma de grados de las tablas operadas
2. La cardinalidad resultante será la multiplicación de la cardinalidades

SELECT *
FROM <tablaA> CROSS JOIN <tablaB>;

------------------------------------------------------------------------------

JOIN = INNER JOIN, LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN, SELF JOIN, NATURAL JOIN

Juntar dos tablas con ayuda de un atributo en común para mostrar la informaci�n en una tabla.

SELECT 	*
FROM 	<tablaA> INNER JOIN <tablaB>
   	ON (<tablaA>.<col> = <tablaB>.<col>);

SELECT 	*
FROM 	area INNER JOIN departamento
	ON (area.departamento = departamento.codigo);

LEFT OUTER JOIN
RIGHT OUTER JOIN
FULL OUTER JOIN

SELECT 	*
FROM 	area LEFT OUTER JOIN departamento
	ON (area.departamento = departamento.codigo);


SELECT 	*
FROM 	area RIGHT OUTER JOIN departamento
	ON (area.departamento = departamento.codigo);

SELECT 	*
FROM 	area FULL OUTER JOIN departamento
ON (area.departamento = departamento.codigo);

--------------------------------------------------------------------------------

SELF JOIN
Se realiza INNER, LEFT, RIGHT, FULL pero sobre una tabla RECURSIVA.

SELECT *
FROM <tablaA> x JOIN <tablaA> y
	ON (x.<colComun>=y.<colComun>);





































































































































































































































	














































