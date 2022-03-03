-- Creacion Base de Datos
CREATE DATABASE Viandas_Saludables;

-- Creacion de Tablas
CREATE TABLE TIPOS_DOC (
id_tipo_doc INT IDENTITY(1,1),
tipo VARCHAR(30),
CONSTRAINT pk_tipos_doc PRIMARY KEY (id_tipo_doc)
);

CREATE TABLE BARRIOS (
id_barrio INT IDENTITY(1,1),
nom_barrio VARCHAR(60),
id_localidad INT,
CONSTRAINT pk_barrios PRIMARY KEY (id_barrio)
);

CREATE TABLE LOCALIDADES (
id_localidad INT IDENTITY(1,1),
nom_localidad VARCHAR(60),
id_provincia INT,
CONSTRAINT pk_localidades PRIMARY KEY (id_localidad)
);

CREATE TABLE PROVINCIAS (
id_provincia INT IDENTITY(1,1),
nom_provincia VARCHAR(60),
CONSTRAINT pk_provincias PRIMARY KEY (id_provincia)
);

CREATE TABLE CLIENTES (
id_cliente INT IDENTITY(1,1),
nom_cliente VARCHAR(60),
apellido_cliente VARCHAR(60),
id_tipo_doc INT,
nro_doc BIGINT,
id_domicilio INT,
telefono VARCHAR(30),
email VARCHAR(30),
fecha_nac DATE,
CONSTRAINT pk_clientes PRIMARY KEY (id_cliente)
);

CREATE TABLE TIPOS_ENTREGAS (
id_tipo_entrega INT IDENTITY(1,1),
tipo_entrega VARCHAR(30),
monto_recarga DECIMAL(6,2),
CONSTRAINT pk_tipos_entregas PRIMARY KEY (id_tipo_entrega)
);

CREATE TABLE DOMICILIOS (
id_domicilio INT IDENTITY(1,1),
calle VARCHAR(60),
nro BIGINT,
piso INT,
departamento VARCHAR(5),
id_barrio INT,
CONSTRAINT pk_domicilios PRIMARY KEY (id_domicilio)
);

CREATE TABLE FORMAS_PAGO (
id_forma_pago INT IDENTITY(1,1),
forma_pago VARCHAR(30),
CONSTRAINT pk_formas_pago PRIMARY KEY (id_forma_pago)
);

CREATE TABLE PEDIDOS_FORMAS_PAGO (
id_pedido INT,
id_forma_pago INT,
CONSTRAINT pk_pedidos_formas_pago PRIMARY KEY (id_pedido, id_forma_pago)
);

CREATE TABLE PEDIDOS (
id_pedido INT IDENTITY(1,1),
fecha_pedido DATE,
fecha_entrega DATE,
hora_entrega TIME,
id_cliente INT,
id_domicilio INT,
id_tipo_entrega INT,
id_tipo_com INT,
CONSTRAINT pk_pedidos PRIMARY KEY (id_pedido)
);

CREATE TABLE PROVEEDORES (
id_proveedor INT IDENTITY(1,1),
nom_proveedor VARCHAR(60),
razon_social VARCHAR(60),
id_domicilio INT,
email VARCHAR(30),
telefono VARCHAR(30),
CONSTRAINT pk_proveedores PRIMARY KEY (id_proveedor)
);

CREATE TABLE MENUS (
id_menu INT IDENTITY(1,1),
id_tipo_dieta INT,
id_comida INT,
precio DECIMAL(6,2),
CONSTRAINT pk_menus PRIMARY KEY (id_menu)
);

CREATE TABLE TIPOS_DIETAS (
id_tipo_dieta INT IDENTITY(1,1),
tipo_dieta VARCHAR(30),
CONSTRAINT pk_tipos_dietas PRIMARY KEY (id_tipo_dieta)
);

CREATE TABLE DETALLES_PEDIDOS (
id_detalle INT IDENTITY(1,1),
cantidad INT,
id_menu INT,
id_pedido INT,
precio_unit DECIMAL(6,2),
CONSTRAINT pk_detalles_pedidos PRIMARY KEY (id_detalle)
);

CREATE TABLE TIPOS_COMUNICACIONES (
id_tipo_com INT IDENTITY(1,1),
tipo_comunicacion VARCHAR(30),
CONSTRAINT pk_tipos_comunicaciones PRIMARY KEY (id_tipo_com)
);

CREATE TABLE COMIDAS (
id_comida INT IDENTITY(1,1),
nom_comida VARCHAR(60),
descripcion VARCHAR(120),
CONSTRAINT pk_comidas PRIMARY KEY (id_comida)
);

CREATE TABLE COMIDAS_INGREDIENTES (
id_comida INT,
id_ingrediente INT,
gramaje DECIMAL(5,3),
id_unidad_medida INT,
CONSTRAINT pk_comidas_ingredientes PRIMARY KEY (id_comida, id_ingrediente)
);

CREATE TABLE UNIDADES_MEDIDAS (
id_unidad_medida INT IDENTITY(1,1),
unidad_medida VARCHAR(15),
CONSTRAINT pk_unidades_medidas PRIMARY KEY (id_unidad_medida)
);

CREATE TABLE INGREDIENTES (
id_ingrediente INT IDENTITY(1,1),
nom_ingrediente VARCHAR(60),
id_tipo_ingrediente INT,
id_marca INT,
id_origen INT,
CONSTRAINT pk_ingredientes PRIMARY KEY (id_ingrediente)
);

CREATE TABLE INGREDIENTES_PROVEEDORES (
id_ingrediente INT,
id_proveedor INT,
CONSTRAINT pk_ingredientes_proveedores PRIMARY KEY (id_ingrediente, id_proveedor)
);

CREATE TABLE TIPOS_INGREDIENTES (
id_tipo_ingrediente INT IDENTITY(1,1),
tipo_ingrediente VARCHAR(60),
descripcion VARCHAR(120),
CONSTRAINT pk_tipos_ingredientes PRIMARY KEY (id_tipo_ingrediente)
);

CREATE TABLE MARCAS (
id_marca INT IDENTITY(1,1),
nom_marca VARCHAR(60),
CONSTRAINT pk_marcas PRIMARY KEY (id_marca)
);

CREATE TABLE ORIGENES (
id_origen INT IDENTITY(1,1),
nom_origen VARCHAR(60),
CONSTRAINT pk_origenes PRIMARY KEY (id_origen)
);

-- Agregar las FK
ALTER TABLE BARRIOS
ADD CONSTRAINT fk_barrios FOREIGN KEY (id_localidad)
REFERENCES LOCALIDADES(id_localidad);

ALTER TABLE LOCALIDADES
ADD CONSTRAINT fk_localidades FOREIGN KEY (id_provincia)
REFERENCES PROVINCIAS(id_provincia);

ALTER TABLE CLIENTES 
ADD CONSTRAINT fk_clientes_tipos_documentos FOREIGN KEY (id_tipo_doc)
REFERENCES TIPOS_DOC(id_tipo_doc);

ALTER TABLE CLIENTES 
ADD CONSTRAINT fk_clientes_domicilios FOREIGN KEY (id_domicilio)
REFERENCES DOMICILIOS(id_domicilio);

ALTER TABLE DOMICILIOS
ADD CONSTRAINT fk_domicilios_barrios FOREIGN KEY (id_barrio)
REFERENCES BARRIOS(id_barrio);

ALTER TABLE PEDIDOS_FORMAS_PAGO
ADD CONSTRAINT fk_pedidos_formas_pago_pedidos FOREIGN KEY (id_pedido)
REFERENCES PEDIDOS(id_pedido);

ALTER TABLE PEDIDOS_FORMAS_PAGO
ADD CONSTRAINT fk_pedidos_formas_pago_formas_pago FOREIGN KEY (id_forma_pago)
REFERENCES FORMAS_PAGO(id_forma_pago);

ALTER TABLE PEDIDOS
ADD CONSTRAINT fk_pedidos_clientes FOREIGN KEY (id_cliente)
REFERENCES CLIENTES(id_cliente);

ALTER TABLE PEDIDOS
ADD CONSTRAINT fk_pedidos_domicilios FOREIGN KEY (id_domicilio)
REFERENCES DOMICILIOS(id_domicilio);

ALTER TABLE PEDIDOS
ADD CONSTRAINT fk_pedidos_entregas FOREIGN KEY (id_tipo_entrega)
REFERENCES TIPOS_ENTREGAS(id_tipo_entrega);

ALTER TABLE PEDIDOS
ADD CONSTRAINT fk_pedidos_tipos_comunicacion FOREIGN KEY (id_tipo_com)
REFERENCES TIPOS_COMUNICACIONES(id_tipo_com);

ALTER TABLE PROVEEDORES
ADD CONSTRAINT fk_proveedores_domicilios FOREIGN KEY (id_domicilio)
REFERENCES DOMICILIOS(id_domicilio);

ALTER TABLE MENUS
ADD CONSTRAINT fk_menus_tipos_dietas FOREIGN KEY (id_tipo_dieta)
REFERENCES TIPOS_DIETAS(id_tipo_dieta);

ALTER TABLE MENUS
ADD CONSTRAINT fk_menus_comidas FOREIGN KEY (id_comida)
REFERENCES COMIDAS(id_comida);

ALTER TABLE DETALLES_PEDIDOS
ADD CONSTRAINT fk_detalles_pedidos_menus FOREIGN KEY (id_menu)
REFERENCES MENUS(id_menu);

ALTER TABLE DETALLES_PEDIDOS
ADD CONSTRAINT fk_detalles_pedidos_pedidos FOREIGN KEY (id_pedido)
REFERENCES PEDIDOS(id_pedido);

ALTER TABLE COMIDAS_INGREDIENTES
ADD CONSTRAINT fk_comidas_ingredientes_comidas FOREIGN KEY (id_comida)
REFERENCES COMIDAS(id_comida);

ALTER TABLE COMIDAS_INGREDIENTES
ADD CONSTRAINT fk_comidas_ingredientes_ingredientes FOREIGN KEY (id_ingrediente)
REFERENCES INGREDIENTES(id_ingrediente);

ALTER TABLE COMIDAS_INGREDIENTES
ADD CONSTRAINT fk_comidas_ingredientes_unidades_medidas FOREIGN KEY (id_unidad_medida)
REFERENCES UNIDADES_MEDIDAS(id_unidad_medida);

ALTER TABLE INGREDIENTES
ADD CONSTRAINT fk_ingredientes_tipos_ingredientes FOREIGN KEY (id_tipo_ingrediente)
REFERENCES TIPOS_INGREDIENTES(id_tipo_ingrediente);

ALTER TABLE INGREDIENTES
ADD CONSTRAINT fk_ingredientes_marcas FOREIGN KEY (id_marca)
REFERENCES MARCAS(id_marca);

ALTER TABLE INGREDIENTES
ADD CONSTRAINT fk_ingredientes_origenes FOREIGN KEY (id_origen)
REFERENCES ORIGENES(id_origen);

ALTER TABLE INGREDIENTES_PROVEEDORES
ADD CONSTRAINT fk_ingredientes_proveedores FOREIGN KEY (id_ingrediente)
REFERENCES INGREDIENTES(id_ingrediente);

ALTER TABLE INGREDIENTES_PROVEEDORES
ADD CONSTRAINT fk_ingredientes_proveedores_proveedor FOREIGN KEY (id_proveedor)
REFERENCES PROVEEDORES(id_proveedor);

