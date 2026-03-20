-- Paso 3: Bloque de Modificación (UPDATE)

-- 1. Directo
UPDATE productos_u4 SET product_status = 'obsolete' WHERE product_id = 1797;

-- 2. Múltiple
UPDATE productos_u4 SET min_price = 50, list_price = 80 WHERE product_id = 7000;

-- 3. Filtro Simple
UPDATE productos_u4 SET list_price = list_price + 10 WHERE category_id = 12;

-- 4. Uso de LIKE
UPDATE productos_u4 SET product_status = 'discontinued'
WHERE product_name LIKE 'Software%';

-- 5. Basado en NULL
UPDATE productos_u4 SET min_price = 5 WHERE min_price IS NULL;

-- 6. Cálculo Porcentual
UPDATE productos_u4 SET list_price = list_price * 0.80 WHERE weight_class = 5;

-- 7. Subconsulta Simple
UPDATE productos_u4
SET list_price = list_price + 100
WHERE category_id = (
    SELECT category_id FROM OE.PRODUCT_CATEGORIES
    WHERE category_name = 'Software/Other'
);

-- 8. Update Correlacionado
UPDATE productos_u4
SET min_price = (
    SELECT MIN(unit_price)
    FROM OE.ORDER_ITEMS
    WHERE product_id = productos_u4.product_id
);

-- 9. Condición de Existencia
UPDATE productos_u4
SET product_status = 'available'
WHERE product_id IN (
    SELECT product_id FROM inventario_u4
);
-- 10. Lógica Compleja
UPDATE productos_u4
SET list_price = list_price * 0.95
WHERE list_price > (SELECT AVG(list_price) FROM productos_u4);


