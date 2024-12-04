import 'package:flutter/material.dart';
import 'package:pet_adopt/controller/pet_controller.dart';
import 'package:pet_adopt/view/add_pet_screen.dart';
import 'package:pet_adopt/view/profile_screen.dart';
import 'package:pet_adopt/widgets/pet_card_screen.dart';
import 'package:pet_adopt/model/pet_model.dart';
import 'package:pet_adopt/view/home_screen.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  _PetsScreenState createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  late Future<List<PetModel>> pets;

  @override
  void initState() {
    super.initState();
    _loadPets(); // Carregar os pets ao iniciar
  }

  void _loadPets() {
    pets = PetController().fetchPets();
  }

  // Função de logout
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  // Estilo customizado para botões
  ButtonStyle _customButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      side: const BorderSide(color: Colors.grey),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pets"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app), // Ícone de saída
              onPressed: _logout, // Chama a função de logout
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddPetScreen(),
                      ));
                      // Atualiza a lista de pets ao retornar
                      setState(() {
                        _loadPets();
                      });
                    },
                    style: _customButtonStyle(),
                    child: const Text(
                      "Adicionar para adoção",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ));
                    },
                    style: _customButtonStyle(),
                    child: const Row(
                      children: [
                        Text(
                          "Meus Pets",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<PetModel>>(
                  future: pets,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Não foi possível carregar os pets. Tente novamente mais tarde.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 100, color: Colors.grey),
                            SizedBox(height: 20),
                            Text(
                              'Nenhum pet encontrado.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<PetModel> petList = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: MediaQuery.of(context).size.width >
                                  600
                              ? 1.2
                              : 0.785, // Ajusta o aspecto dependendo do tamanho da tela
                        ),
                        itemCount: petList.length,
                        itemBuilder: (context, index) {
                          return PetCardScreen(dog: petList[index]);
                        },
                      );
                    } else {
                      return const Center(
                          child: Text('Nenhum pet encontrado.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
