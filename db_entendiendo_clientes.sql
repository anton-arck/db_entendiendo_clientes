#Desafio evaluado entendiendo a nuestros clientes
\set AUTOCOMMIT off
\echo :AUTOCOMMIT
-----------Punto 1---------------
psql -U postgres db_entendiendo_cliente < /tmp/carga_db/unidad2.sql

-----------Punto 2---------------
--Revisar si existe una compra para la fecha pedida
SELECT cliente.nombre, cliente.email, compra.fecha, detalle_compra.cantidad, producto.descripcion, producto.stock, producto.precio
FROM cliente
LEFT JOIN compra ON cliente.id = compra.cliente_id
LEFT JOIN detalle_compra ON compra.id = detalle_compra.compra_id
LEFT JOIN producto ON detalle_compra.producto_id = producto.id 
WHERE cliente.nombre = 'usuario01'
AND producto.descripcion = 'producto9'
AND detalle_compra.cantidad = 5
AND compra.fecha = CURRENT_DATE;
COMMIT;  
--Revisar stock produco9
SELECT * FROM producto WHERE descripcion = 'producto9';
COMMIT;
--Insertar compra
BEGIN;
INSERT INTO compra (cliente_id, fecha) SELECT id, CURRENT_DATE FROM cliente WHERE nombre = 'usuario01';
INSERT INTO detalle_compra (producto_id,compra_id, cantidad) SELECT id, CURRVAL('compra_id_seq'),5 FROM producto 
WHERE descripcion = 'producto9'; 
UPDATE producto SET stock = stock - 5 WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto9');
COMMIT;
--Revisar detalle de compra
SELECT cliente.nombre, cliente.email, compra.fecha, detalle_compra.cantidad, producto.descripcion, producto.stock, producto.precio
FROM cliente 
LEFT JOIN compra ON cliente.id = compra.cliente_id
LEFT JOIN detalle_compra ON compra.id = detalle_compra.compra_id
LEFT JOIN producto ON detalle_compra.producto_id = producto.id 
WHERE cliente.nombre = 'usuario01'
AND producto.descripcion = 'producto9'
AND detalle_compra.cantidad = 5
AND compra.fecha = CURRENT_DATE;
COMMIT;

----------Punto 3-------------
--Insertar la compra de los 3 articulos
SELECT cliente.nombre, cliente.email, compra.fecha, detalle_compra.cantidad, producto.descripcion, producto.stock, producto.precio 
FROM cliente LEFT JOIN compra ON cliente.id = compra.cliente_id LEFT JOIN detalle_compra ON compra_id = detalle_compra.compra_id 
LEFT JOIN producto ON detalle_compra.producto_id =producto.id WHERE cliente.nombre = 'usuario02' 
AND producto.descripcion in ('producto1', 'producto2', 'producto8') AND detalle_compra.cantidad = 3 AND compra.fecha = CURRENT_DATE; 
COMMIT;	

BEGIN;
SAVEPOINT  producto1;
INSERT INTO compra (cliente_id, fecha) SELECT id, CURRENT_DATE FROM cliente WHERE nombre = 'usuario02';
INSERT INTO detalle_compra (producto_id,compra_id, cantidad) SELECT id, CURRVAL('compra_id_seq'),3 FROM producto 
WHERE descripcion = 'producto1'; 
UPDATE producto SET stock = stock - 3 WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto1');

--producto2
SAVEPOINT producto2;
INSERT INTO compra (cliente_id, fecha) SELECT id, CURRENT_DATE FROM cliente WHERE nombre = 'usuario02';
INSERT INTO detalle_compra (producto_id,compra_id, cantidad) SELECT id, CURRVAL('compra_id_seq'),3 FROM producto 
WHERE descripcion = 'producto2'; 
UPDATE producto SET stock = stock - 3 WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto2');

--producto8
SAVEPOINT producto8;
INSERT INTO compra (cliente_id, fecha) SELECT id, CURRENT_DATE FROM cliente WHERE nombre = 'usuario02';
INSERT INTO detalle_compra (producto_id,compra_id, cantidad) SELECT id, CURRVAL('compra_id_seq'),3 FROM producto 
WHERE descripcion = 'producto8'; 
UPDATE producto SET stock = stock - 3 WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto8');

COMMIT;

SELECT cliente.nombre, cliente.email, compra.fecha, detalle_compra.cantidad, producto.descripcion, producto.stock, producto.precio 
FROM cliente LEFT JOIN compra ON cliente.id = compra.cliente_id LEFT JOIN detalle_compra ON compra_id = detalle_compra.compra_id 
LEFT JOIN producto ON detalle_compra.producto_id =producto.id WHERE cliente.nombre = 'usuario02' 
AND producto.descripcion in ('producto1', 'producto2', 'producto8') AND detalle_compra.cantidad = 3 AND compra.fecha = CURRENT_DATE; 
COMMIT;
--Punto 4--
--a--
\set AUTOCOMMIT off
\echo :AUTOCOMMIT
--b--
INSERT INTO cliente(id,nombre,email) VALUES (DEFAULT,'pedro','pedro@yahoo.es');
--c--
SELECT * FROM cliente WHERE NOMBRE='pedro';
--d--
ROLLBACK;
--e--
SELECT * FROM cliente WHERE nombre = 'pedro';
COMMIT;
--f--
\set AUTOCOMMIT on
\echo :AUTOCOMMIT
