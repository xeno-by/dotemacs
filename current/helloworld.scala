import ppl.dsl.optiml._
object HelloWorldRunner extends OptiMLApplicationRunner with HelloWorld 
trait HelloWorld extends OptiMLApplication { 
  def main() = {
    val a = Matrix.identity(10)
    val b = Matrix.identity(10)
    (a * b).pprint
  }
}
