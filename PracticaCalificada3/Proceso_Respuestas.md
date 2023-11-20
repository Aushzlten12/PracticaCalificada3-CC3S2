# Practica Calificada 3

## Iniciando la aplicación

Clonamos el repositorio, luego `bundle install --without production`, seguido de: 

![13](https://github.com/miguelvega/PC3_CC3S2/assets/124398378/26c72df9-f630-4464-bc39-bbd24ddc1bb4)

- **Pregunta:** ¿Cómo decide Rails dónde y cómo crear la base de datos de desarrollo? (Sugerencia: verifica los subdirectorios db y config)

Rails utiliza la configuración definida en el archivo config/database.yml para determinar dónde y cómo crear la base de datos de desarrollo, el cual indica que la base de datos se ha creado en `db/development.sqlite3`.

```yml
development:
  <<: *default
  database: db/development.sqlite3
```

Esto significa que, cuando ejecutamos el comando rake db:migrate en el entorno de desarrollo, Rails utilizará la configuración específica para el entorno de desarrollo. En este caso, se usará SQLite como el sistema de gestión de bases de datos, y la base de datos se creará y actualizará en el archivo db/development.sqlite3

- **Pregunta:** ¿Qué tablas se crearon mediante las migraciones? 

Sabemos que podemos verlas migraciones existentes en el directorio db/migrate de nuestra aplicación Rails. Cada archivo de migración tiene un nombre de timestamp seguido por un guion bajo y un nombre descriptivo. En nuestro tenemos `20150809022253_create_movies.rb`.

Ahora bien, si queremos ver las tablas que se han creado o ver el esquema de la base de datos actual. El esquema se encuentra en el archivo db/schema.rb y encontraremos lo siguiente:

```ruby
ActiveRecord::Schema.define(version: 20150809022253) do

  create_table "movies", force: :cascade do |t|
    t.string   "title"
    t.string   "rating"
    t.text     "description"
    t.datetime "release_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

```
El código nos muestra una representación en Ruby de la estructura de la tabla "movies" en la base de datos, tal como fue creada por la migración anterior. Usando el comando `sqlite3 db/development.sqlite3`

```sql
sqlite> .tables
movies             schema_migrations
sqlite> PRAGMA table_info(movies);
0|id|INTEGER|1||1
1|title|varchar|0||0
2|rating|varchar|0||0
3|description|TEXT|0||0
4|release_date|datetime|0||0
5|created_at|datetime|0||0
6|updated_at|datetime|0||0
sqlite> 
```

Ahora insertamos los "datos semilla" en la base de datos. (Las semillas son elementos de datos iniciales que la aplicación necesita para ejecutarse):

![14](https://github.com/miguelvega/PC3_CC3S2/assets/124398378/8768da08-b330-4f70-891a-b851fd88ef09)

- **Pregunta:** ¿Qué datos de semilla se insertaron y dónde se especificaron? (Pista: rake -T db:seed explica la tarea de semilla, rake -T explica otras tareas de Rake disponibles)
El archivo `db/seeds.rb` contiene un conjunto de datos de semilla que se cargarán en la base de datos cuando ejecutamos `bundle exec rake db:seed`.
En este caso, se están creando varias películas con sus títulos, clasificaciones y fechas de lanzamiento. Por ejemplo:
```
{:title => 'Aladdin', :rating => 'G', :release_date => '25-Nov-1992'}

```
El código Ruby en el archivo db/seeds.rb utiliza el método create! para crear registros en la base de datos basados en el array movies y cuando
ejecutamos `bundle exec rake db:seed`, se ejecuta este código y se insertan las películas en la base de datos.

Al ejecutar `sqlite3 db/development.sqlite3` en la terminal podemos acceder a una consola con comandos SQLite, para ver detalladamente la base de datos.

```sql
sqlite> select * from movies;
1|Aladdin|G||1992-11-25 00:00:00.000000|2023-11-16 04:39:12.201753|2023-11-16 04:39:12.201753
2|The Terminator|R||1984-10-26 00:00:00.000000|2023-11-16 04:39:12.214504|2023-11-16 04:39:12.214504
3|When Harry Met Sally|R||1989-07-21 00:00:00.000000|2023-11-16 04:39:12.216785|2023-11-16 04:39:12.216785
4|The Help|PG-13||2011-08-10 00:00:00.000000|2023-11-16 04:39:12.218748|2023-11-16 04:39:12.218748
5|Chocolat|PG-13||2001-01-05 00:00:00.000000|2023-11-16 04:39:12.220896|2023-11-16 04:39:12.220896
6|Amelie|R||2001-04-25 00:00:00.000000|2023-11-16 04:39:12.222900|2023-11-16 04:39:12.222900
7|2001: A Space Odyssey|G||1968-04-06 00:00:00.000000|2023-11-16 04:39:12.224847|2023-11-16 04:39:12.224847
8|The Incredibles|PG||2004-11-05 00:00:00.000000|2023-11-16 04:39:12.226803|2023-11-16 04:39:12.226803
9|Raiders of the Lost Ark|PG||1981-06-12 00:00:00.000000|2023-11-16 04:39:12.228766|2023-11-16 04:39:12.228766
10|Chicken Run|G||2000-06-21 00:00:00.000000|2023-11-16 04:39:12.230664|2023-11-16 04:39:12.230664
sqlite> 
```

Luego, para ejecutar y obtener una vista previa de nuestra aplicación Rails localmente, ejecutamos el comando `bin/rails server`, esto iniciará el servidor de desarrollo WEBrick y la aplicación estará disponible en http://localhost:3000 por defecto.

![17](https://github.com/miguelvega/PC3_CC3S2/assets/124398378/cb05b08d-19c4-4984-89e6-d204cc0b8e1e)


Agregamos a los colaboradores en nuestro repositorio de GitHub que participarán en este proyecto.

![19](https://github.com/miguelvega/PC3_CC3S2/assets/124398378/41a062ca-6b99-46f2-a0d2-eff28d60cfd6)

Y le asignamos las ramas con la cual van a trabajar

<p align="center">
  <img src="https://github.com/miguelvega/PC3_CC3S2/assets/124398378/ff1505a4-b124-4a2f-9ef1-760266126edf" alt="Descripción de la imagen">
</p>

## Despliegue en Heroku

Primero nos logeamos con Heroku `heroku login -i` accedemos con nuestras credenciales.

*No usaremos render*, por lo que usamos lo siguientes comandos `heroku apps:favorites:add -a su23-chips53-4`, para añadir a favoritos la aplicación en Heroku y `heroku git:remote -a su23-chips53-4` para agregarle un control remoto de Heroku a mi repositorio de Git. Antes de realizar esto se debe de crear la app de nombre `su23-chips53-4` con el comando `heroku create su23-chips53-4`. 

Ejecutamos `git remote -v` para verificar que todo haya salido como esperabamos.

```bash
$ git remote -v
heroku  https://git.heroku.com/su23-chips53-4.git (fetch)
heroku  https://git.heroku.com/su23-chips53-4.git (push)
origin  https://github.com/miguelvega/PC3_CC3S2 (fetch)
origin  https://github.com/miguelvega/PC3_CC3S2 (push)
```

Cambiamos el stack de Heroku a 20, con el comando `heroku stack:set heroku-20`

Al abrir la aplicación de heroku con URL : https://su23-chips53-4-c3a1ca3c6fe7.herokuapp.com/ aparece **Application Error** ya que la tabla movies no existe al no realizarse anteriormete la migración al igual como lo hicimos localmente. Para ello ejecutamos `heroku run rake db:migrate` para crear la tabla y `heroku run rake db:seed` para llenar algunos registros.

Antes de esto debemos hacer algunos cambios, ya que al momento de desplegarlo en Heroku, la base de datos no será SQLite como en desarrollo o en test. Por lo que debemos de realizar algunos cambios en `database.yml` 

```yml
production:
  <<: *default
  adapter: postgresql
  enconding: unicode 
  pool: 5
  database: db/production.sqlite3
```

Y además no hemos agregado PostgresSQL en nuestra app de Heroku, por lo que usamos el siguiente comando, primero verificamos la no existencia de este con `heroku addons` y debe retornar algo como `No add-ons for app su23-chips53-4.`. Luego `heroku addons:create heroku-postgresql` para crear una base de datos postgresql en Heroku para en esta realizar las migraciones e insertar las semillas.

Para acceder a la aplicación https://su23-chips53-4-c3a1ca3c6fe7.herokuapp.com/

## Parte 1 : Filtrar la lista de películas por clasificación

Para esto primero necesitamos agregar en la vista index.html.erb un formulario

```ruby
<%= form_tag movies_path, method: :get, id: 'ratings_form' do %>
  <% @all_ratings.each do |rating| %>
    <div class="form-check form-check-inline">
      <%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
      <%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class: 'form-check-input' %>
    </div>
  <% end %>
  <%= submit_tag 'Refresh', id: 'rating_submit', class: 'btn btn-primary' %>  
<% end %>
```

Sin embargo al desplegarlo localmente se encuentran fallos, uno de ellos era la variable `@all_ratings` no es una colección para hacerle un `each`. Para solucionar esto en el modelo `movie.rb` debemos de agregarle un método de clase para obtener este arreglo

```ruby
def self.all_ratings
  ['G','PG','PG-13','R']
end
```

Y luego en el controlador crear la variable `@all_ratings` que se usará en la vista.

```ruby
@all_ratings = Movie.all_ratings
```

Al volverlo a desplegar, encontramos otro error en la variable `@ratings_to_show` podriamos definirla estas debe de contener los ratings seleccionados, sin embargo al usar el método `include?` no se puede hacer a una variable `nil`, por lo que debe tener un valor por defecto no nulo.

```ruby
@ratings_to_show = params[:ratings] || @all_ratings
```

- **Pregunta:** ¿Por qué el controlador debe configurar un valor predeterminado para @ratings_to_show incluso si no se marca nada? 

Porque como se dijo anteriormete, en la vista se usa un método `include` a esa variable y al cargar la página por primera vez el usuario no ha seleccionada nada, por lo que el valor de `@rating_to_show` sería `nil`. Y al usar este código `params[:ratings] || @all_ratings` si no se ha recibido ningun parametro `ratings` tomará por defecto como seleccionados todos `@all_ratings` ese sería su valor por defecto.

Continuando, al desplegar localmente todos los check box de los ratings estan marcados, pero si desmarcamos alguno de ellos al volver a cargar la página, se mostraran todas las peliculas como antes, ya que en el controlador la variable `@movies = Movie.all`. Podriamos definir un método de clase en el modelo `Movie`.

```ruby
def self.with_ratings(ratings)
  if ratings.present?
    where('UPPER(rating) IN (?)',ratings.map(&:upcase))
  else 
    all
  end
end
```

Se define el método `with_ratings` con parametros `ratings` de la forma `['PG','G','PG-13','R']` en la que usamos el método `where` para realizar una consulta, y a los valores del campo `rating` los convierte en mayuscula y los valores de `ratings` tambien para que no halla error en la consulta. Si `ratings` es nil entonces `@movies = Movie.all`.

Al volver a cargar la página ya con esos cambios, nos da error ya que `ratings_to_show` no es un array, mas bien es un Hask con keys y values, de la forma {"PG"=>"1", ... } , en este caso solo importa las keys. Por lo que usando este código lo convertimos a un array de keys

```ruby
@ratings_to_show = @ratings_to_show.keys if @ratings_to_show.is_a?(Hash)
```

Si es un Hash es decir que no es `@all_ratings` ya que este es un array, lo convierte a un array de keys. Y ya con estos cambios funciona de manera correcta el filtrado de peliculas por su rating.

### Mas sugerencias
**Labels**

```ruby
<%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
<%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class:'form-check-input' %>
```

Esto hace que el label se asocio al check_box, es decir al hacerle click al label directamente marcas o desmarcas el check_box.

**Style**

Para darle estilos en esta app de Rails se esta usando Bootstrap

```html
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
```

Con bootstrap necesitamos implementar clases en cada etiqueta de HTML. Por ejemplo :

```ruby
<%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
```

Tiene la clase `form-check-label` con esto se le da estilos usando Bootstrap a la etiqueta label.

## Parte 2 : Ordenar la lista de películas

Primero en la vista debemos de cambiar dos columnas `title,release_date` para que estos sean botones. 

```ruby
<tr>
  <th class="<%=@title_header_class%>" ><%= link_to "Movie Title", movies_path(sort: 'title', direction: sort_direction), id: 'title_header' %></th>
  <th>Rating</th>
  <th class="<%=@release_date_header_class%>" ><%= link_to "Release Date", movies_path(sort: 'release_date', direction: sort_direction), id: 'release_date_header' %></th>
  <th>More Info</th>
</tr>
```
Le agregamos una variable para los estilos en cada header, cada uno de estos es un enlace envia parametros a movies_path : `sort:, direction:` y además cuenta cada uno con un ID.

Ahora la lógica de esta función se debe ubicar en el controlador `movies_controller.rb` en el método index

```ruby
if params[:sort].present?
  @movies = @movies.order("#{sort_column} #{sort_direction}")
  set_style_header sort_column
end
```
params[:sort] es un hash con estos valores `{"direction"=>"asc", "sort"=>"release_date"}` en este caso ya que se le hizo click en el header `release_date`, pero `asc` no cambia debido mas que todo al codigo :

```ruby
%w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
```

Ya que este boton siempre debe de ordenar por los titulos o fecha de lanzamiento pero siempre de manera ascendente, por lo que su valor predeterminado en **'asc'**.

```ruby
Movie.column_names.include?(params[:sort]) ? params[:sort] : 'title'
```
A diferencia de el parametro :sort que tiene que cambiar entre 'title' y 'release_date'.

```ruby
def set_style_header sort_column
  @title_header_class='hilite bg-warning' if sort_column == 'title'
  @release_date_header_class='hilite bg-warning' if sort_column == 'release_date'
end
```
Definimos un metodo privado para cambiar los estilos a cada header, dependiendo el valor de sort_column. Este código es una base para posteriormente poder no solo ordenarlo ascendentemente sino tambien de manera descendente, etc.

![2023-11-17-00-06-54_mW2fjjdI](https://github.com/miguelvega/PC3_CC3S2/assets/124398378/42f2b44c-f0c2-4518-b1c7-14a1c33ec6eb)


### Agregar parámetros a rutas RESTful existentes 

Probar las rutas en la consola de Rails, para ello usamos el comando `rails console`

**Encontramos la ruta que muestra las peliculas**

```ruby
irb(main):001:0> app.movies_path
=> "/movies"
```

**Encontramos la ruta para una pelicula con su id**

```ruby
irb(main):004:0> app.movie_path(Movie.first)
  Movie Load (0.1ms)  SELECT  "movies".* FROM "movies"  ORDER BY "movies"."id" ASC LIMIT 1
=> "/movies/1"
```

**Verificamos la rutas para calificacion por ratings**

```ruby
irb(main):018:0> app.movies_path("ratings"=>{"PG"=>"1"})
=> "/movies?ratings%5BPG%5D=1"
irb(main):019:0> app.movies_path("ratings"=>{"PG"=>"1","R"=>"1"})
=> "/movies?ratings%5BPG%5D=1&ratings%5BR%5D=1"
```
Sin embargo al añadir un rating que no es válido por ejemplo `"J"=>"2"` aún existe esa ruta.

```ruby
irb(main):002:0> app.movies_path("ratings"=>{"PG"=>"1","R"=>"2"})
=> "/movies?ratings%5BPG%5D=1&ratings%5BR%5D=2"
irb(main):003:0> app.movies_path("ratings"=>{"PG"=>"1","J"=>"2"})
=> "/movies?ratings%5BJ%5D=2&ratings%5BPG%5D=1"
```

**Verificamos la ruta al seleccionar el header para un orden ascendente de una columna**

```ruby
irb(main):021:0> app.movies_path(sort: 'title',direction: 'asc')
=> "/movies?direction=asc&sort=title"
irb(main):022:0> app.movies_path(sort: 'release',direction: 'asc')
=> "/movies?direction=asc&sort=release"
```

Al igual que antes los parametros pueden cambiar a valores no válidos, aún sigue existiendo esa ruta.

```ruby
irb(main):004:0> app.movies_path(sort: 'titulo',direction: 'asc')
=> "/movies?direction=asc&sort=titulo"
```

Teniendo esto en cuenta, al inicio de la parte 2 hemos implementado el ordenamiento dependiendo de la columna seleccionada pero solo de manera ascendente, ahora lo implementaremos tanto ascendentemente y descendentemente, haciendo un toggle.

```ruby
def sort_column
  Movie.column_names.include?(params[:sort]) ? params[:sort] : ''
end

def toggle_direction(column)
  session["sort_direction_#{column}"] = (session["sort_direction_#{column}"] == 'asc') ? 'desc' : 'asc'
end
```

Cambiamos el método `sort_direction` por `toggle_direccion` dependiendo de la columna ya que sino sería algo similar a un rebote entre ambas columnas, es decir si en la columna `Movie Tittle` es *asc* luego en la columna `Release Date` será *des* y así sucesivamente lo cual se vería raro. 

```ruby
if params[:sort].present?
  column_select = sort_column
  direction_select = params[:direction]
  @movies = @movies.order("#{column_select} #{direction_select}")
  set_style_header column_select
end
```

Guardamos en variables los valores de columnas y dirección, pensando mas que todo en la siguiente parte. Y lo ordenamos con estos parametros.

```ruby
<tr>
  <th class="<%=@title_header_class%>" ><%= link_to "Movie Title", movies_path(sort: 'title', direction: toggle_direction('title')), id: 'title_header' %></th>
  <th>Rating</th>
  <th class="<%=@release_date_header_class%>" ><%= link_to "Release Date", movies_path(ratings: ,sort: 'release_date', direction: toggle_direction('release_date')), id: 'release_date_header' %></th>
  <th>More Info</th>
</tr>
```
En la vista mantenemos las mismas keys en el hash que es parametro de `movies_path` y en la key `direction` usamos el método toggle_direction con la columna específica.

### Recordar la clasificación de los ratings

Al ejecutar la aplicación en un entorno local, vemos un fallo el cual es que al hacer un refresh a la pagina con no todos los ratings de clasificaión y luego ordenarlos, este toma todos los rating a pesar de hacer escogido solo algunos. Es decir, se "olvida" de ellos.

```ruby
<tr>
  <th class="<%=@title_header_class%>" ><%= link_to "Movie Title", movies_path(sort: 'title', direction: toggle_direction('title'), ratings: hash_ratings(@ratings_to_show)), id: 'title_header' %></th>
  <th>Rating</th>
  <th class="<%=@release_date_header_class%>" ><%= link_to "Release Date", movies_path(sort: 'release_date', direction: toggle_direction('release_date'), ratings: hash_ratings(@ratings_to_show)), id: 'release_date_header' %></th>
  <th>More Info</th>
</tr>
```
Para ello en la vista agregaremos un llave más al hash que funciona como parametro a la ruta, y este será `ratings` ya que es el mismo nombre que tiene la llave que contiene los ratings, valga la redundancia en el formulario de clasificación. Este será un hash, por lo que en el contrador se define un método `helper_method` para poder usarlo en la vista, para convertir un array a hash.

El metodo index se mantiene sin cambios, solo necesitamos que ese valor de los ratings se mantenga al momento de ordenar y eso se guarda en `params`.

Sin embargo solo se recuerda los parametros del formulario y no del ordenamiento de la tabla. 

```ruby
<%= form_tag movies_path, method: :get, id: 'ratings_form' do %>
  <% @all_ratings.each do |rating| %>
    <div class="form-check form-check-inline">
      <%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
      <%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class: 'form-check-input' %>
    </div>
  <% end %>
  <%= hidden_field_tag "direction", params[:direction] %>
  <%= hidden_field_tag "sort", params[:sort] %>
  <%= submit_tag 'Refresh', id: 'rating_submit', class: 'btn btn-primary' %>  
<% end %>
```

Se le agregó dos campos vacios al formulario para agregar los parametros `direction` y `sort` para que al hacer refresh estos se recuerden.

## Parte 3 : Recuerda la configuración de clasificación y filtrados

### Pregunta: ¿Por qué se "olvida" la configuración de clasificación/filtrado de casillas de verificación cuando navegas a la página Movie Details y luego hace clic en Back to List button?

Cuando visitamos la página de detalles de una película (show.html.erb), el enlace "Back to movie list" está construido de la siguiente manera:
```ruby
<%= link_to 'Back to movie list', movies_path, :class => 'btn btn-primary col-2' %>

``` 
Este enlace apunta a movies_path, que es la ruta del índice (index) del archivo `movies_controller.rb`. Sin embargo, este enlace no incluye los parámetros actuales de clasificación y filtrado en la URL. Por lo tanto, cuando volvemos a la lista después de ver los detalles de una película, la URL no contiene la información sobre la clasificación y el filtrado que estabamos utilizando previamente

Por tal motivo en la siguiente linea de codigo dentro del metodo index del archivo `movies_controller.rb` :

```ruby
@ratings_to_show = params[:ratings] || @all_ratings
``` 
Utiliza todas las clasificaciones, ya que no recuerda ninguna.
Para recordar la configuración de clasificación y filtrado al volver a la página de lista de películas desde la página de detalles de una película, podemos hacer uso de sesiones o cookies para almacenar esa información temporalmente. 

Necesitamos añadir las siguiente lineas de codigo a nuestro archivo movies?controller.rb. De tal manera que se recuerden los filtros y las películas filtradas según esos filtros, para ello usaremos el método save_session_params. Este método se llama antes de la acción index mediante el `before_action :save_session_params, only: [:index]`.

```ruby

def save_session_params
  if params[:sort].nil? && params[:ratings].nil?
    params[:ratings] = hash_ratings(session[:ratings]) if not session[:ratings].nil?
  end
end

```
Este método se encarga de verificar si los parámetros sort y ratings son nulos. Si ambos son nulos, significa que el usuario no ha realizado ninguna selección adicional de clasificación o filtrado en la página actual. En este caso, el método utiliza la información almacenada en la sesión (anteriormente guardada en session[:ratings]) para restaurar los filtros previos. Por lo tanto, cuando volvemos a la página de lista de películas desde la página de detalles, se restauran los filtros previos almacenados en la sesión, asegurando que se muestren las películas según la configuración anterior.

```ruby

def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings] || @all_ratings

    if @ratings_to_show.is_a?(Hash)
      @ratings_to_show = @ratings_to_show.keys
    end

    @movies = Movie.with_ratings(@ratings_to_show)

    if params[:sort].present?
      column_select = sort_column
      direction_select = params[:direction]
      if Movie.column_names.include?(params[:sort]) && ["asc", "desc"].include?(params[:direction])
        @movies = @movies.order("#{column_select} #{direction_select}")
      end
      set_style_header column_select
    end

    session[:ratings] = @ratings_to_show
  end

```

El método index también contribuye a recordar y aplicar los filtros, ya que toma toma los parámetros de clasificación y filtrado de la URL (params[:ratings] y params[:sort]), filtra y ordena las películas en consecuencia, y finalmente, guarda la configuración de clasificación en la sesión para su uso futuro.

![2023-11-19-16-30-02_fASAbY2K](https://github.com/miguelvega/PC3_CC3S2/assets/124398378/98dcc7fe-3c0e-4e5f-b1ea-32f3c4399db7)


Como se puede apreciar, la combinación de `save_session_params` y `index` asegura que los filtros seleccionados se recuerden y se apliquen al volver a la lista de películas desde la página de detalles.

https://su23-chips53-4-migv-46e8e43db507.herokuapp.com/movies 
