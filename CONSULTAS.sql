USE Viandas_Saludables
SET DATEFORMAT DMY;



--Nombre y Apellido de clientes que pidieron menues con tipo de dieta proteica y detox,
--y que se entregaron desde hace 4 meses, ordenado por apellido.
SELECT C.nom_cliente + ', ' + C.apellido_cliente 'CLIENTE',
		TP.tipo_dieta 'DIETA', P.fecha_entrega 'FECHA DE ENTREGA'
	FROM CLIENTES C
	INNER JOIN PEDIDOS P ON C.id_cliente = P.id_cliente
	INNER JOIN DETALLES_PEDIDOS DP ON P.id_pedido = DP.id_pedido
	INNER JOIN MENUS M ON DP.id_menu = M.id_menu
	INNER JOIN TIPOS_DIETAS TP ON M.id_tipo_dieta = TP.id_tipo_dieta
	WHERE TP.tipo_dieta IN ('PROTEICA', 'DETOX')
	AND YEAR(P.fecha_entrega)= YEAR(GETDATE())
	AND MONTH(P.fecha_entrega) BETWEEN MONTH(GETDATE())-4 AND MONTH(GETDATE())
	ORDER BY C.apellido_cliente ASC


--Nombre de proveedores que venden tipo de ingredientes "Mantecas y aceites",
--de marca milkaut o la serenisima, ordenados por proveedor

SELECT PR.nom_proveedor 'PROVEEDOR', 
	   I.nom_ingrediente 'INGREDIENTE',
	   M.nom_marca 'MARCA',TI.descripcion 'DESCRIPCION'
	FROM PROVEEDORES PR
	INNER JOIN INGREDIENTES_PROVEEDORES IPR ON PR.id_proveedor = IPR.id_proveedor
	INNER JOIN INGREDIENTES I ON IPR.id_ingrediente = I.id_ingrediente
	INNER JOIN MARCAS M ON I.id_marca = M.id_marca
	INNER JOIN TIPOS_INGREDIENTES TI ON I.id_tipo_ingrediente = TI.id_tipo_ingrediente
	WHERE (M.nom_marca IN ('Milkaut','La Serenisima'))
	AND (TI.tipo_ingrediente = 'Grupo 7')
	ORDER BY PR.nom_proveedor ASC


--Pedidos de menúes de "Tartas" y "Fideos con queso" realizados durante los ultimos 2 años hasta hoy, 
--con medios de pago en efectivo o con tarjeta de debito o credito, ordenado por fecha de pedido en forma descendente

SELECT P.fecha_pedido 'FECHA PEDIDO', 
	   FP.forma_pago 'FORMA DE PAGO',
	   CO.nom_comida 'COMIDA'
	FROM PEDIDOS P
	INNER JOIN PEDIDOS_FORMAS_PAGO PEFP ON P.id_pedido = PEFP.id_pedido
	INNER JOIN FORMAS_PAGO FP ON PEFP.id_forma_pago = FP.id_forma_pago
	INNER JOIN DETALLES_PEDIDOS DP ON P.id_pedido = DP.id_pedido
	INNER JOIN MENUS M ON DP.id_menu = M.id_menu
	INNER JOIN COMIDAS CO ON M.id_comida = CO.id_comida
	WHERE (YEAR(P.fecha_pedido) BETWEEN YEAR(GETDATE())-2 AND YEAR(GETDATE()))
	AND (FP.forma_pago IN ('Efectivo','Tarjeta de Debito','Tarjeta de Credito'))
	AND (CO.nom_comida IN ('Fideos con queso','Tarta'))
	ORDER BY P.fecha_pedido DESC


/*Se quiere saber los pedidos de este año que se entregaron en fecha diferente a
la del pedido, con los días que demoró la entrega, la hora de entrega, el
nombre del cliente, el tipo de entrega, el tipo de comunicación, el menú, la
comida y la cantidad comprada. Ordenado por los días que demoró, de mayor a menor.*/
SELECT P.id_pedido 'Nro de Pedido',
	C.apellido_cliente + ' ' + c.nom_cliente 'Cliente',
	P.fecha_pedido 'Fecha del Pedido', P.fecha_entrega 'Fecha de Entrega',
	DATEDIFF(day, P.fecha_pedido, P.fecha_entrega) 'Días que demoró el pedido',
	P.hora_entrega 'Hora de Entrega', ENT.tipo_entrega 'Entrega', COM.tipo_comunicacion 'Comunicación', 
	M.id_menu 'Menú', CO.nom_comida 'Comida', DP.cantidad 'Cantidad'
FROM PEDIDOS P INNER JOIN CLIENTES C ON P.id_cliente = C.id_cliente
	INNER JOIN TIPOS_ENTREGAS ENT ON ENT.id_tipo_entrega = P.id_tipo_entrega
	INNER JOIN TIPOS_COMUNICACIONES COM ON COM.id_tipo_com = P.id_tipo_com
	INNER JOIN DETALLES_PEDIDOS DP ON DP.id_pedido = P.id_pedido
	INNER JOIN MENUS M ON DP.id_menu = M.id_menu
	INNER JOIN COMIDAS CO ON CO.id_comida = M.id_menu
WHERE P.fecha_pedido != P.fecha_entrega
AND year(P.fecha_pedido) = year(GETDATE())
ORDER BY 'Días que demoró el pedido' DESC;
 

/*Mostrar qué menús y comidas (con su tipo de dieta) se vendieron el mes
pasado. Los que más cantidad se vendieron primero. Mostrar la fecha en que
se vendieron.*/
SELECT m.id_menu 'Nro de Menu', td.tipo_dieta 'Tipo de Dieta',
		c.nom_comida 'Comida', dp.cantidad 'Cantidad', p.fecha_pedido 'Fecha del Pedido'
	FROM DETALLES_PEDIDOS dp
	INNER JOIN MENUS m ON m.id_menu = dp.id_menu
	INNER JOIN TIPOS_DIETAS td ON td.id_tipo_dieta = m.id_tipo_dieta
	INNER JOIN COMIDAS c ON c.id_comida = m.id_comida
	INNER JOIN PEDIDOS p ON p.id_pedido = dp.id_pedido
	WHERE month(p.fecha_pedido) = month(GETDATE())-1
	AND year(p.fecha_pedido) = year(GETDATE())
	ORDER BY 'Cantidad' DESC;


/*Mostrar el subtotal de las ventas (cantidad x precio) de este mes de mayor a
menor, solo de los clientes cuyo apellido empiecen con P.*/
SELECT c.apellido_cliente + ' ' + c.nom_cliente 'Cliente',
		dp.cantidad * dp.precio_unit 'Subtotal', p.fecha_pedido 'Fecha'
	FROM DETALLES_PEDIDOS dp
	JOIN PEDIDOS p ON p.id_pedido = dp.id_pedido
	JOIN CLIENTES c ON c.id_cliente = p.id_cliente
	WHERE c.apellido_cliente LIKE 'P%'
	AND MONTH(p.fecha_pedido)=MONTH(GETDATE())
	AND YEAR(p.fecha_pedido)=YEAR(GETDATE())
	ORDER BY 'Subtotal' DESC;


/*¿Qué comidas llevan más de 200 gramos de harina? Mostrar la comida y la
cantidad de harina con su unidad.*/
SELECT c.nom_comida 'Comida', i.nom_ingrediente 'Ingrediente', ci.gramaje, um.unidad_medida
	FROM COMIDAS_INGREDIENTES ci
	INNER JOIN COMIDAS c ON c.id_comida = ci.id_comida
	INNER JOIN INGREDIENTES i ON i.id_ingrediente = ci.id_ingrediente
	INNER JOIN UNIDADES_MEDIDAS um ON um.id_unidad_medida = ci.id_unidad_medida
	WHERE i.nom_ingrediente = 'Harina'
	AND ci.gramaje >200;


/*Mostrar a todos los clientes, hayan o no comprado alguna vez, y mostrar la
fecha del pedido de aquellos que compraron en diciembre del año pasado,
con la hora de entrega. Mostrar estos últimos primero.*/
SELECT c.id_cliente 'ID cliente', c.apellido_cliente + ' '+ c.nom_cliente 'Cliente',
		p.fecha_pedido 'Fecha de Pedido', p.hora_entrega 'Hora de Entrega'
	FROM CLIENTES c
	LEFT JOIN PEDIDOS p ON p.id_cliente = c.id_cliente
	AND MONTH(p.fecha_pedido) = 12
	AND YEAR(p.fecha_pedido) =YEAR(GETDATE())-1
	ORDER BY 'Fecha de Pedido' DESC, 'ID cliente';


/*Según un informe de senasa se detectó varios caso de Listeria monocytogenes
en la Empresa SANCOR. Nos solicitan el nombre apellido, nombre,número
tel email de clientes y fecha de entrega de pedido , los cuales contengan leche
o que tengan algún ingrediente marca sancor y además se hayan entregado
entre abril de 2018 y mayo de 2019.*/
SELECT c.apellido_cliente'Apellido', c.nom_cliente'Nombre', c.telefono'Telefono',
		c.email'Correo electronico', p.fecha_entrega 'Fecha de entrega de pedido'
	FROM CLIENTES c
	INNER JOIN PEDIDOS p ON c.id_cliente = p.id_cliente
	INNER JOIN DETALLES_PEDIDOS d ON d.id_pedido = p.id_pedido
	INNER JOIN MENUS m ON m.id_menu = d.id_menu
	INNER JOIN COMIDAS co ON co.id_comida= m.id_comida
	INNER JOIN COMIDAS_INGREDIENTES ci ON ci.id_comida = co.id_comida
	INNER JOIN INGREDIENTES i ON i.id_ingrediente = ci.id_ingrediente
	INNER JOIN TIPOS_INGREDIENTES t ON t.id_tipo_ingrediente = i.id_tipo_ingrediente
	INNER JOIN MARCAS ma ON ma.id_marca = i.id_marca
	WHERE (i.nom_ingrediente = 'Leche' OR ma.nom_marca='Sancor')
	AND (p.fecha_entrega between '01/05/2018' AND '01/05/2019')
	ORDER BY 1 ASC;

/*La empresa decidió realizar una campaña de marketing, donde se envía
cupones de descuento %60 a aquellos clientes que su nombre contengan g en
el nombre y apellido o hayan comprado algún producto de dieta hipocalórica y pagado en efectivo.
Listar el nombre,apellido, teléfono y correo del cliente, método de pago y tipo de dieta*/
SELECT c.apellido_cliente 'Apellido', c.nom_cliente'Nombre',
		c.telefono'Teléfono', c.email'Correo electrónico',
		f.forma_pago 'Metodo de pago', t.tipo_dieta 'Tipo de Dieta'
	FROM CLIENTES c
	INNER JOIN PEDIDOS p ON c.id_cliente = p.id_cliente
	INNER JOIN DETALLES_PEDIDOS d ON d.id_pedido = p.id_pedido
	INNER JOIN MENUS m ON m.id_menu = d.id_menu
	INNER JOIN TIPOS_DIETAS t ON t.id_tipo_dieta = m.id_tipo_dieta
	INNER JOIN PEDIDOS_FORMAS_PAGO pe ON pe.id_pedido = p.id_pedido
	INNER JOIN FORMAS_PAGO f ON f.id_forma_pago = pe.id_forma_pago
	WHERE (c.apellido_cliente LIKE '%G%' AND c.nom_cliente LIKE '%G%')
	OR (t.tipo_dieta = 'Hipocalórica' AND f.forma_pago = 'Efectivo')
	ORDER BY 1, 2;


/*Mostrar nombre, teléfono y fecha de nacimiento de todos aquellos clientes
que hayan pedido por whatsapp , vivan en Nueva Córdoba entre las alturas
400 y 1000 en este año. Ordenado por Fecha de Nacimiento.*/
SELECT c.telefono 'Teléfono', c.nom_cliente + ' ' + c.apellido_cliente 'Nombre Completo',
		c.fecha_nac 'Fecha Nacimiento'
	FROM TIPOS_COMUNICACIONES tc
	INNER JOIN PEDIDOS p on tc.id_tipo_com = p.id_tipo_com
	INNER JOIN CLIENTES c on p.id_cliente = c.id_cliente
	INNER JOIN DOMICILIOS d on c.id_domicilio = d.id_domicilio
	INNER JOIN BARRIOS b on d.id_barrio = b.id_barrio
	WHERE YEAR(p.fecha_pedido) = YEAR(Getdate())
	AND tc.tipo_comunicacion = 'WhatsApp'
	AND b.nom_barrio = 'Barrio Nueva Córdoba'
	AND d.nro between 400 and 1000
	ORDER BY 'Fecha Nacimiento';
	SELECT * FROM MENUS 

-------------------------------------------------------------------------------
select * from DETALLES_PEDIDOS
SELECT * FROM TIPOS_DOC
SELECT * FROM PROVINCIAS
SELECT * FROM LOCALIDADES
SELECT * FROM BARRIOS
SELECT * FROM TIPOS_ENTREGAS
SELECT * FROM TIPOS_DIETAS
SELECT * FROM COMIDAS
SELECT * FROM UNIDADES_MEDIDAS
SELECT * FROM TIPOS_INGREDIENTES
SELECT * FROM MARCAS
SELECT * FROM ORIGENES
SELECT * FROM COMIDAS
SELECT * FROM TIPOS_COMUNICACIONES
SELECT * FROM INGREDIENTES
SELECT * FROM DOMICILIOS
SELECT * FROM CLIENTES
SELECT * FROM PROVEEDORES
SELECT * FROM PEDIDOS
SELECT * FROM PEDIDOS_FORMAS_PAGO
SELECT * FROM INGREDIENTES_PROVEEDORES
SELECT * FROM DETALLES_PEDIDOS
SELECT * FROM COMIDAS_INGREDIENTES
select * from FORMAS_PAGO