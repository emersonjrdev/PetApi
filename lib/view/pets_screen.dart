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
  List<PetModel> pets = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      // Aguarda o resultado da função assíncrona fetchPets
      List<PetModel> newPets =
          await PetController().fetchPets(page: currentPage, limit: 10);

      setState(() {
        pets.addAll(newPets);
        currentPage++;
        hasMore =
            newPets.isNotEmpty; // Verifica se há mais pets a serem carregados
      });
    } catch (error) {
      // Exibe um erro amigável ao usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os pets: $error')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

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
              icon: const Icon(Icons.exit_to_app),
              onPressed: _logout,
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
                      setState(() {
                        pets.clear();
                        currentPage = 1;
                        hasMore = true;
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
                    child: const Text(
                      "Meus Pets",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio:
                        MediaQuery.of(context).size.width > 600 ? 1.2 : 0.785,
                  ),
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    return PetCardScreen(dog: pets[index]);
                  },
                ),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (hasMore && !isLoading)
                ElevatedButton(
                  onPressed: _loadPets,
                  style: _customButtonStyle(),
                  child: const Text("Carregar Mais"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
