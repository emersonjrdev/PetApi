import 'package:flutter/material.dart';
import 'package:pet_adopt/controller/pet_controller.dart';
import 'package:pet_adopt/view/add_pet_screen.dart';
import 'package:pet_adopt/view/profile_screen.dart';
import 'package:pet_adopt/widgets/pet_card_screen.dart';
import 'package:pet_adopt/model/pet_model.dart';
import 'package:pet_adopt/view/home_screen.dart'; // Certifique-se de que HomeScreen seja sua tela inicial

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
    pets = PetController().fetchPets();
  }

  // Função de logout
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomeScreen()), // Altere HomeScreen para sua tela inicial
      (Route<dynamic> route) =>
          false, // Remove todas as rotas da pilha de navegação
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
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddPetScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      side: const BorderSide(
                          color: Colors.grey), // Contorno cinza
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Adicionar para adoção",
                      style: TextStyle(color: Colors.grey), // Texto cinza
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      side: const BorderSide(
                          color: Colors.grey), // Contorno cinza
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          "Meus Pets",
                          style: TextStyle(color: Colors.grey), // Texto cinza
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<PetModel>>(
                  future: pets,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<PetModel> petList = snapshot.data!;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.785,
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
