-- Paso 4: Bloque de Borrado (DELETE)

-- 1. ID Específico
DELETE FROM productos_u4 WHERE product_id = 7000;

-- 2. Filtro de Texto
DELETE FROM productos_u4 WHERE product_description LIKE '%Test%';

-- 3. Rango Numérico
DELETE FROM productos_u4 WHERE list_price BETWEEN 0 AND 1;

-- 4. Estado y Categoría
DELETE FROM productos_u4
WHERE category_id = 10 AND product_status = 'under development';

-- 5. Sin Inventario
DELETE FROM productos_u4 p
WHERE NOT EXISTS (
    SELECT 1 FROM inventario_u4 i WHERE i.product_id = p.product_id
);

-- 6. Subconsulta de Agregación
DELETE FROM productos_u4
WHERE min_price = (SELECT MIN(min_price) FROM productos_u4);

-- 7. Relacional
DELETE FROM productos_u4 p
WHERE NOT EXISTS (
    SELECT 1 FROM OE.ORDER_ITEMS oi WHERE oi.product_id = p.product_id
);

-- 8. Basado en Almacén
DELETE FROM inventario_u4
WHERE warehouse_id IN (
    SELECT w.warehouse_id
    FROM OE.WAREHOUSES w
    JOIN HR.LOCATIONS l ON w.location_id = l.location_id
    JOIN HR.COUNTRIES c ON l.country_id = c.country_id
    WHERE c.country_name = 'Japan'
);

-- 9. Doble Condición Subquery
DELETE FROM productos_u4
WHERE category_id IN (
    SELECT category_id
    FROM productos_u4
    GROUP BY category_id
    HAVING COUNT(*) < 5
);

-- 10. Limpieza Total
DELETE FROM productos_u4 WHERE product_id BETWEEN 7000 AND 8000;

COMMIT;
