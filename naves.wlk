class Nave{
	var property velocidad = 0

	method propulsar() {
		self.acelerar(20000)
	}

	method acelerar(cuanto) {
		velocidad = (velocidad + cuanto).min(300000)
	}

	method prepararViaje(){
		velocidad = (velocidad + 15000).min(300000)
	}
}

class NaveDeCarga inherits Nave {

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	method recibirAmenaza() {
		carga = 0
	}

}

class NaveDePasajeros inherits Nave{

	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave{

	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method prepararViaje(){
		super()
		modo.prepararParaViaje()
	} 

}

object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method prepararParaViaje(){
		NaveDeCombate.emitirMensaje("Saliendo en misión")
		NaveDeCombate.modo(ataque)
	}
}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}

	method prepararParaViaje(){
		NaveDeCombate.emitirMensaje("Volviendo a la base")
	}
}

//------------------------------Nave de Residuos----------------------------


class NaveDeResiduos inherits NaveDeCarga{

	var property sellado = false

	method sellarAlVacio() {
		sellado = true
	}

	override method recibirAmenaza() {
		self.sellarAlVacio()
		velocidad = 0
	}

	override method prepararViaje(){
		super()
		self.sellarAlVacio()
	}
}