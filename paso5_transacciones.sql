-- Paso 5: Transacciones y Concurrencia

-- Preparación
CREATE TABLE cuenta_bancaria (
    id      NUMBER PRIMARY KEY,
    titular VARCHAR2(50),
    saldo   NUMBER(10,2)
);
INSERT INTO cuenta_bancaria VALUES (1, 'Usuario A', 1000);
INSERT INTO cuenta_bancaria VALUES (2, 'Usuario B', 2000);
COMMIT;



-- -------------------------------------------------------
-- Escenario 1: Atomicidad
-- -------------------------------------------------------
-- Escenario 1: Atomicidad

-- Paso 1: Restar 500€ de la cuenta 1
UPDATE cuenta_bancaria SET saldo = saldo - 500 WHERE id = 1;

-- Paso 2: Intentar sumar 500€ a cuenta inexistente
UPDATE cuenta_bancaria SET saldo = saldo + 500 WHERE id = 99;

-- Verificación: la cuenta 1 tiene 500€ pero nadie recibió nada
SELECT * FROM cuenta_bancaria;

-- Restaurar la integridad
ROLLBACK;

-- Verificación tras ROLLBACK: la cuenta 1 vuelve a 1000€
SELECT * FROM cuenta_bancaria;

-- -------------------------------------------------------
-- Escenario 2: Savepoints
-- -------------------------------------------------------
UPDATE cuenta_bancaria SET saldo = saldo * 1.10;
SAVEPOINT sp_subida;

INSERT INTO cuenta_bancaria VALUES (3, 'Usuario C', 500);
SAVEPOINT sp_nuevo_usuario;

DELETE FROM cuenta_bancaria;

ROLLBACK TO SAVEPOINT sp_nuevo_usuario;

SELECT * FROM cuenta_bancaria;

-- -------------------------------------------------------
-- Escenario 3: Bloqueos (ejecutar en dos terminales)
-- -------------------------------------------------------
-- T1:
UPDATE cuenta_bancaria SET saldo = 0 WHERE id = 1;
-- (sin COMMIT)

-- T2:
UPDATE cuenta_bancaria SET saldo = 5000 WHERE id = 1;
-- T2 queda bloqueada esperando a T1

-- T1:
COMMIT;
-- T2 se desbloquea y aplica su UPDATE

-- -------------------------------------------------------
-- Escenario 4: Commit Fantasma (DDL)
-- -------------------------------------------------------
DELETE FROM cuenta_bancaria WHERE id = 2;

CREATE TABLE log_errores (msg VARCHAR2(100));

ROLLBACK;

SELECT * FROM cuenta_bancaria;
