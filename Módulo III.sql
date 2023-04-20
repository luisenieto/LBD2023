USE `LBD2023`;

-- Consultas básicas - Inserción de datos (1)

DROP TABLE IF EXISTS `Productos`;

CREATE TABLE IF NOT EXISTS `Productos`(
    `idProducto` INT UNSIGNED NOT NULL,
    `nombre` VARCHAR(250) NOT NULL,
    PRIMARY KEY(`idProducto`)
);

INSERT INTO `Productos` VALUES (1, 'Prime'); 
INSERT INTO `Productos` VALUES (2, 'Octoview');
INSERT INTO `Productos` VALUES (2, 'Dreamer'); -- error: viola la PK (las siguientes sentencias no se ejecutan)
INSERT INTO `Productos` VALUES (3, 'Dreamer');
INSERT INTO `Productos` (idProducto, nombre) VALUES (4, 'Bravia');
INSERT INTO `Productos` (nombre, idProducto) VALUES ('Proton', 5);

-- Consultas básicas - Inserción de datos (2)

DROP TABLE IF EXISTS `Productos`;

CREATE TABLE IF NOT EXISTS `Productos`(
    `idProducto` INT UNSIGNED NOT NULL,
    `nombre` VARCHAR(250) NOT NULL,
    `descripcion` VARCHAR(250) NULL,
    PRIMARY KEY(`idProducto`)
);

INSERT INTO `Productos` VALUES (1, 'Prime', 'Descripción 1'); 
INSERT INTO `Productos` VALUES (2, 'Octoview', 'Descripción 2');
INSERT INTO `Productos` VALUES (3, 'Dreamer'); -- error: se esperan 3 valores y se especifican 2

ALTER TABLE `Productos`
ALTER `descripcion` SET DEFAULT NULL;

INSERT INTO `Productos` VALUES (3, 'Dreamer'); -- error: se esperan 3 valores y se especifican 2
INSERT INTO `Productos` (idProducto, nombre) VALUES (3, 'Dreamer1');
INSERT INTO `Productos` (idProducto, nombre, descripcion) VALUES (4, 'Bravia', NULL);
INSERT INTO `Productos` (nombre, idProducto, descripcion) VALUES ('Proton', 5); -- error: se esperan 3 valores y se especifican 2
INSERT INTO `Productos` (nombre, idProducto, descripcion) VALUES ('Proton', 5, NULL); 

INSERT INTO `Productos` VALUES (6, 'Desire', NULL), (7, 'Passion', NULL), (8, 'Emotion', NULL);
INSERT INTO `Productos` VALUES (9, 'Sensation', NULL), (10, "Joy", NULL), (11, 'Explorer', NULL);


-- Consultas básicas - Inserción de datos (3)

INSERT INTO `Productos` VALUES (12, 'Runner', DEFAULT);
INSERT INTO `Productos` (descripcion, nombre, idProducto) VALUES (DEFAULT, 'Traveler', 13);
INSERT INTO `Productos` VALUES (14, 'Walker', DEFAULT), (15, 'Jumper', DEFAULT);

DROP TABLE IF EXISTS `Presupuestos`;

CREATE TABLE IF NOT EXISTS `Presupuestos` (  
    `departamento` INT AUTO_INCREMENT NOT NULL,  
    `anioActual` DECIMAL NULL DEFAULT 0,  
    `anioAnterior` DECIMAL NULL DEFAULT 0,
    PRIMARY KEY (`departamento`)
);

INSERT INTO Presupuestos (anioActual, anioAnterior) VALUES (100000, 150000); -- 1
INSERT INTO Presupuestos (anioActual, anioAnterior) VALUES (NULL, 300000); -- 2
INSERT INTO Presupuestos (anioActual, anioAnterior) VALUES (DEFAULT, 100000); -- 3
INSERT INTO Presupuestos (anioActual, anioAnterior) VALUES (150000, NULL); -- 4
INSERT INTO Presupuestos (anioActual, anioAnterior) VALUES (300000, DEFAULT); -- 5
INSERT INTO Presupuestos (anioAnterior) VALUES (250000); -- 6
INSERT INTO Presupuestos (anioActual, anioAnterior) VALUES (DEFAULT, DEFAULT); -- 7
INSERT INTO Presupuestos VALUES (); -- 8

SELECT * FROM `Presupuestos`;

ALTER TABLE `Presupuestos`
ALTER `departamento` SET DEFAULT 20;

INSERT INTO `Presupuestos` (anioActual, anioAnterior) VALUES (250000, DEFAULT); -- 20
INSERT INTO `Presupuestos` (anioActual, anioAnterior) VALUES (250000, DEFAULT); -- error: viola la PK por el DEFAULT

SELECT * FROM `Presupuestos`;

ALTER TABLE `Presupuestos`
ALTER `departamento` DROP DEFAULT;

INSERT INTO `Presupuestos` (anioActual, anioAnterior) VALUES (250000, DEFAULT); -- error. Hay que volver a decirle que la columna es autoincremental

SELECT * FROM `Presupuestos`;

ALTER TABLE `Presupuestos`
MODIFY `departamento` INT AUTO_INCREMENT NOT NULL;

INSERT INTO `Presupuestos` (anioActual, anioAnterior) VALUES (250000, DEFAULT); -- 21

SELECT * FROM `Presupuestos`;


-- Consultas básicas - Recuperación de datos (1)

SELECT idProducto, nombre, descripcion
FROM Productos;

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE idProducto = 2;

DROP TABLE IF EXISTS `Trabajos` ;

CREATE TABLE IF NOT EXISTS `Trabajos` (
  `idTrabajo` INT NOT NULL,
  `titulo` VARCHAR(150) NOT NULL,
  `duracion` INT NOT NULL,
  `fechaPresentacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `fechaAprobacion` DATE NOT NULL,
  `fechaFinalizacion` DATE NULL,
  PRIMARY KEY (`idTrabajo`))
ENGINE = InnoDB;

INSERT INTO Trabajos VALUES(1, 'Sistema de Gestión de Presupuestación de Obras de Construcción', 6, '2018-05-04', '2018-05-24', NULL);
INSERT INTO Trabajos VALUES(2, 'Implementación de políticas de tráfico para enrutamiento con BGP', 6, '2018-05-04', '2018-05-24', NULL);
INSERT INTO Trabajos VALUES(3, 'Sistema de Gestión y Seguimiento de Trabajos de Graduación de Ingeniería en Computación', 9, '2015-12-15', '2015-12-15', NULL);
INSERT INTO Trabajos VALUES(4, 'Sistema de gestión y página web para una escuela de cocina', 6, '2017-04-03', '2017-04-03', NULL);
INSERT INTO Trabajos VALUES(5, 'Módulo de interfaz de usuario de sistema SCADA', 6, '2018-05-09', '2018-05-24', NULL);

SELECT idTrabajo, titulo, fechaPresentacion
FROM Trabajos
WHERE fechaPresentacion = "2018-05-04"; -- comillas dobles para las fechas

SELECT idTrabajo, titulo, fechaPresentacion
FROM Trabajos
WHERE fechaPresentacion = '2018-05-04'; -- comillas simples para las fechas

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE nombre = "Bravia"; -- comillas dobles para las cadenas

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE nombre = 'bravia'; -- comparación insensible a mayúsculas/minúsculas


-- Consultas básicas - Recuperación de datos (2)

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE nombre LIKE '%me%'; -- cualquier cadena que en algún lugar tenga la cadena "me"

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE nombre LIKE '%e_me%'; -- cualquier cadena que en algún lugar tenga el caracter "e", cualquier caracter y luego la cadena "me"


-- Consultas básicas - Recuperación de datos (3)

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE nombre REGEXP '^P'; -- nombres que empiezan con P

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE nombre REGEXP 'on$'; -- nombres que terminan con on


-- Consultas básicas - Recuperación de datos (4)

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE (nombre REGEXP 'on$') AND (nombre REGEXP '^P'); -- nombres que terminan con on y empiezan con P


-- Consultas básicas - Recuperación de datos (5)

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE  idProducto BETWEEN 2 AND 5;


-- Consultas básicas - Recuperación de datos (6)

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE idProducto IN (1, 3, 8);


-- Consultas básicas - Recuperación de datos (7)

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE descripcion IS NULL;

SELECT idProducto, nombre, descripcion
FROM Productos
WHERE descripcion IS NOT NULL;


-- Consultas básicas - Orden de datos

SELECT idProducto, nombre, descripcion
FROM Productos
ORDER BY nombre; -- por nombre ascendentemente

SELECT idProducto, nombre, descripcion
FROM Productos
ORDER BY 2 DESC; -- por nombre descendentemente


-- Consultas básicas - Eliminación de duplicados

SELECT anioActual, anioAnterior
FROM Presupuestos;

SELECT DISTINCT anioActual, anioAnterior
FROM Presupuestos;



-- Consultas básicas - Cambio de nombres a las columnas

SELECT idProducto AS 'Producto #', nombre 'Nombre', descripcion 'Descripción'
FROM Productos;


-- Consultas básicas - Uso de constantes

SELECT idProducto AS 'Producto #', 'ID:', nombre 'Nombre', descripcion 'Descripción'
FROM Productos;


-- Consultas básicas - CASE

DROP TABLE IF EXISTS `Cargos` ;

CREATE TABLE IF NOT EXISTS `Cargos` (
  `idCargo` INT NOT NULL,
  `cargo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCargo`)
) ENGINE = InnoDB;

INSERT INTO `Cargos` VALUES(1, 'Titular');
INSERT INTO `Cargos` VALUES(2, 'Asociado');
INSERT INTO `Cargos` VALUES(3, 'Adjunto');
INSERT INTO `Cargos` VALUES(4, 'JTP');
INSERT INTO `Cargos` VALUES(5, 'ADG');
INSERT INTO `Cargos` VALUES(6, 'Externo');

SELECT * FROM Cargos;

SELECT idCargo, 
	CASE cargo
		WHEN 'Titular' THEN 'Profesor Titular'
        WHEN 'Asociado' THEN 'Profesor Asociado'
		WHEN 'Adjunto' THEN 'Profesor Adjunto'
		WHEN 'JTP' THEN 'Jefe de Trabajos Prácticos'
        WHEN 'ADG' THEN 'Auxiliar Docente Graduado'
        ELSE 'Personal Externo'
	END AS 'Cargo'
FROM Cargos;

SELECT idTrabajo, titulo,
	CASE 
		WHEN duracion > 0 AND duracion < 6 THEN 'Menos de 6 meses'
        WHEN duracion >= 6 AND duracion < 8 THEN 'Entre 6 y 8 meses'
        ELSE 'Más de 8 meses'
	END AS 'Duración'
FROM Trabajos;


-- Consultas básicas - COALESCE

SELECT anioActual, anioAnterior
FROM Presupuestos;

SELECT anioActual, anioAnterior, COALESCE(anioActual, anioAnterior) AS ‘Col1’
FROM Presupuestos;


-- Consultas básicas - IFNULL

SELECT idTrabajo, titulo, IFNULL(fechaFinalizacion, '-') AS 'Finalización'
FROM Trabajos;


-- Consultas básicas - NULLIF
-- Ejecutar las siguientes 3 consultas juntas para poder comparar

SELECT anioActual, anioAnterior, 
	COALESCE(anioActual, anioAnterior) AS ‘Col1’, 
    NULLIF(COALESCE(anioActual, anioAnterior), 0.00) AS ‘Col2’
FROM Presupuestos;

SELECT AVG(COALESCE(anioActual, anioAnterior)) AS ‘Promedio’
FROM Presupuestos;
-- Divide en 10 filas (tiene en cuenta las que valen 0)

SELECT AVG(NULLIF(COALESCE(anioActual, anioAnterior), 0.00)) AS ‘Promedio’
FROM Presupuestos;
-- Divide en 6 filas (no tiene en cuenta las que valen 0)

-- AVG() no cuenta las filas que valen NULL. 
-- Si no se emplea NULLIF, AVG() divide por el total de filas
-- Si se emplea NULLIF, AVG() divide por la cantidad de filas que no sean NULL


-- Consultas básicas - Modificación de datos

SELECT * FROM Presupuestos;

UPDATE Presupuestos
SET anioActual = 105000 WHERE departamento = 1;

SELECT * FROM Presupuestos;


-- Consultas básicas - Borrado de datos

SELECT * FROM Presupuestos;

DELETE FROM Presupuestos
WHERE departamento = 8;

SELECT * FROM Presupuestos;

TRUNCATE Presupuestos;

SELECT * FROM Presupuestos;

DROP TABLE IF EXISTS Presupuestos;


-- Múltiples tablas - INNER join

DROP TABLE IF EXISTS `Marcas`;

CREATE TABLE IF NOT EXISTS `Marcas`(
    `idMarca` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(250) NOT NULL ,
    PRIMARY KEY(`idMarca`)
);

INSERT INTO `Marcas` (`nombre`) VALUES ('Samsung'), ('Nokia'), ('Canon');

SELECT * FROM `Marcas`;

DROP TABLE IF EXISTS `Categorias`;

CREATE TABLE IF NOT EXISTS `Categorias`(
    `idCategoria` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(250) NOT NULL ,
    PRIMARY KEY(`idCategoria`)
);

INSERT INTO `Categorias` (`nombre`) VALUES ('Televisión'), ('Celulares'), ('Camaras');

SELECT * FROM Categorias;

DROP TABLE IF EXISTS `Productos`;

CREATE TABLE IF NOT EXISTS `Productos`(
    `idProducto` INT UNSIGNED NOT NULL,
    `nombre` VARCHAR(250) NOT NULL,
    `idMarca` INT UNSIGNED NOT NULL,
    `idCategoria` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`idProducto`),
    INDEX `IX_CATEGORIA`(`idCategoria` ASC),
    INDEX `IX_MARCA`(`idMarca` ASC),
    CONSTRAINT `FK_IDMarca` FOREIGN KEY(`idMarca`) REFERENCES `Marcas`(`idMarca`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `FK_IDCategoria` FOREIGN KEY(`idCategoria`) REFERENCES `Categorias`(`idCategoria`) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO `Productos` VALUES (1, 'Prime', 1, 1); 
INSERT INTO `Productos` VALUES (2, 'Octoview', 1, 1); 
INSERT INTO `Productos` VALUES (3, 'Dreamer', 1, 1); 
INSERT INTO `Productos` VALUES (4, 'Bravia', 1, 1); 
INSERT INTO `Productos` VALUES (5, 'Proton', 1, 1); 

SELECT * FROM Productos;

DROP TABLE IF EXISTS `Atributos`;

CREATE TABLE IF NOT EXISTS `Atributos`(
    `idAtributo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL ,
    PRIMARY KEY(`idAtributo`)
);

INSERT INTO `Atributos` (`nombre`) VALUES ('Pantalla'); -- 1
INSERT INTO `Atributos` (`nombre`) VALUES ('Resolución'); -- 2
INSERT INTO `Atributos` (`nombre`) VALUES ('Puertos'); -- 3
INSERT INTO `Atributos` (`nombre`) VALUES ('Parlantes'); -- 4

SELECT * FROM Atributos;

DROP TABLE IF EXISTS `AtributosDelProducto`;

CREATE TABLE IF NOT EXISTS `AtributosDelProducto`(
    `idProducto` INT UNSIGNED NOT NULL,
    `idAtributo` INT UNSIGNED NOT NULL,
    `valor` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`idProducto`, `idAtributo`),
    INDEX `IX_Producto`(`idProducto` ASC),
    INDEX `IX_Atributo`(`idAtributo` ASC),
    CONSTRAINT `FK_IDProducto` FOREIGN KEY(`idProducto`) REFERENCES `Productos`(`idProducto`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `FK_IDAtributo` FOREIGN KEY(`idAtributo`) REFERENCES `Atributos`(`idAtributo`) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 1, '50 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 2, '2048 x 1152 pixels');

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 1, '40 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 2, '1920 x 1080 pixels');

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 1, '30 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 2, '1600 x 900 pixels');

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 1, '25 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 2, '1366 x 768 pixels');

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 1, '20 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 2, '1280 x 720 pixels');

SELECT * FROM AtributosDelProducto;

-- Producto, marca y categoría
SELECT idProducto, Productos.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría'
FROM Productos JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria
JOIN Marcas
ON Productos.idMarca = Marcas.idMarca;

-- o también 

-- Producto, marca y categoría
SELECT idProducto, Productos.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría'
FROM Productos JOIN Marcas
ON Productos.idMarca = Marcas.idMarca
JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria;

-- o también

-- Producto, marca y categoría
SELECT idProducto, Productos.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría'
FROM Marcas JOIN Productos
ON Marcas.idMarca = Productos.idMarca
JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria;

-- Producto, marca, categoría y atributos
SELECT Productos.idProducto, Productos.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', Atributos.nombre AS 'Atributo', valor AS 'Valor'
FROM Productos JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria
JOIN Marcas
ON Productos.idMarca = Marcas.idMarca
JOIN AtributosDelProducto
ON Productos.idProducto = AtributosDelProducto.idProducto
JOIN Atributos
ON AtributosDelProducto.idAtributo = Atributos.idAtributo
ORDER BY 1;


-- Múltiples tablas – OUTER JOIN

SELECT idProducto, Productos.nombre, Marcas.nombre AS 'Marca'
FROM Productos JOIN Marcas
ON Productos.idMarca = Marcas.idMarca;
-- No muestra las marcas que no tienen un producto (Nokia y Canon)

SELECT idProducto, Productos.nombre, Marcas.nombre AS 'Marca'
FROM Productos RIGHT JOIN Marcas
ON Productos.idMarca = Marcas.idMarca;
-- Sí muestra las marcas que no tienen un producto

-- o también

SELECT idProducto, Productos.nombre, Marcas.nombre AS 'Marca'
FROM Marcas LEFT JOIN Productos
ON Productos.idMarca = Marcas.idMarca;
-- Sí muestra las marcas que no tienen un producto


-- Múltiples tablas – CROSS JOIN

SELECT idProducto, Productos.nombre, Marcas.idMarca
FROM Productos CROSS JOIN Marcas; -- 5 x 3 = 15 filas


-- Múltiples tablas - Creación de columna JSON

DROP TABLE IF EXISTS `ProductosJSON`;

CREATE TABLE IF NOT EXISTS `ProductosJSON`(
    `idProducto` INT UNSIGNED NOT NULL,
    `nombre` VARCHAR(250) NOT NULL,
    `idMarca` INT UNSIGNED NOT NULL,
    `idCategoria` INT UNSIGNED NOT NULL,
    `atributos` JSON NOT NULL,
    PRIMARY KEY(`idProducto`),
    INDEX `IX_CATEGORIA`(`idCategoria` ASC),
    INDEX `IX_MARCA`(`idMarca` ASC),
    CONSTRAINT `FK_IDMarca1` FOREIGN KEY(`idMarca`) REFERENCES `Marcas`(`idMarca`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `FK_IDCategoria1` FOREIGN KEY(`idCategoria`) REFERENCES `Categorias`(`idCategoria`) ON DELETE RESTRICT ON UPDATE CASCADE
);


-- Múltiples tablas - Inserción en columna JSON

-- Armado manual de objeto JSON:

INSERT INTO `ProductosJSON` VALUES (1, 'Prime', 1, 1, '{"Pantalla": "50 pulgadas", "Resolución": "2048 x 1152 pixels"}'); 
INSERT INTO `ProductosJSON` VALUES (2, 'Octoview', 1, 1, '{"Pantalla": "40 pulgadas", "Resolución": "1920 x 1080 pixels"}');
INSERT INTO `ProductosJSON` VALUES (3, 'Dreamer', '1', '1', '{"Pantalla": "30 pulgadas", "Resolución": "1600 x 900 pixles"}');
INSERT INTO `ProductosJSON` VALUES (4, 'Bravia', '1', '1', '{"Pantalla": "25 pulgadas", "Resolución": "1366 x 768 pixels"}');
INSERT INTO `ProductosJSON` VALUES (5, 'Proton', '1', '1', '{"Pantalla": "20 pulgadas", "Resolución": "1280 x 720 pixels"}');

SELECT * FROM ProductosJSON;

-- En lugar de armar el objeto JSON manualmente, se puede usar la función JSON_OBJECT()
-- JSON_OBJECT(): acepta una lista de pares clave:valor y devuelve un objeto JSON
-- Ocurre un error si alguna clave es NULL o la cantidad de argumentos es impar
-- SELECT JSON_OBJECT('id', 87, 'name', 'carrot') devuelve {"id":87, "name":"carrot'}
-- SELECT JSON_OBJECT() devuelve {}
-- SELECT JSON_OBJECT(NULL, 87) devuelve error
-- SELECT JSON_OBJECT(87) devuelve error

DELETE FROM `ProductosJSON`;

INSERT INTO `ProductosJSON` VALUES(1, 'Prime', 1, 1, JSON_OBJECT(
		"Pantalla", "50 pulgadas" ,
		"Resolución", "2048 x 1152 pixels"
	)
);

INSERT INTO `ProductosJSON` VALUES(2, 'Octoview', 1, 1, JSON_OBJECT(
		"Pantalla", "40 pulgadas" ,
		"Resolución", "1920 x 1080 pixels"
	)
);

INSERT INTO `ProductosJSON` VALUES(3, 'Dreamer', 1, 1, JSON_OBJECT(
		"Pantalla", "30 pulgadas" ,
        "Resolución", "0016 x 009 pixels" , 
		"Resolución", "1600 x 900 pixels" -- si la clave ya estaba se pisa su valor        
	)
);

INSERT INTO `ProductosJSON` VALUES(4, 'Bravia', 1, 1, JSON_OBJECT(
		"Pantalla", "25 pulgadas" ,
		"Resolución", "1366 x 768 pixels"
	)
);

INSERT INTO `ProductosJSON` VALUES(5, 'Proton', 1, 1, JSON_OBJECT(
		"Pantalla", "20 pulgadas" ,
		"Resolución", "1280 x 720 pixels"
	)
);

SELECT * FROM ProductosJSON;

-- JSON_MERGE_PRESERVE(): toma varios objetos JSON y devuelve un único objeto JSON con la combinación de los mismos
-- Devuelve un error si alguno de los objetos JSON no es válido
-- Devuelve NULL si alguno de los objetos JSON es NULL
-- SELECT JSON_MERGE_PRESERVE('[1, 2]', '[true, false]') devuelve [1, 2, true, false] (los 2 arrays se combinan en uno solo)
-- SELECT JSON_MERGE_PRESERVE('{"name": "x"}', '{"id": 47}') devuelve {"id":47, "name":"x"} (los 2 objetos se combinan en uno solo)
-- SELECT JSON_MERGE_PRESERVE('1', true) devuelve [1, true] (los valores individuales se transforman en arrays y se combinan)
-- El ejemplo anterior es equivalente a SELECT JSON_MERGE_PRESERVE('[1]', '[true]')
-- SELECT JSON_MERGE_PRESERVE('[1, 2]', '{"id": 47}') devuelve [1, 2, {"id":47}] (un array y un objeto se combinan transformando el objeto en array y luego combinando los 2 arrays)
-- El ejemplo anterior es equivalente a SELECT JSON_MERGE_PRESERVE('[1, 2]', '[{"id": 47}]');
-- SELECT JSON_MERGE_PRESERVE('{ "a": 1, "b": 2 }', '{ "a": 3, "c": 4 }') devuelve {"a":[1, 3], "b":2, "c":4} (clave repetida)
-- SELECT JSON_MERGE_PRESERVE('{ "a": 1, "b": 2 }','{ "a": 3, "c": 4 }', '{ "a": 5, "d": 6 }') devuelve {"a":[1, 3, 5], "b":2, "c":4, "d":6}

DELETE FROM `ProductosJSON`;

INSERT INTO `ProductosJSON` VALUES (1, 'Prime', 1, 1, JSON_MERGE_PRESERVE(
		'{"Pantalla": "50 pulgadas"}',
		'{"Resolución": "2048 x 1152 pixels"}'
	)
);

INSERT INTO `ProductosJSON` VALUES (2, 'Octoview', 1, 1, JSON_MERGE_PRESERVE(
		'{"Pantalla": "40 pulgadas"}',
		'{"Resolución": "1920 x 1080 pixels"}'
	)
);

INSERT INTO `ProductosJSON` VALUES (3, 'Dreamer', 1, 1, JSON_MERGE_PRESERVE(
		'{"Pantalla": "30 pulgadas"}',
		'{"Resolución": "1600 x 900 pixels"}'
	)
);

INSERT INTO `ProductosJSON` VALUES (4, 'Bravia', 1, 1, JSON_MERGE_PRESERVE(
		'{"Pantalla": "25 pulgadas"}',
		'{"Resolución": "1366 x 768 pixels"}'
	)
);

INSERT INTO `ProductosJSON` VALUES (5, 'Proton', 1, 1, JSON_MERGE_PRESERVE(
		JSON_OBJECT("Pantalla" , "20 pulgadas"),
		JSON_OBJECT("Resolución" , "1280 x 720 pixels")
	)
);
-- Aquí la función JSON_OBJECT arma los objetos JSON

SELECT * FROM ProductosJSON;

SELECT ProductosJSON.idProducto, ProductosJSON.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', atributos AS 'Atributos'
FROM ProductosJSON JOIN Categorias
ON ProductosJSON.idCategoria = Categorias.idCategoria
JOIN Marcas
ON ProductosJSON.idMarca = Marcas.idMarca;


-- Múltiples tablas - Consulta en columna JSON

SELECT `idProducto`, `nombre`, JSON_EXTRACT(`atributos` , '$.Pantalla') AS 'Pantalla'
FROM `ProductosJSON`;
-- o también
SELECT `idProducto`, `nombre`, `atributos` -> '$.Pantalla' AS 'Pantalla'
FROM `ProductosJSON`;

-- Para sacar las comillas:
SELECT `idProducto`, `nombre`, JSON_UNQUOTE(JSON_EXTRACT(`atributos` , '$.Pantalla')) AS 'Pantalla'
FROM `ProductosJSON`;
-- o también
SELECT `idProducto`, `nombre`, `atributos` ->> '$.Pantalla' AS 'Pantalla'
FROM `ProductosJSON`;

SELECT `idProducto`, `nombre`, JSON_UNQUOTE(JSON_EXTRACT(`atributos` , '$.Pantalla')) AS 'Pantalla'
FROM `ProductosJSON`
WHERE JSON_EXTRACT(`atributos` , '$.Pantalla') = "50 pulgadas";
-- o también
SELECT `idProducto`, `nombre`, `atributos` ->> '$.Pantalla' AS 'Pantalla'
FROM `ProductosJSON`
WHERE `atributos` -> '$.Pantalla' = "50 pulgadas";


-- Múltiples tablas - Modificación de una columna JSON

-- JSON_REPLACE(): modifica el valor de la clave sólo si existe la misma
-- Devuelve NULL si alguno de sus argumentos es NULL.
-- Se produce un error si el objeto JSON es inválido, si el camino es inválido o contiene * o **
-- Los pares clave:valor se evalúan de izquierda a derecha
-- SET @j = '{ "a": 1, "b": [2, 3]}';
-- SELECT JSON_REPLACE(@j, '$.a', 10, '$.c', '[true, false]'); devuelve {"a":10, "b":[2, 3]}

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Tipo_Monitor' AS 'Tipo de Monitor' -- no existe esta clave
FROM `ProductosJSON`
WHERE `idProducto` = 5;

UPDATE `ProductosJSON`
SET `atributos` = JSON_REPLACE(`atributos`, '$.Tipo_Monitor', 'LCD') -- no existe esta clave
WHERE `idProducto` = 5;

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Pantalla' AS 'Pantalla' -- sí existe esta clave
FROM `ProductosJSON`
WHERE `idProducto` = 5;

UPDATE `ProductosJSON`
SET `atributos` = JSON_REPLACE(`atributos`, '$.Pantalla', '200 pulgadas') -- sí existe esta clave
WHERE `idProducto` = 5;

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Pantalla' AS 'Pantalla'
FROM `ProductosJSON`
WHERE `idProducto` = 5;

-- JSON_INSERT(): agrega la clave y su valor sólo si la misma no existe
-- Devuelve NULL si alguno de sus argumentos es NULL.
-- Se produce un error si el objeto JSON es inválido, si el camino es inválido o contiene * o **
-- Los pares clave:valor se evalúan de izquierda a derecha
-- SET @j = '{ "a": 1, "b": [2, 3]}';
-- SELECT JSON_INSERT(@j, '$.a', 10, '$.c', '[true, false]'); -- devuelve {"a":1, "b":[2, 3], "c":[true, false]}

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Tipo_Monitor' AS 'Tipo de Monitor' -- no existe esta clave
FROM `ProductosJSON`
WHERE `idProducto` = 5;

UPDATE `ProductosJSON`
SET `atributos` = JSON_INSERT(`atributos`, '$.Tipo_Monitor', 'LCD') -- no existe esta clave
WHERE `idProducto` = 5;

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Tipo_Monitor' AS 'Tipo de Monitor'
FROM `ProductosJSON`
WHERE `idProducto` = 5;

UPDATE `ProductosJSON`
SET `atributos` = JSON_INSERT(`atributos`, '$.Tipo_Monitor', 'LCD1') -- ya existe esta clave
WHERE `idProducto` = 5;

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Tipo_Monitor' AS 'Tipo de Monitor'
FROM `ProductosJSON`
WHERE `idProducto` = 5;

-- JSON_SET(): si no existe la clave la agrega, y si existe la reemplaza
-- Devuelve NULL si alguno de sus argumentos es NULL o si el camino especificado no encuentra un objeto
-- Se produce un error si el objeto JSON es inválido, si el camino es inválido o contiene * o **
-- Los pares clave:valor se evalúan de izquierda a derecha
-- SET @j = '{ "a": 1, "b": [2, 3]}';
-- SELECT JSON_SET(@j, '$.a', 10, '$.c', '[true, false]'); -- devuelve {"a":10, "b":[2, 3], "c":[true, false]}

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Pantalla' AS 'Pantalla' -- sí existe la clave
FROM `ProductosJSON`
WHERE `idProducto` = 5;

UPDATE `ProductosJSON`
SET `atributos` = JSON_SET(`atributos` , '$.Pantalla', '20 pulgadas') -- como sí existe la clave, la reemplaza
WHERE `idProducto` = 5;

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Pantalla' AS 'Pantalla'
FROM `ProductosJSON`
WHERE `idProducto` = 5;

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Tipo_Monitor1' AS 'Tipo_Monitor1' -- no existe la clave
FROM `ProductosJSON`
WHERE `idProducto` = 5;

UPDATE `ProductosJSON`
SET `atributos` = JSON_SET(`atributos` , '$.Tipo_Monitor1', 'LCD1') -- como no existe la clave, la agrega
WHERE `idProducto` = 5;

SELECT `idProducto`, `nombre`, `atributos` ->> '$.Tipo_Monitor1' AS 'Tipo_Monitor1' -- no existe la clave
FROM `ProductosJSON`
WHERE `idProducto` = 5;


-- Múltiples tablas - Borrado en columna JSON

-- JSON_REMOVE(): borra datos de un objeto JSON
-- Devuelve NULL si alguno de sus argumentos es NULL
-- Se produce un error si el objeto JSON es inválido, si el camino es inválido o contiene * o **
-- Los pares clave:valor se evalúan de izquierda a derecha
-- SET @j = '["a", ["b", "c"], "d"]';
-- SELECT JSON_REMOVE(@j, '$[1]'); -- devuelve ["a", "d"] (se borra el segundo elemento)

UPDATE `ProductosJSON`
SET `atributos` = JSON_REMOVE(`atributos` , '$.Tipo_Monitor', '$.Tipo_Monitor1') -- borra Tipo_Monitor y Tipo_Monitor1
WHERE `idProducto` = 5;

SELECT `idProducto`, `nombre`, `atributos`
FROM `ProductosJSON`
WHERE `idProducto` = 5;


-- Para borrar filas según una columna JSON

SELECT `idProducto`, `nombre`, `atributos`
FROM `ProductosJSON`
WHERE JSON_EXTRACT(`atributos` , '$.Pantalla') = "20 pulgadas";

DELETE FROM `ProductosJSON`
WHERE JSON_EXTRACT(`atributos` , '$.Pantalla') = "20 pulgadas";

SELECT `idProducto`, `nombre`, `atributos`
FROM `ProductosJSON`
WHERE JSON_EXTRACT(`atributos` , '$.Pantalla') = "20 pulgadas";

INSERT INTO `ProductosJSON` VALUES (5, 'Proton', 1, 1, JSON_MERGE_PRESERVE(
		JSON_OBJECT("Pantalla" , "20 pulgadas"),
		JSON_OBJECT("Resolución" , "1280 x 720 pixels")
	)
);

-- Múltiples tablas – Uso de función JSON_TABLE():

-- Dado el siguiente objeto JSON:
SET @j = '[{"a":"3"},{"a":2},{"b":1},{"a":0},{"a":[1,2]}]';

-- Se quiere obtener una tabla con 2 columnas, una para la clave "a" y otra para la clave "b"
SELECT * FROM JSON_TABLE(@j, '$[*]' COLUMNS(
		ColA VARCHAR(10) PATH '$.a',
		ColB VARCHAR(10) PATH '$.b')
) AS TablaJSON;
-- El primer argumento es el objeto JSON que se quiere convertir en tabla
-- El segundo argumento es el camino desde donde se realizará la búsqueda de los datos: 
-- como el objeto JSON es un vector, y el camino siempre empieza con $, el mismo se especifica como $[*]
-- Luego de COLUMNS vienen las columnas que se quieren obtener:
-- para cada una se especifica su nombre (ColA y ColB), su tipo y finalmente luego de la cláusula PATH su camino relativo al especificado antes ($.a y $.b)
-- Como JSON_TABLE() devuelve una tabla, a la misma se le debe asignar un nombre (TablaJSON en este caso)

-- Resultado: 
-- Filas 1, 2 y 4 (correspondientes a los elementos 1, 2 y 4 del vector): 
-- 	ColA vale 3,  2 y 0 (hay un valor para $.a), y ColB vale NULL (no hay un valor para $.b).
-- Fila 3: ColA vale NULL (no hay un valor para $.a), y ColB vale 1 (hay un valor para $.b).
-- Fila 5: ColB vale NULL (no hay un valor para $.b). ColA vale NULL (aunque sí hay un valor para $.a, el mismo es un vector)

-- La consulta anterior es equivalente a la siguiente:

SELECT * FROM JSON_TABLE(@j, '$[*]' COLUMNS(
		ColA VARCHAR(10) PATH '$.a' NULL ON EMPTY NULL ON ERROR,
		ColB VARCHAR(10) PATH '$.b' NULL ON EMPTY NULL ON ERROR)
) AS TablaJSON;
-- Que se muestre NULL en los casos que no se encuentre un valor o que se produzca un error
-- es equivalente a haber especificado NULL ON EMPTY NULL ON ERROR
-- NULL ON EMPTY y NULL ON ERROR es el comportamiento predeterminado, por lo que pueden omitirse estas cláusulas
-- Se pueden especificar estas 2 opciones en cualquier orden, o una sola.

-- Para mostrar un valor distinto a NULL cuando no se encuentre un valor para un camino especificado:

SELECT * FROM JSON_TABLE(@j, '$[*]' COLUMNS(
		ColA VARCHAR(10) PATH '$.a' DEFAULT '111' ON EMPTY,
		ColB VARCHAR(10) PATH '$.b' DEFAULT '111' ON EMPTY)
) AS TablaJSON;


-- Para mostrar un valor distinto a NULL cuando se genere un error para un camino especificado:

SELECT * FROM JSON_TABLE(@j, '$[*]' COLUMNS(
		ColA VARCHAR(10) PATH '$.a' DEFAULT '111' ON EMPTY DEFAULT '222' ON ERROR,
		ColB VARCHAR(10) PATH '$.b' DEFAULT '111' ON EMPTY DEFAULT '222' ON ERROR)
) AS TablaJSON;


-- Para generar una columna que cuente la cantidad de filas:

SELECT * FROM JSON_TABLE(@j, '$[*]' COLUMNS(
		FilaNum FOR ORDINALITY,
		ColA VARCHAR(10) PATH '$.a' DEFAULT '111' ON EMPTY DEFAULT '222' ON ERROR,
		ColB VARCHAR(10) PATH '$.b' DEFAULT '111' ON EMPTY DEFAULT '222' ON ERROR)
) AS TablaJSON;
-- La columna FilaNum es de tipo UNSIGNED INT, con un valor inicial de 1 y se va incrementando 
-- Sería equivalente a especificar una columna como AUTO_INCREMENT en una sentencia CREATE TABLE

-- Para distinguir si hay valor o no para el camino especificado:

SELECT * FROM JSON_TABLE(@j, '$[*]' COLUMNS(
		FilaNum FOR ORDINALITY,
		ColA VARCHAR(10) PATH '$.a' DEFAULT '111' ON EMPTY DEFAULT '222' ON ERROR,
		ColB VARCHAR(10) PATH '$.b' DEFAULT '111' ON EMPTY DEFAULT '222' ON ERROR,
        ValorColA INT EXISTS PATH '$.a', -- vale 1 si hay un valor para esa fila, 0 en caso contrario
        ValorColB INT EXISTS PATH '$.b')
) AS TablaJSON;
-- Viendo los valores de las 2 últimas columnas:
-- Para ColA hay valores en las filas 1, 2, 4 y 5, y no en la fila 3
-- Para ColB, sólo hay valor para la fila 3


-- Para mostrar un vector sólo de valores:

SET @j = '[1, 2, 3, 4, 5]';
SELECT * FROM JSON_TABLE(@j, '$[*]' COLUMNS (
	Col INT PATH '$')
) AS TablaJSON;

-- Para referenciar a un elemento de un vector que es valor:

SET @j = '[
	{
		"padre": "Juan", 
        "madre": "María", 
        "hijos": [
			{
				"nombre": "Luis",
				"edad": 12 				
			}, 
			{
				"nombre": "Carlos",
				"edad": 10                 
			}
		], 
        "casamiento": "2003-12-05"
	}, 
    {
		"padre": "Pablo", 
        "madre": "Laura",
        "hijos": [
			{
				"nombre": "Sara",
				"edad": 9
			}, 
            {
				"nombre": "Noé",
				"edad": 3                 
			}, 
            {
				"nombre": "Pedro",
				"edad": 1                 
			}
		]
	}
]';

SELECT * FROM JSON_TABLE(@j, '$[*]' COLUMNS(
		FilaNum FOR ORDINALITY,
		Padre VARCHAR(20) PATH '$.padre',
		Madre VARCHAR(20) PATH '$.madre',
        Casados INT EXISTS PATH '$.casamiento',
			NESTED PATH '$.hijos[*]' COLUMNS (
 				HijoNum FOR ORDINALITY,
 				Nombre VARCHAR(20) PATH '$.nombre',
                Edad INT PATH '$.edad')
		)
) AS TablaJSON;

-- La cláusula NESTED [PATH] “aplana” objetos anidados o vectores en JSON en una sola fila con los valores JSON del objeto “padre” o vector. 
-- Se pueden usar múltiples opciones PATH para múltiples niveles de anidamiento


-- Para especificar el objeto JSON a convertir, también se puede:
-- 	Especificar una función que devuelva un objeto JSON (JSON_OBJECT() por ejemplo)
-- 	Especificar una columna de una tabla

SELECT * FROM ProductosJSON, JSON_TABLE(atributos, '$' COLUMNS (
	Pantalla VARCHAR(50) PATH '$.Pantalla',
    Resolucion VARCHAR(50) PATH '$.Resolución')
) AS TablaJSON;
-- Como la columna "atributos" es de la tabla "ProductosJSON", primero se debe referenciar dicha tabla
-- En la función JSON_TABLE() no se puede especificar ProductosJSON.atributos

-- Para obtener la misma salida que en el diseño relacional:
SELECT Productos.idProducto, Productos.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', Atributos.nombre AS 'Atributo', valor AS 'Valor'
FROM Productos JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria
JOIN Marcas
ON Productos.idMarca = Marcas.idMarca
JOIN AtributosDelProducto
ON Productos.idProducto = AtributosDelProducto.idProducto
JOIN Atributos
ON AtributosDelProducto.idAtributo = Atributos.idAtributo
ORDER BY 1, 5;

SELECT idProducto, ProductosJSON.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', TablaJSON.* 
FROM ProductosJSON JOIN Marcas
ON ProductosJSON.idMarca = Marcas.idMarca
JOIN Categorias
ON ProductosJSON.idCategoria = Categorias.idCategoria,  
JSON_TABLE(atributos, '$' COLUMNS (
	Pantalla VARCHAR(50) PATH '$.Pantalla',
    Resolucion VARCHAR(50) PATH '$.Resolución')
) AS TablaJSON
ORDER BY 1, 5;

-- Salida similar
-- En la salida relacional las columnas son ..., Atributo y Valor
-- En la salida JSON las columnas son ..., Pantalla y Resolucion
-- Se modifican las filas en la tabla ProductosJSON para que haya una clave que se llame Atributo y otra que se llame Valor
-- Los valores de estas claves serán los valores de estos atributos:

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "50 pulgadas"}, {"Atributo": "Resolución", "Valor": "2048 x 1152 pixels"}]'
WHERE idProducto = 1;

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "40 pulgadas"}, {"Atributo": "Resolución", "Valor": "1920 x 1080 pixels"}]'
WHERE idProducto = 2;

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "30 pulgadas"}, {"Atributo": "Resolución", "Valor": "1600 x 900 pixels"}]'
WHERE idProducto = 3;

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "25 pulgadas"}, {"Atributo": "Resolución", "Valor": "1366 x 768 pixels"}]'
WHERE idProducto = 4;

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "20 pulgadas"}, {"Atributo": "Resolución", "Valor": "1280 x 720 pixels"}]'
WHERE idProducto = 5;


SELECT Productos.idProducto, Productos.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', Atributos.nombre AS 'Atributo', valor AS 'Valor'
FROM Productos JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria
JOIN Marcas
ON Productos.idMarca = Marcas.idMarca
JOIN AtributosDelProducto
ON Productos.idProducto = AtributosDelProducto.idProducto
JOIN Atributos
ON AtributosDelProducto.idAtributo = Atributos.idAtributo
ORDER BY 1, 5;

SELECT ProductosJSON.idProducto, ProductosJSON.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', TablaJSON.* 
FROM ProductosJSON JOIN Categorias
ON ProductosJSON.idCategoria = Categorias.idCategoria
JOIN Marcas
ON ProductosJSON.idMarca = Marcas.idMarca,  
JSON_TABLE(atributos, '$[*]' COLUMNS (
	Atributo VARCHAR(50) PATH '$.Atributo',
    Valor VARCHAR(50) PATH '$.Valor')
) AS TablaJSON
ORDER BY 1, 5;

-- Múltiples tablas - JOIN de una tabla con sí misma

DROP TABLE IF EXISTS `AtributosDelProducto`;
DROP TABLE IF EXISTS `Atributos`;

CREATE TABLE IF NOT EXISTS `Atributos`(
    `idAtributo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `idAtributoPadre` INT UNSIGNED NULL,
    PRIMARY KEY(`idAtributo`),
    CONSTRAINT `FK_IDAtributo` FOREIGN KEY(`idAtributoPadre`) REFERENCES `Atributos`(`idAtributo`)
);

INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('Pantalla', NULL); -- 1
INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('Resolución', NULL); -- 2
INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('Puertos', NULL); -- 3
INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('Parlantes', NULL); -- 4
INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('HDMI', 3); -- 5
INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('USB', 3); -- 6
INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('Izquierdo', 4); -- 7
INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('Derecho', 4); -- 8

SELECT idAtributo, nombre, idAtributoPadre
FROM `Atributos`;

SELECT A1.idAtributo, A1.nombre AS 'Nombre', A2.nombre AS 'Nombre del padre'
FROM `Atributos` A1  JOIN `Atributos` A2
ON A1.idAtributoPadre = A2.idAtributo
ORDER BY A1.idAtributo;
-- No muestra los atributos de A1 cuyo valor de idAtributoPadre sea NULL

SELECT A1.idAtributo, A1.nombre AS 'Nombre', A2.nombre AS 'Nombre del padre'
FROM `Atributos` A1  LEFT JOIN `Atributos` A2
ON A1.idAtributoPadre = A2.idAtributo
ORDER BY A1.idAtributo;
-- Muestra todos los atributos

SELECT A1.idAtributo, A1.nombre AS 'Nombre', A1.idAtributoPadre, A2.nombre AS 'Nombre del padre'
FROM `Atributos` A1  LEFT JOIN `Atributos` A2
ON A1.idAtributoPadre = A2.idAtributo
ORDER BY COALESCE(A1.idAtributoPadre, A1.idAtributo), A1.idAtributoPadre, A1.nombre;
-- Muestra todos los atributos ordenados con respecto a sus padres


-- Múltiples tablas - Atributo con atributos con diseño relacional

CREATE TABLE IF NOT EXISTS `AtributosDelProducto`(
    `idProducto` INT UNSIGNED NOT NULL,
    `idAtributo` INT UNSIGNED NOT NULL,
    `valor` VARCHAR(50) NULL, -- ahora puede ser NULL
    PRIMARY KEY(`idProducto`, `idAtributo`),
    INDEX `IX_Producto`(`idProducto` ASC),
    INDEX `IX_Atributo`(`idAtributo` ASC),
    CONSTRAINT `FK_IDProducto` FOREIGN KEY(`idProducto`) REFERENCES `Productos`(`idProducto`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `FK_IDAtributo1` FOREIGN KEY(`idAtributo`) REFERENCES `Atributos`(`idAtributo`) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- Mostrar el diagrama

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 1, '50 pulgadas'); -- pantalla
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 2, '2048 x 1152 pixels'); -- resolución
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 3, NULL); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 5, '1'); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 6, '3'); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 4, NULL); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 7, '10 watt'); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 8, '10 watt'); -- derecho

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 1, '40 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 2, '1920 x 1080 pixels');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 3, NULL); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 5, '1'); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 6, '2'); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 4, NULL); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 7, '10 watt'); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 8, '10 watt'); -- derecho

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 1, '30 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 2, '1600 x 900 pixels');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 3, NULL); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 5, '1'); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 6, '1'); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 4, NULL); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 7, '10 watt'); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 8, '10 watt'); -- derecho

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 1, '25 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 2, '1366 x 768 pixels');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 3, NULL); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 5, '1'); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 6, '0'); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 4, NULL); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 7, '5 watt'); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 8, '5 watt'); -- derecho

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 1, '20 pulgadas');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 2, '1280 x 720 pixels');
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 3, NULL); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 5, '0'); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 6, '0'); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 4, NULL); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 7, '5 watt'); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 8, '5 watt'); -- derecho

SELECT Productos.idProducto, Productos.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', A.nombre AS 'Atributo', valor AS 'Valor'
FROM Productos JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria
JOIN Marcas
ON Productos.idMarca = Marcas.idMarca
JOIN AtributosDelProducto AS ADP
ON Productos.idProducto = ADP.idProducto
JOIN Atributos AS A
ON ADP.idAtributo = A.idAtributo
ORDER BY Productos.idProducto, COALESCE(A.idAtributoPadre, A.idAtributo), A.idAtributoPadre, A.nombre;

-- Múltiples tablas - Atributo con atributos con diseño JSON

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "50 pulgadas", "idAtributo": "1", "idAtributoPadre": null}, 
				  {"Atributo": "Resolución", "Valor": "2048 x 1152 pixels", "idAtributo": 2, "idAtributoPadre": null},
				  {"Atributo": "Puertos", "Valor": null, "idAtributo": 3, "idAtributoPadre": null},
                  {"Atributo": "HDMI", "Valor": "1", "idAtributo": 5, "idAtributoPadre": 3},
                  {"Atributo": "USB", "Valor": "3", "idAtributo": 6, "idAtributoPadre": 3},
                  {"Atributo": "Parlantes", "Valor": null, "idAtributo": 4, "idAtributoPadre": null},
                  {"Atributo": "Izquierdo", "Valor": "10 watt", "idAtributo": 7, "idAtributoPadre": 4},
                  {"Atributo": "Derecho", "Valor": "10 watt", "idAtributo": 8, "idAtributoPadre": 4}
				 ]'
WHERE idProducto = 1;

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "40 pulgadas", "idAtributo": 1, "idAtributoPadre": null}, 
				  {"Atributo": "Resolución", "Valor": "1920 x 1080 pixels", "idAtributo": 2, "idAtributoPadre": null},
				  {"Atributo": "Puertos", "Valor": null, "idAtributo": 3, "idAtributoPadre": null},
   				  {"Atributo": "HDMI", "Valor": "1", "idAtributo": 5, "idAtributoPadre": 3},
                  {"Atributo": "USB", "Valor": "2", "idAtributo": 6, "idAtributoPadre": 3},
				  {"Atributo": "Parlantes", "Valor": null, "idAtributo": 4, "idAtributoPadre": null},
				  {"Atributo": "Izquierdo", "Valor": "10 watt", "idAtributo": 7, "idAtributoPadre": 4},
                  {"Atributo": "Derecho", "Valor": "10 watt", "idAtributo": 8, "idAtributoPadre": 4}
				 ]'
WHERE idProducto = 2;

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "30 pulgadas", "idAtributo": 1, "idAtributoPadre": null}, 
				  {"Atributo": "Resolución", "Valor": "1600 x 900 pixels", "idAtributo": 2, "idAtributoPadre": null},
				  {"Atributo": "Puertos", "Valor": null, "idAtributo": 3, "idAtributoPadre": null},
   				  {"Atributo": "HDMI", "Valor": "1", "idAtributo": 5, "idAtributoPadre": 3},
                  {"Atributo": "USB", "Valor": "1", "idAtributo": 6, "idAtributoPadre": 3},
				  {"Atributo": "Parlantes", "Valor": null, "idAtributo": 4, "idAtributoPadre": null},
				  {"Atributo": "Izquierdo", "Valor": "10 watt", "idAtributo": 7, "idAtributoPadre": 4},
                  {"Atributo": "Derecho", "Valor": "10 watt", "idAtributo": 8, "idAtributoPadre": 4}
				 ]'
WHERE idProducto = 3;

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "25 pulgadas", "idAtributo": 1, "idAtributoPadre": null}, 
				  {"Atributo": "Resolución", "Valor": "1366 x 768 pixels", "idAtributo": 2, "idAtributoPadre": null},
				  {"Atributo": "Puertos", "Valor": null, "idAtributo": 3, "idAtributoPadre": null},
   				  {"Atributo": "HDMI", "Valor": "1", "idAtributo": 5, "idAtributoPadre": 3},
                  {"Atributo": "USB", "Valor": "0", "idAtributo": 6, "idAtributoPadre": 3},
				  {"Atributo": "Parlantes", "Valor": null, "idAtributo": 4, "idAtributoPadre": null},
				  {"Atributo": "Izquierdo", "Valor": "5 watt", "idAtributo": 7, "idAtributoPadre": 4},
                  {"Atributo": "Derecho", "Valor": "5 watt", "idAtributo": 8, "idAtributoPadre": 4}
				 ]'
WHERE idProducto = 4;

UPDATE ProductosJSON
SET atributos = '[{"Atributo": "Pantalla", "Valor": "20 pulgadas", "idAtributo": 1, "idAtributoPadre": null}, 
				  {"Atributo": "Resolución", "Valor": "1280 x 720 pixels", "idAtributo": 2, "idAtributoPadre": null},
				  {"Atributo": "Puertos", "Valor": null, "idAtributo": 3, "idAtributoPadre": null},
   				  {"Atributo": "HDMI", "Valor": "0", "idAtributo": 5, "idAtributoPadre": 3},
                  {"Atributo": "USB", "Valor": "0", "idAtributo": 6, "idAtributoPadre": 3},
				  {"Atributo": "Parlantes", "Valor": null, "idAtributo": 4, "idAtributoPadre": null},
				  {"Atributo": "Izquierdo", "Valor": "5 watt", "idAtributo": 7, "idAtributoPadre": 4},
                  {"Atributo": "Derecho", "Valor": "5 watt", "idAtributo": 8, "idAtributoPadre": 4}
				 ]'
WHERE idProducto = 5;

SELECT ProductosJSON.idProducto, ProductosJSON.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', TablaJSON.Atributo, 
CASE TablaJSON.Valor
	WHEN 'null' THEN NULL
    ELSE TablaJSON.Valor
END AS 'Valor'
FROM ProductosJSON JOIN Categorias
ON ProductosJSON.idCategoria = Categorias.idCategoria
JOIN Marcas
ON ProductosJSON.idMarca = Marcas.idMarca,  
JSON_TABLE(atributos, '$[*]' COLUMNS (
	Atributo VARCHAR(50) PATH '$.Atributo',
    Valor VARCHAR(50) PATH '$.Valor',
    idAtributo INT PATH '$.idAtributo',
    idAtributoPadre INT PATH '$.idAtributoPadre')
) AS TablaJSON
ORDER BY ProductosJSON.idProducto, COALESCE(TablaJSON.idAtributoPadre, TablaJSON.idAtributo), TablaJSON.idAtributoPadre, TablaJSON.Atributo;


-- Múltiples tablas - Atributo con varios valores con ambos diseños

SELECT * FROM `Atributos`;
INSERT INTO `Atributos` (`nombre`, `idAtributoPadre`) VALUES ('Red', NULL); -- 9

DROP TABLE IF EXISTS `AtributosDelProducto`;

CREATE TABLE IF NOT EXISTS `AtributosDelProducto`(
    `idProducto` INT UNSIGNED NOT NULL,
    `idAtributo` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`idProducto`, `idAtributo`),
    INDEX `IX_Producto`(`idProducto` ASC),
    INDEX `IX_Atributo`(`idAtributo` ASC),
    CONSTRAINT `FK_IDProducto` FOREIGN KEY(`idProducto`) REFERENCES `Productos`(`idProducto`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `FK_IDAtributo1` FOREIGN KEY(`idAtributo`) REFERENCES `Atributos`(`idAtributo`) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Valores`;

CREATE TABLE IF NOT EXISTS `Valores`(
    `idValor` INT UNSIGNED AUTO_INCREMENT NOT NULL,
    `idProducto` INT UNSIGNED NOT NULL,
    `idAtributo` INT UNSIGNED NOT NULL,
    `valor` VARCHAR(50) NULL, -- puede ser NULL
    PRIMARY KEY(`idValor`),
    INDEX `IX_Producto`(`idProducto` ASC),
    INDEX `IX_Atributo`(`idAtributo` ASC),
    UNIQUE INDEX `IX_ProductoAtributo`(`idProducto`, `idAtributo`, `valor`),
    CONSTRAINT `FK_IDProducto_IDAtributo` FOREIGN KEY(`idProducto`, `idAtributo`) REFERENCES `AtributosDelProducto`(`idProducto`, `idAtributo`) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- Mostrar diseño

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 1); -- pantalla
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 2); -- resolución
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 3); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 5); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 6); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 4); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 7); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 8); -- derecho
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (1, 9); -- red

INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 1, '50 pulgadas'); -- pantalla
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 2, '2048 x 1152 pixels'); -- resolución
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 3, NULL); -- puertos
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 5, '1'); -- HDMI
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 6, '3'); -- USB
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 4, NULL); -- parlantes
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 7, '10 watt'); -- izquierdo
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 8, '10 watt'); -- derecho
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 9, 'GSM'); -- red
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 9, 'CDMA'); -- red
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 9, 'HSPA'); -- red
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (1, 9, 'EVDO'); -- red

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (2, 1);
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (2, 2);
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (2, 3); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (2, 5); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (2, 6); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (2, 4); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (2, 7); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (2, 8); -- derecho

INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 1, '40 pulgadas');
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 2, '1920 x 1080 pixels');
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 3, NULL); -- puertos
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 5, '1'); -- HDMI
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 6, '2'); -- USB
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 4, NULL); -- parlantes
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 7, '10 watt'); -- izquierdo
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (2, 8, '10 watt'); -- derecho

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (3, 1);
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (3, 2);
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (3, 3); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (3, 5); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (3, 6); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (3, 4); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (3, 7); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (3, 8); -- derecho

INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 1, '30 pulgadas');
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 2, '1600 x 900 pixels');
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 3, NULL); -- puertos
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 5, '1'); -- HDMI
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 6, '1'); -- USB
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 4, NULL); -- parlantes
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 7, '10 watt'); -- izquierdo
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (3, 8, '10 watt'); -- derecho

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (4, 1);
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (4, 2);
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (4, 3); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (4, 5); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (4, 6); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (4, 4); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (4, 7); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (4, 8); -- derecho

INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 1, '25 pulgadas');
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 2, '1366 x 768 pixels');
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 3, NULL); -- puertos
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 5, '1'); -- HDMI
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 6, '0'); -- USB
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 4, NULL); -- parlantes
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 7, '5 watt'); -- izquierdo
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (4, 8, '5 watt'); -- derecho

INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (5, 1);
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (5, 2);
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (5, 3); -- puertos
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (5, 5); -- HDMI
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (5, 6); -- USB
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (5, 4); -- parlantes
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (5, 7); -- izquierdo
INSERT INTO `AtributosDelProducto` (`idProducto`, `idAtributo`) VALUES (5, 8); -- derecho

INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 1, '20 pulgadas');
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 2, '1280 x 720 pixels');
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 3, NULL); -- puertos
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 5, '0'); -- HDMI
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 6, '0'); -- USB
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 4, NULL); -- parlantes
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 7, '5 watt'); -- izquierdo
INSERT INTO `Valores` (`idProducto`, `idAtributo`, `valor`) VALUES (5, 8, '5 watt'); -- derecho

SELECT Productos.idProducto, Productos.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', A.nombre AS 'Atributo', V.valor AS 'Valor'
FROM Productos JOIN Categorias
ON Productos.idCategoria = Categorias.idCategoria
JOIN Marcas
ON Productos.idMarca = Marcas.idMarca
JOIN AtributosDelProducto AS ADP
ON Productos.idProducto = ADP.idProducto
JOIN Atributos AS A
ON ADP.idAtributo = A.idAtributo
JOIN Valores V
ON ADP.idProducto = V.idProducto AND ADP.idAtributo = V.idAtributo
ORDER BY Productos.idProducto, COALESCE(A.idAtributoPadre, A.idAtributo), A.idAtributoPadre, A.nombre, V.valor;

UPDATE ProductosJSON
SET atributos = '[
	{
		"Atributo": "Pantalla", 
        "Valor": "50 pulgadas", 
        "idAtributo": "1", 
        "idAtributoPadre": null
	}, 
	{
		"Atributo": "Resolución", 
        "Valor": "2048 x 1152 pixels", 
        "idAtributo": 2, 
        "idAtributoPadre": null
	},
	{
		"Atributo": "Puertos", 
        "Valor": null, 
        "idAtributo": 3, 
        "idAtributoPadre": null
	},
    {
		"Atributo": "HDMI", 
        "Valor": "1", 
        "idAtributo": 5, 
        "idAtributoPadre": 3
	},
    {
		"Atributo": "USB", 
        "Valor": "3", 
        "idAtributo": 6, 
        "idAtributoPadre": 3
	},
    {
		"Atributo": "Parlantes", 
        "Valor": null, 
        "idAtributo": 4, 
        "idAtributoPadre": null
	},
    {
		"Atributo": "Izquierdo", 
        "Valor": "10 watt", 
        "idAtributo": 7, 
        "idAtributoPadre": 4
	},
    {
		"Atributo": "Derecho", 
        "Valor": "10 watt", 
        "idAtributo": 8, 
        "idAtributoPadre": 4
	},
    {
		"Atributo": "Red", 
        "Valor": ["GSM" , "CDMA" , "HSPA" , "EVDO"], 
        "idAtributo": 9, 
        "idAtributoPadre": null
	}
]'
WHERE idProducto = 1;
-- No se puede tener la misma salida que para el diseño relacional ya que el valor de una clave puede ser un vector o un único valor
-- Esto se puede solucionar haciendo una unión

-- Múltiples tablas - Combinación de varios resultsets

SELECT idProducto, nombre, Marca, Categoria, Atributo, Valor FROM
((SELECT ProductosJSON.idProducto, ProductosJSON.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoria', TablaJSON1.Atributo, 
CASE TablaJSON1.Valor
	WHEN 'null' THEN NULL
    ELSE TablaJSON1.Valor
END AS 'Valor',
TablaJSON1.idAtributo, TablaJSON1.idAtributoPadre
FROM ProductosJSON JOIN Categorias
ON ProductosJSON.idCategoria = Categorias.idCategoria
JOIN Marcas
ON ProductosJSON.idMarca = Marcas.idMarca,  
JSON_TABLE(atributos, '$[*]' COLUMNS (
	Atributo VARCHAR(50) PATH '$.Atributo',
    Valor VARCHAR(50) PATH '$.Valor',
    idAtributo INT PATH '$.idAtributo',
    idAtributoPadre INT PATH '$.idAtributoPadre')
) AS TablaJSON1
WHERE Valor IS NOT NULL)

UNION

(SELECT ProductosJSON.idProducto, ProductosJSON.nombre, Marcas.nombre AS 'Marca', Categorias.nombre AS 'Categoría', TablaJSON2.Atributo, 
CASE TablaJSON2.Valor
	WHEN 'null' THEN NULL
    ELSE TablaJSON2.Valor
END AS 'Valor',
TablaJSON2.idAtributo, TablaJSON2.idAtributoPadre
FROM ProductosJSON JOIN Categorias
ON ProductosJSON.idCategoria = Categorias.idCategoria
JOIN Marcas
ON ProductosJSON.idMarca = Marcas.idMarca,  
JSON_TABLE(atributos, '$[*]' COLUMNS (
	Atributo VARCHAR(50) PATH '$.Atributo',    
    NESTED PATH '$.Valor[*]' COLUMNS (Valor VARCHAR(50) PATH '$'),
    idAtributo INT PATH '$.idAtributo',
    idAtributoPadre INT PATH '$.idAtributoPadre')
) AS TablaJSON2
WHERE Valor IS NOT NULL)) AS T 
ORDER BY T.idProducto, COALESCE(T.idAtributoPadre, T.idAtributo), T.idAtributoPadre, T.Atributo, T.Valor;


-- Múltiples tablas - Creación de una tabla desde un resultset

CREATE TABLE IF NOT EXISTS ProductosCopia
SELECT idProducto, nombre
FROM Productos;

SELECT * FROM ProductosCopia;

DROP TABLE IF EXISTS ProductosCopia;

CREATE TABLE IF NOT EXISTS ProductosCopia LIKE Productos;

SELECT * FROM ProductosCopia;

DROP TABLE IF EXISTS ProductosCopia;

CREATE TEMPORARY TABLE IF NOT EXISTS ProductosCopia
SELECT idProducto, nombre
FROM Productos;

SELECT * FROM ProductosCopia;

DROP TABLE IF EXISTS ProductosCopia;


-- Técnicas avanzadas - Subconsultas

SELECT idMarca, nombre
FROM Marcas M
WHERE EXISTS (SELECT * FROM Productos P WHERE M.idMarca = P.idMarca);
-- muestra sólo las marcas que tengan productos asociados


-- Técnicas avanzadas - Inserción de filas basadas en otras tablas

CREATE TABLE IF NOT EXISTS Personas1 LIKE Personas;

INSERT INTO Personas1
SELECT dni, apellidos, SUBSTRING(nombres, 1, 3)
FROM Personas;

SELECT * FROM Personas1;

DROP TABLE IF EXISTS Personas1;


-- Técnicas avanzadas - Modificación y borrado de filas basadas en otras tablas 

INSERT INTO `Productos` (idProducto, nombre, idMarca, idCategoria) VALUES (6, 'Runner', 3, 3);

SELECT * FROM `Productos`;
SELECT * FROM `Categorias` WHERE nombre LIKE '%mar%';

DELETE FROM `Productos`
WHERE idCategoria IN
       (SELECT idCategoria FROM Categorias WHERE nombre LIKE '%mar%');
-- Borra los productos cuyas categorías tengan la cadena 'mar'
SELECT * FROM `Productos`;

-- o también

INSERT INTO `Productos` (idProducto, nombre, idMarca, idCategoria) VALUES (6, 'Runner', 3, 3);

DELETE P
FROM Productos P JOIN Categorias C
ON P.idCategoria = C.idCategoria
WHERE C.nombre LIKE '%mar%';
-- Borra los productos cuyas categorías tengan la cadena 'mar'

SELECT * FROM `Productos`;

INSERT INTO `Productos` (idProducto, nombre, idMarca, idCategoria) VALUES (6, 'Runner', 3, 3);

UPDATE `Productos`
SET idCategoria = 2
WHERE idCategoria IN
       (SELECT idCategoria FROM Categorias WHERE nombre LIKE '%mar%');
-- Modifica los productos cuyas categorías tengan la cadena 'mar'

SELECT * FROM `Productos`;

-- o también

UPDATE Productos P JOIN Categorias C
ON P.idCategoria = C.idCategoria
SET P.idCategoria = 3
WHERE C.nombre LIKE '%lul%';
-- Modifica los productos cuyas categorías tengan la cadena 'lul'

SELECT * FROM `Productos`;
