--  Información sobre restricciones
DROP DATABASE IF EXISTS `LBD2023`;
CREATE DATABASE `LBD2023`;

USE information_schema;

SELECT * FROM table_constraints
WHERE constraint_schema = 'LBD2023';
-- table_constraints: describe qué tablas tienen restricciones:
-- CONSTRAINT_CATALOG: nombre del catálogo al cual pertenece la restricción. Siempre vale def.
-- CONSTRAINT_SCHEMA: nombre del esquema (BD) al cual pertenece la restricción
-- CONSTRAINT_NAME: nombre de la restricción
-- TABLE_SCHEMA: nombre del esquema (BD) al cual pertenece la tabla
-- TABLE_NAME: nombre de la tabla
-- CONSTRAINT_TYPE: tipo de restricción: UNIQUE, PRIMARY KEY, FOREIGN KEY o CHECK (desde MySQL 8.0.16)
-- ENFORCED: en el caso de una restricción CHECK, el valor es YES o NO para indicar si la misma está impuesta o no. Para las otras restricciones siempre vale YES.

SELECT * FROM key_column_usage
WHERE constraint_schema = 'LBD2023';
-- key_column_usage: describe qué columnas claves tienen restricciones:
-- CONSTRAINT_CATALOG: nombre del catálogo al cual pertenece la restricción. Siempre vale def.
-- CONSTRAINT_SCHEMA: nombre del esquema (BD) al cual pertenece la restricción
-- CONSTRAINT_NAME: nombre de la restricción
-- TABLE_CATALOG: nombre del catálogo al cual pertenece la tabla. Siempre vale def.
-- TABLE_NAME: nombre de la tabla que tiene la restricción
-- COLUMN_NAME: nombre de la columna que tiene la restricción. Si la restricción es una FK, es la columna de la FK, no la columna a la cual referencia la FK
-- ORDINAL_POSITION: posición de la columna dentro de la restricción (no dentro de la tabla). El primer valor es 1.
-- POSITION_IN_UNIQUE_CONSTRAINT: para restricciones UNIQUE y PK vale NULL. Para FK es la posición dentro de la clave de la tabla referenciada
-- REFERENCED_TABLE_SCHEMA: nombre del esquema referenciado por la restricción
-- REFERENCED_TABLE_NAME: nombre de la tabla referenciada por la restricción
-- REFERENCED_COLUMN_NAME: nombre de la columna referenciada por la restricción

-- Creación/borrado de PK
USE `LBD2023`;

DROP TABLE IF EXISTS `Personas` ;

CREATE TABLE IF NOT EXISTS `Personas` (
  `dni` INT NOT NULL,
  `apellidos` VARCHAR(40) NOT NULL,
  `nombres` VARCHAR(40) NOT NULL)
ENGINE = InnoDB;

ALTER TABLE `Personas` 
ADD CONSTRAINT PK_DNI PRIMARY KEY (dni);

SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'LBD2023';

SELECT * FROM information_schema.key_column_usage
WHERE constraint_schema = 'LBD2023';

ALTER TABLE `Personas` 
DROP PRIMARY KEY;

SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'LBD2023';

SELECT * FROM information_schema.key_column_usage
WHERE constraint_schema = 'LBD2023';

-- Creación/borrado de FK

DROP TABLE IF EXISTS `Profesores` ;

CREATE TABLE IF NOT EXISTS `Profesores` (
  `dni` INT NOT NULL,
  `idCargo` INT NOT NULL)
ENGINE = InnoDB;

ALTER TABLE `Personas` 
ADD CONSTRAINT PK_DNI PRIMARY KEY (dni);

ALTER TABLE `Profesores` 
ADD CONSTRAINT PK_DNI PRIMARY KEY (dni);

ALTER TABLE `Profesores` 
ADD CONSTRAINT `FK_DNI` FOREIGN KEY (`dni`) 
REFERENCES `Personas` (`dni`); -- dni es PK en Personas

SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'LBD2023';

SELECT * FROM information_schema.key_column_usage
WHERE constraint_schema = 'LBD2023';

SELECT * FROM information_schema.referential_constraints
WHERE constraint_schema = 'LBD2023';
-- referential_constraints: da información sobre las FKs
-- CONSTRAINT_CATALOG: nombre del catálogo al cual pertenece la restricción. Siempre vale def.
-- CONSTRAINT_SCHEMA: nombre del esquema (BD) al cual pertenece la restricción
-- CONSTRAINT_NAME: nombre de la restricción
-- UNIQUE_CONSTRAINT_CATALOG: nombre del catálogo que contiene la restricción UNIQUE que referencia la restricción. Siempre vale def.
-- UNIQUE_CONSTRAINT_SCHEMA: nombre del esquema que contiene la restricción UNIQUE que referencia la restricción
-- UNIQUE_CONSTRAINT_NAME: nombre de la restricción UNIQUE que referencia la restricción.
-- MATCH_OPTION: valor del atributo MATCH de la restricción. El único valor permitido es NONE.
-- UPDATE_RULE: valor del atributo UPDATE de la restricción. Valores posibles: CASCADE, SET NULL, SET DEFAULT, RESTRICT, NO ACTION.
-- DELETE_RULE: valor del atributo DELETE de la restricción. Valores posibles: CASCADE, SET NULL, SET DEFAULT, RESTRICT, NO ACTION.
-- TABLE_NAME: nombre de la tabla (el mismo que en la tabla TABLE_CONSTRAINTS)
-- REFERENCED_TABLE_NAME: nombre de la tabla referenciada por la restricción 

-- FK con acción referencial

INSERT INTO `Personas` VALUES(23518045, 'Nieto', 'Luis');
INSERT INTO `Profesores` VALUES(23518045, 2);

DELETE FROM `Personas` WHERE `dni` = 23518045; -- error

ALTER TABLE `Profesores` 
DROP FOREIGN KEY `FK_DNI`;

ALTER TABLE `Profesores` 
ADD CONSTRAINT `FK_DNI` FOREIGN KEY (`dni`) 
REFERENCES `Personas` (`dni`)
ON DELETE CASCADE;

SELECT * FROM information_schema.referential_constraints
WHERE constraint_schema = 'LBD2023';

DELETE FROM `Personas` WHERE `dni` = 23518045; -- OK

SELECT * FROM `Personas`;
SELECT * FROM `Profesores`;

INSERT INTO `Personas` VALUES(23518045, 'Nieto', 'Luis');
INSERT INTO `Profesores` VALUES(23518045, 2);

UPDATE `Personas`
SET `dni` = 11111111 WHERE `dni` = 23518045; -- error

ALTER TABLE `Profesores` 
DROP FOREIGN KEY `FK_DNI`;

ALTER TABLE `Profesores` 
ADD CONSTRAINT `FK_DNI` FOREIGN KEY (`dni`) 
REFERENCES `Personas` (`dni`)
ON DELETE CASCADE ON UPDATE CASCADE;

SELECT * FROM information_schema.referential_constraints
WHERE constraint_schema = 'LBD2023';

UPDATE `Personas`
SET `dni` = 11111111 WHERE `dni` = 23518045; -- OK

SELECT * FROM `Personas`;
SELECT * FROM `Profesores`;


-- Creación/borrado de DEFAULT

ALTER TABLE `Profesores`
ALTER `idCargo` SET DEFAULT 2;

SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'LBD2023'; -- no figura la default

SELECT * FROM information_schema.key_column_usage
WHERE constraint_schema = 'LBD2023'; -- no figura la default

SELECT * FROM information_schema.referential_constraints
WHERE constraint_schema = 'LBD2023'; -- no figura la default

INSERT INTO Personas VALUES(16039418, 'Saade', 'Sergio');
INSERT INTO `Profesores` (`dni`) VALUES (16039418);

SELECT * FROM `Personas`;
SELECT * FROM `Profesores`;

ALTER TABLE `Profesores`
ALTER `idCargo` DROP DEFAULT;

DROP TABLE IF EXISTS `Trabajos` ;

CREATE TABLE IF NOT EXISTS `Trabajos` (
  `idTrabajo` INT NOT NULL,
  `titulo` VARCHAR(150) NOT NULL,
  `duracion` INT NOT NULL,
  -- `fechaPresentacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- OK
  -- `fechaPresentacion` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP, -- error (por el tipo de dato)
  `fechaPresentacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- OK
  `fechaAprobacion` DATE NOT NULL,
  `fechaFinalizacion` DATE NULL,
  PRIMARY KEY (`idTrabajo`))
ENGINE = InnoDB;


-- Creación/borrado de CHECK

DROP TABLE IF EXISTS `T1` ;

CREATE TABLE T1 (
  CHECK (c1 <> c2), -- a nivel tabla: fuera de la definición de una columna. Referencia a columnas todavía no definidas (c1 y c2)
  c1 INT CHECK (c1 > 10), -- a nivel columna (sin nombre)
  c2 INT CONSTRAINT c2_positivo CHECK (c2 > 0), -- a nivel columna (con nombre)
  -- c2 INT CHECK (c2 > 0), -- a nivel columna (sin nombre)
  c3 INT CHECK (c3 < 100), -- a nivel columna (sin nombre)
  CONSTRAINT c1_nocero CHECK (c1 <> 0), -- a nivel tabla (con nombre)
  CHECK (c1 > c3) -- a nivel tabla (sin nombre)
 );
 
SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'LBD2023'; 

SELECT * FROM information_schema.key_column_usage
WHERE constraint_schema = 'LBD2023'; -- no figura la CHECK


INSERT INTO T1 (c1, c2, c3) VALUES (1, 2, 3); -- 1: OK, 2: no cumple
INSERT INTO T1 (c1, c2, c3) VALUES (1, 1, 3); -- 1: no cumple
INSERT INTO T1 (c1, c2, c3) VALUES (20, 2, 3); -- 1: OK, 2: OK, 3: OK, 4: OK, 5: OK
SELECT * FROM T1;
 
DROP TABLE IF EXISTS `T1` ;

-- Creación/borrado de UNIQUE

DROP TABLE IF EXISTS `Alumnos` ;

CREATE TABLE IF NOT EXISTS `Alumnos` (
  `dni` INT NOT NULL,
  `cx` CHAR(7) NULL,
  PRIMARY KEY (`dni`),
  CONSTRAINT `fk_Alumnos_Personas1`
    FOREIGN KEY (`dni`)
    REFERENCES `Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO `Personas` VALUES(37497717, 'Ortíz', 'Juan Pablo'); -- OK
INSERT INTO `Personas` VALUES(37312195, 'Ledesma', 'Facundo'); -- OK
INSERT INTO `Alumnos` VALUES(37497717, '1414641'); -- OK
INSERT INTO `Alumnos` VALUES(37312195, '1414641'); -- OK (mismo cx que el anterior)

DELETE FROM `Alumnos`;
DELETE FROM `Personas`;

ALTER TABLE `Alumnos`
ADD CONSTRAINT `U_CX` UNIQUE (`cx`);

SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'LBD2023'; 

SELECT * FROM information_schema.key_column_usage
WHERE constraint_schema = 'LBD2023'; 

INSERT INTO `Personas` VALUES(37497717, 'Ortíz', 'Juan Pablo');
INSERT INTO `Personas` VALUES(37312195, 'Ledesma', 'Facundo');
INSERT INTO `Alumnos` VALUES(37497717, '1414641'); -- OK
INSERT INTO `Alumnos` VALUES(37312195, '1414641'); -- error (mismo cx que el anterior)
INSERT INTO `Alumnos` VALUES(37312195, '1412969'); -- OK

ALTER TABLE `Alumnos`
DROP INDEX `U_CX`;

-- Restricciones en tablas con datos

DROP TABLE IF EXISTS `Cargos` ;

CREATE TABLE IF NOT EXISTS `Cargos` (
  `idCargo` INT NOT NULL,
  `cargo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCargo`))
ENGINE = InnoDB;

INSERT INTO `Cargos` VALUES(1, 'Titular');
INSERT INTO `Cargos` VALUES(2, 'Asociado');
INSERT INTO `Cargos` VALUES(3, 'Adjunto');
INSERT INTO `Cargos` VALUES(4, 'JTP');
INSERT INTO `Cargos` VALUES(5, 'ADG');
INSERT INTO `Cargos` VALUES(6, 'Externo');

DELETE FROM `Alumnos`;
DELETE FROM `Profesores`;
DELETE FROM `Personas`;

INSERT INTO `Personas` VALUES(23518045, 'Nieto', 'Luis');
INSERT INTO `Personas` VALUES(16039418, 'Saade', 'Sergio');
INSERT INTO `Profesores` VALUES(23518045, 2);
INSERT INTO `Profesores` VALUES (16039418, 1);

SELECT * FROM Profesores;

ALTER TABLE `Profesores` 
ADD CONSTRAINT `FK_CARGO` FOREIGN KEY (`idCargo`) 
REFERENCES `Cargos` (`idCargo`); 
-- OK si todas las filas en Profesores la columna idCargo se corresponde con un valor en Cargos

INSERT INTO `Personas` VALUES(30117830, 'Albaca', 'Carlos');
INSERT INTO `Profesores` VALUES(30117830, 10); -- error: viola la FK

SET FOREIGN_KEY_CHECKS = 0;
INSERT INTO `Profesores` VALUES(30117830, 10); -- OK
SET FOREIGN_KEY_CHECKS = 1;

SELECT * FROM Profesores;

UPDATE `Profesores` 
SET `idCargo` = 2 WHERE `dni` = 30117830; -- OK

UPDATE `Profesores` 
SET `idCargo` = 10 WHERE `dni` = 30117830; -- error: viola la FK

-- Creación/borrado de índices agrupados y no agrupados

-- Se crea la tabla DetalleOrdenes como copia de la tabla AdventureWorks2014.PurchaseOrderDetail
CREATE TABLE IF NOT EXISTS DetalleOrdenes
SELECT * FROM AdventureWorks2014.PurchaseOrderDetail;

SHOW INDEX FROM DetalleOrdenes; -- sin índices

SELECT * FROM DetalleOrdenes; 
-- escaneo de tabla (se leen todas las filas para recuperar 8730 filas)
-- costo: 897.55

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID = 1 AND PurchaseOrderDetailID = 1; 
-- escaneo de tabla (se leen todas las filas para recuperar 1 fila)
-- costo: 897.55

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID = 1;
-- escaneo de tabla (se leen todas las filas para recuperar 1 fila)
-- costo: 897.55

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderDetailID = 1;
-- escaneo de tabla (se leen todas las filas para recuperar 1 fila)
-- costo: 897.55

SELECT * FROM DetalleOrdenes
WHERE ProductID = 1;
-- escaneo de tabla (se leen todas las filas para recuperar 51 filas)
-- costo: 897.55

ALTER TABLE DetalleOrdenes
ADD CONSTRAINT PK PRIMARY KEY (PurchaseOrderID, PurchaseOrderDetailID);
-- se crea un índice agrupado por la PK (PurchaseOrderID, PurchaseOrderDetailID)

SHOW INDEX FROM DetalleOrdenes; -- índice por la PK (columna Key_name aparece como PRIMARY)

SELECT * FROM DetalleOrdenes;
-- escaneo de tabla (no usa el índice para leer 8890 filas)
-- Costo: 984.8

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID = 1 AND PurchaseOrderDetailID = 1;
-- se lee una única fila, usando el índice agrupado (PRIMARY)
-- Costo: 0.1

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderDetailID = 1 AND PurchaseOrderID = 1;
-- se lee una única fila, usando el índice agrupado (PRIMARY)
-- Costo: 0.1

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID = 1;
-- se lee una única fila (Non-Unique Key Lookup) 
-- Costo: 1.09

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderDetailID = 1;
-- hace un escaneo de tabla para recuperar una única fila 
-- Costo: 984.8

SELECT * FROM DetalleOrdenes
WHERE ProductID = 1;
-- hace un escaneo de tabla para recuperar 51 filas 
-- Costo: 984.8

ALTER TABLE DetalleOrdenes 
DROP PRIMARY KEY;
-- Se borra el índice agrupado

CREATE INDEX IX
ON DetalleOrdenes(PurchaseOrderID, PurchaseOrderDetailID);
-- Se crea un índice no agrupado

SHOW INDEX FROM DetalleOrdenes; -- índice no agrupado (columna Key_name aparece el nombre del índice)

SELECT * FROM DetalleOrdenes;
-- escaneo de tabla (no usa el índice para leer 8730 filas)
-- Costo: 897.55 

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID = 1 AND PurchaseOrderDetailID = 1; 
-- se lee una única fila usando el índice no agrupado, haciendo un key lookup
-- Costo: 0.35

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderDetailID = 1 AND PurchaseOrderID = 1;
-- se lee una única fila, usando el índice no agrupado, haciendo un key lookup
-- Costo: 0.35

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID = 1;
-- se lee una única fila, usando el índice no agrupado, haciendo un key lookup
-- Costo: 0.35

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderDetailID = 1;
-- hace un escaneo de tabla para recuperar una única fila 
-- Costo: 897.55

SELECT * FROM DetalleOrdenes
WHERE ProductID = 1;
-- hace un escaneo de tabla para recuperar 51 filas 
-- Costo: 897.55

ALTER TABLE DetalleOrdenes
ADD CONSTRAINT PK PRIMARY KEY (PurchaseOrderID, PurchaseOrderDetailID);
-- se vuelve a crear un índice agrupado por la PK

SHOW INDEX FROM DetalleOrdenes; -- índices agrupado y no agrupado

SELECT * FROM DetalleOrdenes;
-- escaneo de tabla (no usa ningún índice)
-- Costo: 984.8

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID = 1 AND PurchaseOrderDetailID = 1;
-- se lee una única fila, usando el índice agrupado por sobre el no agrupado
-- Costo: 0.1

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderDetailID = 1 AND PurchaseOrderID = 1;
-- se lee una única fila, usando el índice agrupado (PRIMARY)
-- Costo: 0.1

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID = 1;
-- se lee una única fila usando Non-Unique Key Lookup
-- Costo: 1.09

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderDetailID = 1;
-- hace un escaneo de tabla para recuperar una única fila 
-- Costo: 984.8

SELECT * FROM DetalleOrdenes
WHERE ProductID = 1;
-- hace un escaneo de tabla para recuperar 51 filas 
-- Costo: 984.8

-- Uso de índice agrupado para datos pre ordenados

ALTER TABLE DetalleOrdenes
DROP INDEX IX;
-- Se borra el índice no agrupado

SHOW INDEX FROM DetalleOrdenes; -- índice por la PK 

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID BETWEEN 500 AND 510
ORDER BY PurchaseOrderID, PurchaseOrderDetailID;
-- Index scan (por el índice agrupado)
-- Costo 4.89

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID BETWEEN 500 AND 510
ORDER BY PurchaseOrderDetailID, PurchaseOrderID;
-- Index scan (por el índice agrupado)
-- Costo 4.89

ALTER TABLE DetalleOrdenes 
DROP PRIMARY KEY;
-- Se borra el índice agrupado

CREATE INDEX IX
ON DetalleOrdenes(PurchaseOrderID, PurchaseOrderDetailID);
-- Se crea un índice no agrupado

SHOW INDEX FROM DetalleOrdenes; -- índices no agrupado

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID BETWEEN 500 AND 510
ORDER BY PurchaseOrderID, PurchaseOrderDetailID;
-- Index scan (por el índice no agrupado)
-- Costo 8.81 contra los 4.89 con el uso del índice agrupado

ALTER TABLE DetalleOrdenes
ADD CONSTRAINT PK PRIMARY KEY (PurchaseOrderID, PurchaseOrderDetailID);
-- se vuelve a crear un índice agrupado por la PK

SHOW INDEX FROM DetalleOrdenes; -- índices agrupado y no agrupado

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID BETWEEN 500 AND 510
ORDER BY PurchaseOrderID, PurchaseOrderDetailID;
-- Index scan (por el índice agrupado)
-- Costo 4.91

ALTER TABLE DetalleOrdenes 
DROP PRIMARY KEY;
-- Se borra el índice agrupado

ALTER TABLE DetalleOrdenes
DROP INDEX IX;
-- Se borra el índice no agrupado

SHOW INDEX FROM DetalleOrdenes; -- sin índices

SELECT * FROM DetalleOrdenes
WHERE PurchaseOrderID BETWEEN 500 AND 510
ORDER BY PurchaseOrderID, PurchaseOrderDetailID;
-- Escanero de tabla
-- Costo 897.55

DROP TABLE IF EXISTS DetalleOrdenes;

-- Creación de índices UNIQUE

CREATE UNIQUE INDEX IX_Cargo 
ON Cargos (cargo);


-- Información de índices
SHOW INDEX FROM Cargos;

-- Especificación del valor de umbral (a nivel tabla)

ALTER TABLE `Profesores` 
DROP FOREIGN KEY `FK_CARGO`;

DROP TABLE IF EXISTS `Cargos` ;

CREATE TABLE IF NOT EXISTS `Cargos` (
  `idCargo` INT NOT NULL,
  `cargo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCargo`)
) ENGINE = InnoDB, COMMENT = 'MERGE_THRESHOLD = 45'; 

SHOW INDEX FROM `Cargos`; 
-- no muestra información sobre el valor de umbral porque esta sentencia funciona a nivel columna
SHOW CREATE TABLE `Cargos`; 
-- sí muestra información sobre el valor de umbral porque esta sentencia funciona a nivel tabla

DROP TABLE IF EXISTS `Cargos` ;

CREATE TABLE IF NOT EXISTS `Cargos` (
  `idCargo` INT NOT NULL,
  `cargo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCargo`)
) ENGINE = InnoDB;

ALTER TABLE `Cargos` COMMENT = 'MERGE_THRESHOLD = 45';

SHOW INDEX FROM `Cargos`; -- no muestra información sobre el valor de umbral
SHOW CREATE TABLE `Cargos`; -- sí muestra información sobre el valor de umbral

-- Especificación del valor de umbral en MySQL (a nivel índice)

DROP TABLE IF EXISTS `Cargos` ;

CREATE TABLE IF NOT EXISTS `Cargos` (
  `idCargo` INT NOT NULL,
  `cargo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCargo`) COMMENT 'MERGE_THRESHOLD = 45'
) ENGINE = InnoDB;

SHOW INDEX FROM `Cargos`; -- sí muestra información sobre el valor de umbral
SHOW CREATE TABLE `Cargos`; -- sí muestra información sobre el valor de umbral

DROP TABLE IF EXISTS `Cargos` ;

CREATE TABLE IF NOT EXISTS `Cargos` (
  `idCargo` INT NOT NULL,
  `cargo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCargo`)
) ENGINE = InnoDB;

CREATE UNIQUE INDEX IX_Cargo 
ON Cargos (cargo) COMMENT 'MERGE_THRESHOLD = 45'; 

SHOW INDEX FROM `Cargos`; -- sí muestra información sobre el valor de umbral
SHOW CREATE TABLE `Cargos`; -- sí muestra información sobre el valor de umbral


