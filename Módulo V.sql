USE LBD2023;

-- Visualización de un plan de ejecución

-- Para ver el plan de ejecución gráficamente, seleccionar la consulta y elegir: Query - Explain Current Statement:
SELECT Ordenes.IDOrden, Fecha, Compania, Items.IDItem, Items.Nombre, Precio, Cantidad
FROM Ordenes JOIN Clientes
ON Ordenes.IDCliente = Clientes.IDCliente
JOIN Detalles
ON Ordenes.IDOrden = Detalles.IDOrden
JOIN Items
ON Detalles.IDItem = Items.IDItem;  

-- A la consulta anterior también se le puede ver gráficamente su plan de ejecución 
-- ejecutándola y a la derecha en la ventana de resultados seleccionar Execution Plan

-- Para ver el plan de ejecución en forma de texto:
EXPLAIN FORMAT = TREE
	SELECT Ordenes.IDOrden, Fecha, Compania, Items.IDItem, Items.Nombre, Precio, Cantidad
	FROM Ordenes JOIN Clientes
	ON Ordenes.IDCliente = Clientes.IDCliente
	JOIN Detalles
	ON Ordenes.IDOrden = Detalles.IDOrden
	JOIN Items
	ON Detalles.IDItem = Items.IDItem;
    

-- Creación de procedimiento almacenado

DROP PROCEDURE IF EXISTS ListarOrdenes;

DELIMITER //
CREATE PROCEDURE ListarOrdenes()
-- Muestra un listado ordenado por compañía de órdenes que incluye los ítems pedidos, su precio y cantidad
BEGIN  
	SELECT Ordenes.IDOrden, DATE(Fecha) AS 'Fecha', Compania, Items.IDItem, Items.Nombre, Precio, Cantidad
	FROM Ordenes JOIN Clientes
	ON Ordenes.IDCliente = Clientes.IDCliente
	JOIN Detalles
	ON Ordenes.IDOrden = Detalles.IDOrden
	JOIN Items
	ON Detalles.IDItem = Items.IDItem
    ORDER BY Compania;   
END //
DELIMITER ;


-- Ejecución de un procedimiento almacenado

CALL ListarOrdenes();

-- o también: 

CALL ListarOrdenes;


-- Anidamiento de un procedimiento almacenado

DROP PROCEDURE IF EXISTS ListarOrdenes2;

DELIMITER //
CREATE PROCEDURE ListarOrdenes2()
-- Muestra un listado ordenado por compañía de órdenes que incluye los ítems pedidos, su precio y cantidad
BEGIN   
    CALL ListarOrdenes();
END //
DELIMITER ;

CALL ListarOrdenes2();

DROP PROCEDURE IF EXISTS ListarOrdenes2;


-- Información sobre los procedimientos almacenados

SHOW CREATE PROCEDURE ListarOrdenes;
-- Definición de procedimientos

SHOW PROCEDURE STATUS
WHERE Db = 'LBD2023'; 
-- Todos los procedimientos de todas las BDs

SHOW PROCEDURE STATUS LIKE 'ListarOrdenes'; 
-- Uno en particular


-- Procedimiento con parámetros de entrada

DROP PROCEDURE IF EXISTS ListarOrdenesPorCompania;

DELIMITER //
CREATE PROCEDURE ListarOrdenesPorCompania(pCompania VARCHAR(40), pFechaDesde DATE, pFechaHasta DATE)
-- Si no se especifica una compañía, muestra un listado ordenado por compañía de órdenes que incluye los ítems pedidos, su precio y cantidad entre un rango de fechas
-- Si se especifica una compañía se filtra la información anterior para la misma
BEGIN  
	DECLARE fechaAux DATE;
    IF pFechaDesde > pFechaHasta THEN -- se invierten las fechas
		SET fechaAux = pFechaDesde;
        SET pFechaDesde = pFechaHasta;
        SET pFechaHasta = fechaAux;
    END IF;
	IF pCompania IS NULL THEN -- todas las compañías
		SELECT Ordenes.IDOrden, DATE(Fecha) AS 'Fecha', Compania, Items.IDItem, Items.Nombre, Precio, Cantidad
		FROM Ordenes JOIN Clientes
		ON Ordenes.IDCliente = Clientes.IDCliente
		JOIN Detalles
		ON Ordenes.IDOrden = Detalles.IDOrden
		JOIN Items
		ON Detalles.IDItem = Items.IDItem
        WHERE DATE(Fecha) BETWEEN pFechaDesde AND pFechaHasta
		ORDER BY Compania;    
    ELSE
		SELECT Ordenes.IDOrden, DATE(Fecha) AS 'Fecha', Compania, Items.IDItem, Items.Nombre, Precio, Cantidad
		FROM Ordenes JOIN Clientes
		ON Ordenes.IDCliente = Clientes.IDCliente
		JOIN Detalles
		ON Ordenes.IDOrden = Detalles.IDOrden
		JOIN Items
		ON Detalles.IDItem = Items.IDItem
        WHERE Compania = pCompania AND DATE(Fecha) BETWEEN pFechaDesde AND pFechaHasta;    
	END IF;
END //
DELIMITER ;

CALL ListarOrdenesPorCompania(NULL, '1996-12-20', '1998-04-24'); -- todas las compañías
CALL ListarOrdenesPorCompania('Bottom-Dollar Markets', '1996-12-20', '1998-04-24'); -- sólo Bottom-Dollar Markets
CALL ListarOrdenesPorCompania('Bottom-Dollar Markets', '1998-04-24', '1996-12-20'); -- sólo Bottom-Dollar Markets (fechas invertidas)
CALL ListarOrdenesPorCompania('Bottom-Dollar Markets', '1996-12-20', NULL); -- sólo Bottom-Dollar Markets (fecha nula)


-- Procedimiento con parámetros de salida

DROP PROCEDURE IF EXISTS CantidadDeClientes;

DELIMITER //
CREATE PROCEDURE CantidadDeClientes(OUT pCantidad INT)
-- Devuelve la cantidad de clientes
BEGIN  
	SET pCantidad = (SELECT COUNT(*) FROM Clientes);
END //
DELIMITER ;

CALL CantidadDeClientes(@resultado);
SELECT @resultado AS 'Cantidad de clientes';


-- Mensajes de error con parámetros de salida

DROP PROCEDURE IF EXISTS AltaAlumno;

DELIMITER //
CREATE PROCEDURE AltaAlumno(pDNI INT, pApellidos VARCHAR(40), pNombres VARCHAR(40), pCX CHAR(7), OUT mensaje VARCHAR(100))
-- Crea un alumno siempre y cuando no haya otro con el mismo DNI y/o CX
-- La cláusula LEAVE permite salir del flujo de control que tiene la etiqueta dada
-- Si la etiqueta es para el bloque más externo, se puede salir de todo el procedimiento.
SALIR: BEGIN  
	IF (pDNI IS NULL) OR (pApellidos IS NULL) OR (pNombres IS NULL) OR (pCX IS NULL) THEN
		SET mensaje = 'Error en los datos del alumno';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT * FROM Personas WHERE dni = pDNI) THEN
		SET mensaje = 'Ya existe una persona con ese DNI';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT * FROM Alumnos WHERE cx = pCX) THEN
		SET mensaje = 'Ya existe un alumno con ese CX';
        LEAVE SALIR;
	ELSE
		START TRANSACTION;
			INSERT INTO Personas VALUES (pDNI, pApellidos, pNombres);
			INSERT INTO Alumnos VALUES (pDNI, pCX);
            SET mensaje = 'Alumno creado con éxito';
		COMMIT;		
    END IF;
END //
DELIMITER ;

CALL AltaAlumno(111, 'Apellido111', 'Nombre111', '111', @resultado); -- funciona
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Alumnos;

CALL AltaAlumno(NULL, 'Apellido', 'Nombre', '100', @resultado); -- no genera un error la llamada con estos valores
SELECT @resultado; -- hay que revisar el valor del parámetro de salida
SELECT * FROM Alumnos;

DELETE FROM Alumnos WHERE dni = 111;
DELETE FROM Personas WHERE dni = 111;


-- Mensajes de error con código de error (1)

DROP PROCEDURE IF EXISTS AltaAlumno;

DELIMITER //
CREATE PROCEDURE AltaAlumno(pDNI INT, pApellidos VARCHAR(40), pNombres VARCHAR(40), pCX CHAR(7))
-- Crea un alumno siempre y cuando no haya otro con el mismo DNI y/o CX
BEGIN  
	IF (pDNI IS NULL) OR (pApellidos IS NULL) OR (pNombres IS NULL) OR (pCX IS NULL) THEN
		SIGNAL SQLSTATE '45000';
	ELSEIF EXISTS (SELECT * FROM Personas WHERE dni = pDNI) THEN
		SIGNAL SQLSTATE '45001';
	ELSEIF EXISTS (SELECT * FROM Alumnos WHERE cx = pCX) THEN
		SIGNAL SQLSTATE '45002';
	ELSE
		START TRANSACTION;
			INSERT INTO Personas VALUES (pDNI, pApellidos, pNombres);
			INSERT INTO Alumnos VALUES (pDNI, pCX);
		COMMIT;		
    END IF;
END //
DELIMITER ;

CALL AltaAlumno(111, 'Apellido111', 'Nombre111', '111'); -- funciona
SELECT * FROM Alumnos;

CALL AltaAlumno(NULL, 'Apellido', 'Nombre', '100'); -- genera el código SQLSTATE 45000
-- Desde Workbench no se puede ver el valor del código SQLSTATE 
-- Para ver el valor del código SQLSTATE, hay que conectarse desde la consola:
-- mysql --user=<usuario> --password <BD>
-- y ejecutar la consulta
CALL AltaAlumno(23518045, 'Apellido', 'Nombre', '111'); -- genera el código SQLSTATE 45001
CALL AltaAlumno(111, 'Apellido', 'Nombre', '0303890'); -- genera el código SQLSTATE 45002

DELETE FROM Alumnos WHERE dni = 111;
DELETE FROM Personas WHERE dni = 111;


-- Mensajes de error con código de error (2)

DROP PROCEDURE IF EXISTS AltaAlumno;

DELIMITER //
CREATE PROCEDURE AltaAlumno(pDNI INT, pApellidos VARCHAR(40), pNombres VARCHAR(40), pCX CHAR(7))
-- Crea un alumno siempre y cuando no haya otro con el mismo DNI y/o CX
BEGIN  
	IF (pDNI IS NULL) OR (pApellidos IS NULL) OR (pNombres IS NULL) OR (pCX IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en los datos del alumno', MYSQL_ERRNO = 45000;
	ELSEIF EXISTS (SELECT * FROM Personas WHERE dni = pDNI) THEN
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Ya existe una persona con ese DNI', MYSQL_ERRNO = 45001;
	ELSEIF EXISTS (SELECT * FROM Alumnos WHERE cx = pCX) THEN
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Ya existe un alumno con ese CX', MYSQL_ERRNO = 45002;
	ELSE
		START TRANSACTION;
			INSERT INTO Personas VALUES (pDNI, pApellidos, pNombres);
			INSERT INTO Alumnos VALUES (pDNI, pCX);
		COMMIT;		
    END IF;
END //
DELIMITER ;

-- El ítem de información, que se puede especificar una única vez en la sentencia SET, puede ser:
	-- CLASS_ORIGIN, SUBCLASS_ORIGIN, MESSAGE_TEXT, MYSQL_ERRNO, CONSTRAINT_CATALOG, CONSTRAINT_SCHEMA, 
	-- CONSTRAINT_NAME, CATALOG_NAME, SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, CURSOR_NAME
-- 	Salvo MYSQL_ERRNO, cuyo valor es un SMALLINT UNSIGNED, el resto son todos VARCHAR(64)

CALL AltaAlumno(111, 'Apellido111', 'Nombre111', '111'); -- funciona
SELECT * FROM Alumnos;

CALL AltaAlumno(NULL, 'Apellido', 'Nombre', '100'); -- genera el código SQLSTATE 45000  y el mensaje correspondiente 
-- (sí se ve desde la consola de Workbench)
CALL AltaAlumno(23518045, 'Apellido', 'Nombre', '111'); -- genera el código SQLSTATE 45001  y el mensaje correspondiente
CALL AltaAlumno(111, 'Apellido', 'Nombre', '0303890'); -- genera el código SQLSTATE 45002  y el mensaje correspondiente

DELETE FROM Alumnos WHERE dni = 111;
DELETE FROM Personas WHERE dni = 111;


-- Mensajes de error con código de error (3)

DROP PROCEDURE IF EXISTS AltaAlumno;

DELIMITER //
CREATE PROCEDURE AltaAlumno(pDNI INT, pApellidos VARCHAR(40), pNombres VARCHAR(40), pCX CHAR(7))
-- Crea un alumno siempre y cuando no haya otro con el mismo DNI y/o CX
BEGIN  
	DECLARE datos_invalidos CONDITION FOR SQLSTATE '45000';
    DECLARE dni_repetido CONDITION FOR SQLSTATE '45001';
    DECLARE cx_repetido CONDITION FOR SQLSTATE '45002';
	IF (pDNI IS NULL) OR (pApellidos IS NULL) OR (pNombres IS NULL) OR (pCX IS NULL) THEN
		SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error en los datos del alumno', MYSQL_ERRNO = 45000;
	ELSEIF EXISTS (SELECT * FROM Personas WHERE dni = pDNI) THEN
		SIGNAL dni_repetido SET MESSAGE_TEXT = 'Ya existe una persona con ese DNI', MYSQL_ERRNO = 45001;
	ELSEIF EXISTS (SELECT * FROM Alumnos WHERE cx = pCX) THEN
		SIGNAL cx_repetido SET MESSAGE_TEXT = 'Ya existe un alumno con ese CX', MYSQL_ERRNO = 45002;
	ELSE
		START TRANSACTION;
			INSERT INTO Personas VALUES (pDNI, pApellidos, pNombres);
			INSERT INTO Alumnos VALUES (pDNI, pCX);
		COMMIT;		
    END IF;
END //
DELIMITER ;

CALL AltaAlumno(111, 'Apellido111', 'Nombre111', '111'); -- funciona
SELECT * FROM Alumnos;

CALL AltaAlumno(NULL, 'Apellido', 'Nombre', '100'); -- genera el código SQLSTATE 45000  y el mensaje correspondiente
CALL AltaAlumno(23518045, 'Apellido', 'Nombre', '111'); -- genera el código SQLSTATE 45001  y el mensaje correspondiente
CALL AltaAlumno(111, 'Apellido', 'Nombre', '0303890'); -- genera el código SQLSTATE 45002  y el mensaje correspondiente

DELETE FROM Alumnos WHERE dni = 111;
DELETE FROM Personas WHERE dni = 111;


-- Trigger de inserción

DROP TABLE IF EXISTS `AuditoriaTrabajos` ;

CREATE TABLE IF NOT EXISTS `AuditoriaTrabajos` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `IDTrabajo` INT NOT NULL,
  `Titulo` VARCHAR(150) NOT NULL,
  `Duracion` INT NOT NULL,
  `FechaPresentacion` DATETIME NOT NULL,
  `FechaAprobacion` DATETIME NOT NULL,
  `FechaFinalizacion` DATETIME NULL,
  `Tipo` CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, M: Modificación)
  `Usuario` VARCHAR(45) NOT NULL,  
  `Maquina` VARCHAR(45) NOT NULL,  
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`ID`)
);

DELIMITER //
CREATE TRIGGER `Trig_Trabajos_Insercion` 
AFTER INSERT ON `Trabajos` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaTrabajos VALUES (
		DEFAULT, 
		NEW.IDTrabajo,
		NEW.Titulo, 
        NEW.Duracion,
        NEW.FechaPresentacion,
        NEW.FechaAprobacion,
        NEW.FechaFinalizacion,
		'I', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
  );
END //
DELIMITER ;
-- USER(): devuelve el usuario actual y la máquina como una cadena. Por ejemplo: 'juan@localhost'
-- SUBSTRING_INDEX(): devuelve una subcadena de la cadena especificada. 
-- En el primer caso, devuelve todo a la izquierda del delimitador '@' ('juan')
-- En el segundo caso devuelve todo a la derecha del delimitador '@' ('localhost')

DELETE FROM Trabajos WHERE idTrabajo = 74;
SELECT * FROM Trabajos;
SELECT * FROM AuditoriaTrabajos;

INSERT INTO Trabajos VALUES(74, 'Sistema automático de reconocimiento de matrículas', 6, '2019-03-15', '2019-03-28', NULL);

SELECT * FROM Trabajos;
SELECT * FROM AuditoriaTrabajos;

DROP TRIGGER IF EXISTS `Trig_Trabajos_Insercion`;


-- Trigger de borrado (1)

DELIMITER //
CREATE TRIGGER `Trig_Trabajos_Borrado` 
AFTER DELETE ON `Trabajos` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaTrabajos VALUES (
		DEFAULT, 
		OLD.IDTrabajo,
		OLD.Titulo, 
        OLD.Duracion,
        OLD.FechaPresentacion,
        OLD.FechaAprobacion,
        OLD.FechaFinalizacion,    
		'B', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
END //
DELIMITER ;

SELECT * FROM Trabajos;

DELETE FROM Trabajos WHERE IDTrabajo = 74;

SELECT * FROM Trabajos; 
SELECT * FROM AuditoriaTrabajos;

DROP TRIGGER IF EXISTS Trig_Trabajos_Borrado;


-- Trigger de borrado (2)

DELIMITER //
CREATE TRIGGER `Trig_AuditoriaTrabajos_Borrado` 
BEFORE DELETE ON `AuditoriaTrabajos` FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: no se puede borrar de la tabla AuditoriaTrabajos';
END //
DELIMITER ;

SELECT * FROM AuditoriaTrabajos;

DELETE FROM AuditoriaTrabajos;

SELECT * FROM AuditoriaTrabajos;

TRUNCATE AuditoriaTrabajos; -- sí borra la tabla
SELECT * FROM AuditoriaTrabajos;

DROP TRIGGER IF EXISTS Trig_AuditoriaTrabajos_Borrado;


-- Trigger de borrado (3)

DELIMITER //
CREATE TRIGGER `Trig_Trabajos_Borrado1` 
AFTER DELETE ON `Trabajos` FOR EACH ROW
BEGIN
	INSERT INTO AuditoriaTrabajos VALUES (
		DEFAULT, 
		OLD.IDTrabajo,
		OLD.Titulo, 
		OLD.Duracion,
        OLD.FechaPresentacion,
        OLD.FechaAprobacion,
        OLD.FechaFinalizacion,
		'B', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER `Trig_Trabajos_Borrado2` 
AFTER DELETE ON `Trabajos` FOR EACH ROW FOLLOWS `Trig_Trabajos_Borrado1`
BEGIN
	SIGNAL SQLSTATE '45000';
END //
DELIMITER ;
-- Como este trigger se ejecuta a continuación del anterior
-- Al generar el código 45000 hace un rollback de lo hecho por el trigger anterior

INSERT INTO Trabajos VALUES(74, 'Sistema automático de reconocimiento de matrículas', 6, '2019-03-15', '2019-03-28', NULL);

SELECT * FROM Trabajos;
SELECT * FROM AuditoriaTrabajos;

DELETE FROM Trabajos WHERE IDTrabajo = 74;

SELECT * FROM Trabajos; 
SELECT * FROM AuditoriaTrabajos;

DROP TRIGGER IF EXISTS Trig_Trabajos_Borrado1;
DROP TRIGGER IF EXISTS Trig_Trabajos_Borrado2;


-- Trigger de modificación

DELIMITER //
CREATE TRIGGER `Trig_Trabajos_Modificacion` 
AFTER UPDATE ON `Trabajos` FOR EACH ROW
BEGIN
	-- valores viejos
	INSERT INTO AuditoriaTrabajos VALUES (
		DEFAULT, 
		OLD.IDTrabajo,
		OLD.Titulo,
        OLD.Duracion,
        OLD.FechaPresentacion,
        OLD.FechaAprobacion,
        OLD.FechaFinalizacion,
		'M', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
    -- valores nuevos
	INSERT INTO AuditoriaTrabajos VALUES (
		DEFAULT, 
		NEW.IDTrabajo,
		NEW.Titulo, 
        NEW.Duracion,
        NEW.FechaPresentacion,
        NEW.FechaAprobacion,
        NEW.FechaFinalizacion,
		'M', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);    
END //
DELIMITER ;

SELECT * FROM Trabajos;

UPDATE Trabajos 
SET FechaFinalizacion = '2019-12-15'
WHERE IDTrabajo = 74;

SELECT * FROM Trabajos; 
SELECT * FROM AuditoriaTrabajos;

DROP TRIGGER IF EXISTS Trig_Trabajos_Modificacion;

DELETE FROM Trabajos WHERE IDTrabajo = 74;


-- Información sobre triggers

SELECT * FROM information_schema.triggers
WHERE TRIGGER_SCHEMA = 'LBD2023';
