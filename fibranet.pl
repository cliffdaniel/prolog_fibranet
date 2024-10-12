% Hechos relacionados con la conexion a Internet
tiene(planes, internet).
tiene(planes, caracteristicas).
tiene(planes, cable).
tiene(planes, metodos_de_pago).
tiene(planes, canales).
tiene(internet, conexion).
tiene(internet, velocidad).
tiene(velocidad, simetria).

% Hechos sobre simetria y velocidad
simetria_de(simetria, descarga).
simetria_de(simetria, carga).

% Hechos sobre conexion
conexion_de(conexion, fibra).

% Hechos sobre caracteristicas de los planes (DUOS y precios)
caracteristicas_de(caracteristicas, duos).
duos(50, 80).
duos(80, 110).
duos(100, 130).
duos(150, 150).
duos(500, 500).

% Hechos sobre metodos de pago
metodo_de_pago_por(metodos_de_pago, transferencia).
metodo_de_pago_por(metodos_de_pago, app).
metodo_de_pago_por(metodos_de_pago, agente).

% Hechos sobre canales de television
canales_en(canales, internacional).
canales_en(canales, nacional).
canales_en(canales, exclusivo).

% Hechos sobre perfil del usuario
perfil_usuario(usuario1, preferencias(internet, alta_velocidad)).
perfil_usuario(usuario1, historial_compras([80, 110, 130])).
perfil_usuario(usuario1, demografia(edad, 32)).
perfil_usuario(usuario2, preferencias(internet, baja_velocidad)).
perfil_usuario(usuario2, historial_compras([50, 80])).
perfil_usuario(usuario2, demografia(edad, 25)).

% Hechos sobre productos disponibles
producto_disponible(internet, 'Internet velocidad 50 Mbps', 80).
producto_disponible(internet, 'Internet velocidad 80 Mbps', 110).
producto_disponible(internet, 'Internet velocidad 100 Mbps', 130).
producto_disponible(internet, 'Internet alta velocidad 150 Mbps', 150).
producto_disponible(internet, 'Internet alta velocidad 500 Mbps', 500).

% Hechos sobre ofertas actuales
oferta_disponible('Internet velocidad 80 Mbps', 10).
oferta_disponible('Internet velocidad 100 Mbps', 10).
oferta_disponible('Internet alta velocidad 150 Mbps', 15).
oferta_disponible('Internet alta velocidad 500 Mbps', 20).

% Definiciones de velocidad de productos
velocidad_producto('Internet velocidad 50 Mbps', baja_velocidad).
velocidad_producto('Internet velocidad 80 Mbps', baja_velocidad).
velocidad_producto('Internet velocidad 100 Mbps', baja_velocidad).
velocidad_producto('Internet alta velocidad 150 Mbps', alta_velocidad).
velocidad_producto('Internet alta velocidad 500 Mbps', alta_velocidad).

% Hechos sobre recomendaciones de productos basados en la edad del usuario
recomendacion(0, 17, 'Internet velocidad 50 Mbps', 50).
recomendacion(18, 29, 'Internet velocidad 80 Mbps', 80).
recomendacion(18, 29, 'Internet velocidad 100 Mbps', 130).
recomendacion(30, 100, 'Internet alta velocidad 150 Mbps', 150).
recomendacion(30, 100, 'Internet alta velocidad 500 Mbps', 500).


% Reglas

% Regla 1: Verificar si un plan tiene un DUO especifico con un precio asociado
plan_con_duo(Plan, Precio) :- duos(Plan, Precio).

% Regla 2: Verificar si un metodo de pago esta disponible para un plan
metodo_pago_disponible(Metodo) :- metodo_de_pago_por(metodos_de_pago, Metodo).

% Regla 3: Recomendacion de productos basados en preferencias de usuario y disponibilidad
recomendar_producto(Usuario, Producto, Precio) :-
    perfil_usuario(Usuario, preferencias(internet, alta_velocidad)),
    producto_disponible(internet, Producto, Precio).

% Regla 4: Aplicar ofertas a los productos recomendados
aplicar_oferta(Producto, PrecioConDescuento) :-
    oferta_disponible(Producto, Descuento),
    producto_disponible(internet, Producto, Precio),
    PrecioConDescuento is Precio - (Precio * Descuento / 100).

% Regla 5: Obtener metodos de pago disponibles para un usuario
metodos_de_pago_usuario(Usuario, Metodo) :-
    perfil_usuario(Usuario, _),
    metodo_pago_disponible(Metodo).

% Regla 6: Verificar si un producto especifico tiene una oferta
producto_con_oferta(Producto, PrecioConDescuento) :-
    aplicar_oferta(Producto, PrecioConDescuento).

% Regla 7: Obtener productos en oferta
productos_en_oferta(Producto, PrecioConDescuento) :-
    oferta_disponible(Producto, Descuento),  % Verifica si hay una oferta para el producto
    producto_disponible(internet, Producto, Precio),  % Obtiene el precio del producto
    Precio > 0,  % Asegura que el precio sea positivo
    DiscountMultiplier is (100 - Descuento) / 100,  % Calcula el multiplicador de descuento
    PrecioConDescuento is Precio * DiscountMultiplier.  % Aplica el descuento

% Regla 8: Recomendación de productos según el historial de compras
recomendar_por_historial(Usuario, Producto, Precio) :-
    perfil_usuario(Usuario, historial_compras(Historial)),  % Obtiene el historial de compras del usuario
    member(Precio, Historial),  % Verifica si el precio está en el historial de compras
    producto_disponible(internet, Producto, Precio).  % Revisa si el producto está disponible

% Regla 10: Obtener características de un plan específico
obtener_caracteristicas(Plan, Caracteristica) :-
    caracteristicas_de(caracteristicas, Plan),  % Obtiene las características de un plan específico
    caracteristicas_de(Plan, Caracteristica).  % Asigna la característica a la variable

% Regla 11: Verificar si un canal específico está disponible
canal_disponible(Usuario, Canal) :-
    perfil_usuario(Usuario, preferencias(internet, _)),  % Obtiene las preferencias del usuario
    canales_en(canales, Canal).  % Verifica si el canal está disponible

% Regla 13: Verificar si un metodo de pago es válido
metodo_pago_valido(Metodo) :-
    metodo_de_pago_por(metodos_de_pago, Metodo).  % Verifica si el metodo de pago es válido

% Regla 14: Sugerir planes de internet según la velocidad deseada
sugerir_plan_por_velocidad(Usuario, Producto, Precio) :-
    perfil_usuario(Usuario, preferencias(internet, Velocidad)),  % Obtiene la velocidad deseada del usuario
    producto_disponible(internet, Producto, Precio),  % Revisa si el producto está disponible
    velocidad_producto(Producto, Velocidad).  % Verifica si el producto tiene la velocidad deseada

% Regla 15: Recomendar productos basados en la edad del usuario
recomendar_por_edad(Usuario, Producto, Precio) :-
    perfil_usuario(Usuario, demografia(edad, Edad)),  % Obtiene la edad del usuario
    recomendacion(MinEdad, MaxEdad, Producto, Precio),  % Obtiene la recomendación según el rango de edad
    Edad >= MinEdad,
    Edad =< MaxEdad.  % Verifica que la edad esté dentro del rango de la recomendación

% Regla 16: Obtener un resumen de todos los planes disponibles
resumen_planes(Plan, Precio) :-
    producto_disponible(internet, Plan, Precio).  % Obtiene el plan y su precio

% Regla 18: Obtener el precio maximo de los planes disponibles
precio_maximo(PrecioMax) :-
    findall(Precio, producto_disponible(internet, _, Precio), Precios),  % Obtiene todos los precios disponibles
    max_list(Precios, PrecioMax).  % Encuentra el precio maximo

% Regla 19: Sugerir un producto basado en la popularidad (número de compras)
sugerir_por_popularidad(Producto, Precio) :-
    findall(Precio, perfil_usuario(_, historial_compras(_Historial)), Historiales),  % Obtiene los historiales de compras
    sort(Historiales, Productos),  % Ordena los productos por popularidad
    member(Precio, Productos),  % Selecciona un precio de los productos
    producto_disponible(internet, Producto, Precio).  % Verifica si el producto está disponible

% Regla 20: Comprobar si un usuario ha comprado algún producto en particular
ha_comprado_producto(Usuario, Producto) :-
    perfil_usuario(Usuario, historial_compras(Historial)),  % Obtiene el historial de compras del usuario
    producto_disponible(internet, Producto, Precio),  % Verifica si el producto está disponible
    member(Precio, Historial).  % Comprueba si el precio está en el historial

% Regla 21: Recomendar el mejor plan según características específicas
mejor_plan(Usuario, Producto, Precio) :-
    perfil_usuario(Usuario, preferencias(internet, _Velocidad)),  % Obtiene las preferencias de velocidad del usuario
    duos(Precio, _),  % Verifica el precio del plan
    producto_disponible(internet, Producto, Precio).  % Comprueba si el producto está disponible

% Regla 22: Verificar si un usuario tiene acceso a planes de fibra
acceso_a_fibra(Usuario) :-
    perfil_usuario(Usuario, preferencias(internet, alta_velocidad)),
    tiene(planes, internet),
    conexion_de(conexion, fibra).


% Ejemplo 1: Recomendación de productos para el usuario 1
?- recomendar_producto(usuario1, _Producto, _Precio).

% Ejemplo 2: Métodos de pago disponibles para el usuario 1
?- metodos_de_pago_usuario(usuario1, _Metodo).

% Ejemplo 3: Productos en oferta
?- productos_en_oferta(_Producto, _PrecioConDescuento).

% Ejemplo 4: Verificar si un producto específico tiene una oferta
?- producto_con_oferta('Internet velocidad 100 Mbps', _PrecioConDescuento).

% Ejemplo 5: Planes con un DUO específico
?- plan_con_duo(_Plan, _Precio).

% Ejemplo 6: Verificar metodos de pago disponibles
?- metodo_pago_disponible(_Metodo).

% Ejemplo 7: Consultar la simetria de la velocidad
?- simetria_de(simetria, _Tipo).

% Ejemplo 8: Recomendación de productos según el historial de compras del usuario 1
?- recomendar_por_historial(usuario1, _Producto, _Precio).

% Ejemplo 9: Verificar si el metodo de pago "app" es válido
?- metodo_pago_valido(app).

% Ejemplo 10: Sugerir un plan de internet según la velocidad deseada del usuario 1
?- sugerir_plan_por_velocidad(usuario1, _Producto, _Precio).

% Ejemplo 11: Recomendar productos basados en la edad del usuario 1
?- recomendar_por_edad(usuario1, _Producto, _Precio).

% Ejemplo 12: Obtener un resumen de todos los planes disponibles
?- resumen_planes(_Plan, _Precio).

% Ejemplo 13: Obtener el precio maximo de los planes disponibles
?- precio_maximo(_PrecioMax).

% Ejemplo 14: Sugerir un producto basado en la popularidad
?- sugerir_por_popularidad(_Producto, _Precio).

% Ejemplo 15: Comprobar si el usuario 1 ha comprado el producto "Internet velocidad 100 Mbps"
?- ha_comprado_producto(usuario1, 'Internet velocidad 100 Mbps').

% Ejemplo 16: Recomendar el mejor plan según características específicas del usuario 1
?- mejor_plan(usuario1, _Producto, _Precio).

% Ejemplo 17: Verificar si el usuario 1 tiene acceso a planes de fibra
?- acceso_a_fibra(usuario1).

