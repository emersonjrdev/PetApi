class PetModel {
  final String name;
  final int age;
  final double weight;
  final String color;
  final List<String> images;

  // Construtor para inicializar o modelo Pet
  PetModel({
    required this.name,
    required this.age,
    required this.weight,
    required this.color,
    required this.images,
  });

  // Método para converter o JSON da resposta da API para o modelo Pet
  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      name: json['name'],
      age: json['age'],
      weight: json['weight'].toDouble(),
      color: json['color'],
      images: List<String>.from(
          json['images'] ?? []), // Garantir que seja uma lista de strings
    );
  }

  // Método para retornar a URL da imagem principal (primeira imagem na lista ou aleatória)
  String get imageUrl {
    if (images.isNotEmpty) {
      return images[0];
    }
    // Imagem aleatória ou padrão caso a lista de imagens esteja vazia
    List<String> defaultImages = [
      'https://caesegatos.com.br/wp-content/uploads/2023/03/gato-mestico-preto-e-branco-e-um-cao-feliz-border-collie-ofegante-sobre-fundo-azul.jpg',
      'https://caesegatos.com.br/wp-content/uploads/2023/03/gato-mestico-preto-e-branco-e-um-cao-feliz-border-collie-ofegante-sobre-fundo-azul.jpg',
      'https://caesegatos.com.br/wp-content/uploads/2023/03/gato-mestico-preto-e-branco-e-um-cao-feliz-border-collie-ofegante-sobre-fundo-azul.jpg',
    ];
    return defaultImages[DateTime.now().millisecond % defaultImages.length];
  }

  // A descrição do animal pode ser uma string fixa ou nula, dependendo do seu caso
  String get description {
    // Suponha que a descrição seja uma string fixa ou obtenha de algum lugar
    return "Este é um pet adorável que está à espera de um lar.";
  }

  // Se o gênero for necessário, você pode adicionar conforme a lógica da sua aplicação
  String get gender {
    // Adicione a lógica aqui para determinar o sexo ou obtenha de algum campo da API
    return "Masculino"; // Exemplo fixo
  }
}
