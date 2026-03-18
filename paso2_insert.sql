-- Paso 2: Bloque de Inserción (INSERT)

-- 1. Simple
INSERT INTO productos_u4 (product_id, product_name, list_price)
VALUES (7000, 'Cable HDMI 2.1', 25);

-- 2. Columnas específicas
INSERT INTO productos_u4 (product_id, product_name, category_id)
VALUES (7001, 'Hub USB-C', 10);

-- 3. Uso de Nulos
INSERT INTO productos_u4 (product_id, product_name, product_description,
                           category_id, weight_class, warranty_period,
                           supplier_id, product_status, list_price,
                           min_price, catalog_url)
VALUES (7002, 'Producto Nulo Test', NULL,
        10, 1, NULL,
        NULL, 'available', 99,
        50, NULL);

-- 4. Sintaxis de Fecha con SYSDATE
CREATE TABLE log_inserciones (
    log_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    mensaje   VARCHAR2(200),
    fecha_log DATE DEFAULT SYSDATE
);
INSERT INTO log_inserciones (mensaje)
VALUES ('Inserción de prueba con SYSDATE');

-- 5. Copia de fila
INSERT INTO productos_u4
SELECT 7003, product_name, product_description,
       category_id, weight_class, warranty_period,
       supplier_id, product_status, list_price,
       min_price, catalog_url
FROM productos_u4
WHERE product_id = 1797;

-- 6. Inserción Masiva
INSERT INTO productos_u4
SELECT * FROM OE.PRODUCT_INFORMATION
WHERE list_price > 5000;

-- 7. Subconsulta con Filtro
INSERT INTO productos_u4
SELECT * FROM OE.PRODUCT_INFORMATION pi
WHERE pi.category_id = 11
  AND pi.product_id NOT IN (SELECT product_id FROM productos_u4);

-- 8. Carga Parcial
INSERT INTO productos_u4 (product_id, product_name)
SELECT DISTINCT pi.product_id, pi.product_name
FROM OE.PRODUCT_INFORMATION pi
JOIN OE.INVENTORIES inv ON pi.product_id = inv.product_id
WHERE inv.warehouse_id = 1
  AND pi.product_id NOT IN (SELECT product_id FROM productos_u4);

-- 9. Cálculo en Inserción
INSERT INTO productos_u4 (product_id, product_name, category_id, list_price)
VALUES (
    7005,
    'Producto Precio Calculado',
    10,
    (SELECT AVG(list_price) * 2 FROM productos_u4 WHERE category_id = 10)
);

-- 10. Multitabla
CREATE TABLE precios_altos AS SELECT * FROM productos_u4 WHERE 1=0;
INSERT INTO precios_altos
SELECT * FROM productos_u4
WHERE list_price > 1000;

COMMIT;