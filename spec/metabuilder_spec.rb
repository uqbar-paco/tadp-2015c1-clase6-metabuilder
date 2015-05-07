require 'rspec'

describe 'Metabuilder' do

  class Perro
    attr_accessor :raza, :edad, :duenio

    def initialize
      @duenio = "Cesar Millan"
    end
  end

  it 'puedo crear un builder de perros' do
    metabuilder = Metabuilder.new
    metabuilder.set_target_class(Perro)
    metabuilder.add_property(:raza)
    metabuilder.add_property(:edad)

    builder_de_perros = metabuilder.build
    builder_de_perros.raza = "Fox Terrier"
    builder_de_perros.edad = 4
    perro = builder_de_perros.build

    expect(perro.raza).to eq("Fox Terrier")
    expect(perro.edad).to eq(4)
    expect(perro.duenio).to eq("Cesar Millan")
  end

=begin
  it 'no puedo usar propiedades que no estan definidas para el builder' do
    metabuilder = Metabuilder.new
    metabuilder.set_target_class(Perro)
    metabuilder.add_property(:raza)
    metabuilder.add_property(:edad)

    builder_de_perros = metabuilder.build

    expect {
      builder_de_perros.duenio = "Otro"
    }.to raise_error(BuildError)
  end

  it 'soporta configuracion por bloques' do
    metabuilder = Metabuilder.config {
      target_class Perro
      property :raza
      property :edad
    }

    builder_de_perros = metabuilder.build
    builder_de_perros.raza = "Fox Terrier"
    builder_de_perros.edad = 4
    perro = builder_de_perros.build

    expect(perro.raza).to eq("Fox Terrier")
    expect(perro.edad).to eq(4)
  end

  it 'puedo definir validaciones que rompen' do
    metabuilder = Metabuilder.config {
      target_class Perro
      property :raza
      property :edad
      validate {
        ["Fox Terrier", "San Bernardo"].include?(raza)
      }
      validate {
        edad > 0 && edad < 20
      }
    }

    builder_de_perros = metabuilder.build
    builder_de_perros.raza = "Fox Terrier"
    builder_de_perros.edad = -5
    expect {
      builder_de_perros.build
    }.to raise_error ValidationError
  end

  it 'puedo definir validaciones que pasan' do
    metabuilder = Metabuilder.config {
      target_class Perro
      property :raza
      property :edad
      validate {
        ["Fox Terrier", "San Bernardo"].include? raza
      }
      validate {
        (edad > 0) && (edad < 20)
      }
    }

    builder = metabuilder.build
    builder.raza = "Fox Terrier"
    builder.edad = 4
    perro = builder.build

    expect(perro.raza).to eq("Fox Terrier")
    expect(perro.edad).to eq(4)
  end

  it 'agrega metodos cuando se cumple la condicion' do
    metabuilder = Metabuilder.config {
      target_class Perro
      property :raza
      property :edad
      conditional_method(
          :caza_un_zorro,
          proc {
            raza == "Fox Terrier" && edad > 2
          },
          proc {
            "Ahora voy #{duenio}"
          }
      )
    }

    builder1 = metabuilder.build
    builder1.raza = "Fox Terrier"
    builder1.edad = 3
    fox_terrier = builder1.build

    expect(fox_terrier.caza_un_zorro).to eq("Ahora voy Cesar Millan")

    builder2 = metabuilder.build
    builder2.raza = "San Bernardo"
    builder2.edad = 3
    san_bernardo = builder2.build

    expect {
      san_bernardo.caza_un_zorro
    }.to raise_error(NoMethodError)
  end

  it 'puede agregar métodos con parámetros' do
    metabuilder = Metabuilder.config {
      target_class Perro
      property :raza
      property :edad
      conditional_method(
          :rescata_a,
          proc { raza == "San Bernardo" },
          proc { |nombre|
            "Rescate a #{nombre}!"
          })
    }

    builder_de_perros = metabuilder.build
    builder_de_perros.raza = "San Bernardo"
    builder_de_perros.edad = 2
    perro = builder_de_perros.build

    expect(perro.method(:rescata_a).arity).to eq(1)
    expect(perro.rescata_a("Pedro")).to eq("Rescate a Pedro!")
  end
=end

end