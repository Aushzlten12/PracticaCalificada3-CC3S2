# Manejo de Excepciones en Rails

Ya que la lógica del programa está en el modelo y en los controladores, ahí deben de ,manejarse las excepciones.

```ruby
# Create my own ApplicationError hierarchy

class ApplicationError < StandardError; end

class ValidationError < ApplicationError; end
class InvalidGuessError < ValidationError; end

class ResponseError < ApplicationError; end
class FetchRandomWordError < ResponseError; end

class WordGuesserGame

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil? || letter !~ /\A[a-zA-Z]\Z/i # match single letter,ignoring case
      raise InvalidGuessError
    end
    letter = letter[0].downcase
    if  @word.include?(letter) && !@guesses.include?(letter)
      @guesses += letter
    elsif !@word.include?(letter) && !@wrong_guesses.include?(letter)
      @wrong_guesses += letter
    else
      false
    end
  end

  def word_with_guesses
    @word.gsub(/./)  { |letter| @guesses.include?(letter) ? letter : '-' }
  end

  def check_win_or_lose
    return :play if @word.blank?

    if word_with_guesses == @word
      :win
    elsif @wrong_guesses.length > 6
      :lose
    else
      :play
    end
  end

  # Get a word from remote "random word" service

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    begin
      Net::HTTP.post_form(uri ,{}).body
    rescue StandardError => e
      raise FetchRandomWordError, 'Error fetching random word'
    end
  end

end

```

Creamos nuestra propia jerarquía de excepciones para este caso. Usamos dos de ellas, una por si el usuario ingresa un caracter no valido, y otro por si la solicitud a esa URI no devuelve la palabra aleatoria para funcionar el programa, tambien lanzamos una excepcion.

Además, en el controlador debemos de especificar que acciones realizar despues de capturar dicha excepcion, por ejemplo :

```ruby
def guess
    letter = params[:guess]
    begin
        if ! @game.guess(letter[0])
        flash[:message] = "You have already used that letter." 
        end
    rescue InvalidGuessError
        flash[:message] = "Invalid guess."
    end
    redirect_to game_path
end
```

En los parametros de flash, enviamos un mensaje que este se mostrará en game_path, ya que sino hacemos eso, se redirigirá a una pestaña de Rails con un mensaje de Error. Eso no sería una buena experiencia para el usuario.

Considero que estos son las excepciones necesarias para esta app. Ya que como se explicó en el artículo, no es bueno llenar todo el código de excepciones.

## Comparación con JavaScript

En Javascript, para manejar errores usan `try-catch-finally` por lo visto en el artículo no se precisa definir una jerarquía de excepciones como en Ruby. Mas bien en ese caso usan `error instanceof CustomError` siendo CustomError una clase heredada de Error, lo que en Ruby sería `StandardError`.

En Ruby, se puede realizar un `Logger.log()` para guardar ciertos errores o salidas de la aplicación para verlas detenidamente en un archivo, en JavaScript, se usa `console.error` para visualizarlo y guardarlo en la consola del navegador.

Además, en ambos lenguajes, se puede escribir `unit tests` para observar el comportamiento de cierto método. En JavaScript, tambien se recomienda usar *Linters and Formatters*, lo cual es parte tambien del editor de código o IDE.
