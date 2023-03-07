-- BDs de sistema y usuario
SHOW DATABASES;
-- Para ver las BDs de sistema gráficamente, Edit - Preferences - SQL Editor - Show Metadata and Internal Schemas

-- Selección de una tabla:
-- especificando la BD
SELECT * FROM TrabajosGraduacion.Trabajos;

-- sin especificar la BD (toma la BD predeterminada)
SELECT * FROM Trabajos;

-- Tipos de tablas
SHOW ENGINES;

-- Creación y borrado de BD
DROP DATABASE IF EXISTS LBD2023;
CREATE DATABASE IF NOT EXISTS LBD2023;

USE LBD2023;

-- Tabla con tipos de datos numéricos
CREATE TABLE IF NOT EXISTS Tabla (
	colInt INT NOT NULL,
    colDecimal DECIMAL(10, 2) NOT NULL,
    colFloat FLOAT NOT NULL, 
    colBit BIT NOT NULL
) ENGINE=INNODB;

INSERT INTO Tabla VALUES(1, 100, 100, 1);
INSERT INTO Tabla VALUES(1, 100, 100, b'1');
INSERT INTO Tabla VALUES(1, 100, 100, b'0');

SELECT * FROM Tabla;

SELECT 
	colInt,
	@a := colDecimal/3 AS 'colDecimal', 
    @b := colFloat/3 AS 'colFloat', 
    @a + @a + @a AS 'colDecimal',
    @b + @b + @b AS 'colFloat',
    colBit AS 'colBit'
FROM Tabla;

-- Atributos para los tipos numéricos

CREATE TABLE IF NOT EXISTS Tabla1 (
	colInt INT, -- 10 es el valor predeterminado del ancho
    colIntZerofill INT ZEROFILL, -- 10 es el valor predeterminado del ancho
    colInt3 INT(3),
    colInt3Zerofill INT(3) ZEROFILL,
    colInt11 INT(11),
    colInt11Zerofill INT(11) ZEROFILL,
    colInt20 INT(20),
    colInt20Zerofill INT(20) ZEROFILL,
    colIntUnsigned INT UNSIGNED ZEROFILL -- de 0 a 4294967295 4294967295
) ENGINE=INNODB;

INSERT INTO Tabla1 VALUES(1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO Tabla1 VALUES(10, 10, 10, 10, 10, 10, 10, 10, 10);
INSERT INTO Tabla1 VALUES(100, 100, 100, 100, 100, 100, 100, 100, 100);
INSERT INTO Tabla1 VALUES(1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000);
INSERT INTO Tabla1 VALUES(10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000);
INSERT INTO Tabla1 VALUES(1, 1, 1, 1, 1, 1, 1, 1, -2147483648); -- fuera de rango
INSERT INTO Tabla1 VALUES(1, 1, 1, 1, 1, 1, 1, 1, 4294967295); -- bien
INSERT INTO Tabla1 VALUES(1, 1, 1, 1, 1, 1, 1, 1, 4294967296); -- fuera de rango

SELECT * FROM Tabla1;

-- Atributo AUTO_INCREMENT (columna entera)

CREATE TABLE IF NOT EXISTS Tabla2 (
	colInt INT,
    colIntAutoIncrement INT AUTO_INCREMENT,
    PRIMARY KEY (colIntAutoIncrement)
) ENGINE=INNODB;

INSERT INTO Tabla2 (colInt) VALUES (100);
INSERT INTO Tabla2 (colInt) VALUES (200);
INSERT INTO Tabla2 (colInt) VALUES (300);

SELECT * FROM Tabla2;
SELECT LAST_INSERT_ID();

INSERT INTO Tabla2 (colInt, colIntAutoIncrement) VALUES (400, 10);
INSERT INTO Tabla2 (colInt) VALUES (500);

SELECT * FROM Tabla2;
SELECT LAST_INSERT_ID();

-- Atributo AUTO_INCREMENT (columna flotante)

CREATE TABLE IF NOT EXISTS Tabla3 (
	colInt INT,
    colFloatAutoIncrement FLOAT(4, 2) AUTO_INCREMENT,
    PRIMARY KEY (colFloatAutoIncrement)
) ENGINE=INNODB;

INSERT INTO Tabla3 (colInt) VALUES (100);
INSERT INTO Tabla3 (colInt) VALUES (200);
INSERT INTO Tabla3 (colInt) VALUES (300);

SELECT * FROM Tabla3;
SELECT LAST_INSERT_ID();

INSERT INTO Tabla3 (colInt, colFloatAutoIncrement) VALUES (400, 10.00);
INSERT INTO Tabla3 (colInt) VALUES (500);

SELECT * FROM Tabla3;
SELECT LAST_INSERT_ID();

-- Tabla con tipos de datos para fechas

CREATE TABLE IF NOT EXISTS Tabla4 (
    colIntAutoIncrement INT AUTO_INCREMENT,
    colFecha DATE,
    colFechaYHoraDateTime1 DATETIME DEFAULT CURRENT_TIMESTAMP,
    colFechaYHoraDateTime2 DATETIME(3), -- hasta 3 dígitos para los microsegundos
    colFechaYHoraTimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    colHora1 TIME,
    colHora2 TIME(5), -- hasta 5 dígitos para los microsegundos
    PRIMARY KEY (colIntAutoIncrement)
) ENGINE=INNODB;

INSERT INTO Tabla4 (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES ('2023-03-13', '2023-03-13 19:43:00.111', '19:43:00', '19:43:00.11111');
INSERT INTO Tabla4 (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES ('2023-03-14', '2023-03-14 19:43:00.222', '19:43:00', '19:43:00.22222');
INSERT INTO Tabla4 (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES ('2023-03-15', '2023-03-15 19:43:00.333', '19:43:00', '19:43:00.33333');
INSERT INTO Tabla4 (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES ('2023-03-16', '2023-03-16 19:43:00.444', '19:43:00', '19:43:00.44444');
INSERT INTO Tabla4 (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES (NULL, '2023-03-13 19:43:00.111', '19:43:00', '19:43:00.55555');

SELECT * FROM Tabla4;


-- Tabla con tipos de datos CHAR y BINARY

CREATE TABLE IF NOT EXISTS Tabla5 (
	colVarchar VARCHAR(10), -- compara cadenas usando una collation
    colVarbinary VARBINARY(10) -- compara cadenas usando bytes
) ENGINE=INNODB;

INSERT INTO Tabla5 VALUES ('mundo', 'mundo');
INSERT INTO Tabla5 VALUES ('Mundo', 'Mundo');
INSERT INTO Tabla5 VALUES ('Hola', 'Hola');
INSERT INTO Tabla5 VALUES ('hola', 'hola');

SELECT * FROM Tabla5 ORDER BY colVarchar;
-- Para poder ver una columna BINARY: preferencias - “SQL Execution” - “Treat Binary/Varbinary as nonbinary character string”
-- Hola, hola, mundo, Mundo: alfabético ascendente: si encuentra 2 iguales (Hola y hola), según el orden de inserción

SELECT * FROM Tabla5 ORDER BY colVarbinary;
-- Hola, Mundo, hola, mundo: según el valor numérico de las cadenas

-- Tabla con tipo de dato Enum

CREATE TABLE IF NOT EXISTS Tabla6 (
    marca VARCHAR(40) NOT NULL,
    tamanio ENUM('Small', 'Medium', 'Large')
) ENGINE=INNODB;

INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca1', 'Small'); -- posición = 1
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca1', 'Medium'); -- posición = 2
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca2', 'Medium'); -- posición = 2
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca3', 'Small'); -- posición = 1
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca3', 'Medium'); -- posición = 2
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca3', 'Large'); -- posición = 3
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca3', 'large'); -- valor válido, posición = 3
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca3', NULL); -- valor válido, posición = NULL
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca3', ''); -- valor inválido, posición = 0 (modo estricto debe estar deshabilitado. Se habilita mediante el archivo my.ini)
INSERT INTO Tabla6 (marca, tamanio) VALUES ('Marca4', 'Otro valor'); -- valor inválido
-- Si la columna tamanio se hubiera declarado como VARCHAR, 
-- insertar un millón de filas con el valor ‘medium’ requeriría 6 millones de bytes
-- Al declararse como ENUM se requieren 1 millón

SELECT marca, tamanio, tamanio + 0 as 'Posición' FROM Tabla6;

SELECT * FROM Tabla6
ORDER BY tamanio; 
-- ordena según la posición


-- Tabla con tipo de dato Set

CREATE TABLE IF NOT EXISTS Tabla7 (
    idAlumno INT NOT NULL,
    turnos SET('Turno1', 'Turno2', 'Turno3')
) ENGINE=INNODB;

INSERT INTO Tabla7 (idAlumno, turnos) VALUES (1, 'Turno1'); -- valor válido
INSERT INTO Tabla7 (idAlumno, turnos) VALUES (2, 'Turno1,Turno2'); -- valor válido
INSERT INTO Tabla7 (idAlumno, turnos) VALUES (3, 'Turno1, Turno2'); -- valor inválido (espacio en blanco)
INSERT INTO Tabla7 (idAlumno, turnos) VALUES (4, 'Turno2,Turno1'); -- valor válido
INSERT INTO Tabla7 (idAlumno, turnos) VALUES (5, 'Turno1,Turno2,Turno3'); -- valor válido
INSERT INTO Tabla7 (idAlumno, turnos) VALUES (6, 'Turno1,Turno2,Turno3,Turno3'); -- valor válido
INSERT INTO Tabla7 (idAlumno, turnos) VALUES (7, ''); -- valor válido
INSERT INTO Tabla7 (idAlumno, turnos) VALUES (8, 'Turno1,Turno2,Turno3,Turno4'); -- valor inválido
INSERT INTO Tabla7 (idAlumno, turnos) VALUES (9, 'Turno4'); -- valor inválido

SELECT * FROM Tabla7;


-- Borrado de tabla

DROP TABLE IF EXISTS Tabla; 