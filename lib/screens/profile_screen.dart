import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(GameState gameState) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        gameState.character.profileImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final character = gameState.character;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Profil Pemain')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _pickImage(gameState),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: character.profileImagePath != null
                    ? FileImage(File(character.profileImagePath!))
                    : null,
                child: character.profileImagePath == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(character.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Usia: ${character.age}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            _buildInfoCard(
                title: 'Kekayaan Bersih',
                value: formatCurrency(character.netWorth),
                icon: Icons.monetization_on,
                color: Colors.green),
            _buildInfoCard(
                title: 'Uang Tunai',
                value: formatCurrency(character.money),
                icon: Icons.money,
                color: Colors.blue),
            _buildInfoCard(
                title: 'Pekerjaan',
                value: character.currentJob?.title ?? 'Pengangguran',
                icon: Icons.work,
                color: Colors.orange),
            _buildInfoCard(
                title: 'Gaji',
                value: '${formatCurrency(character.currentJob?.salary ?? 0)} / minggu',
                icon: Icons.payment,
                color: Colors.purple),
            const SizedBox(height: 16),
            if (character.properties.isNotEmpty)
              ..._buildAssetsList(character.properties),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.white70)),
                Text(value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAssetsList(List<Property> properties) {
    return [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('Aset Properti',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.home_work_outlined),
              title: Text(property.name),
              subtitle: Text('Nilai: ${formatCurrency(property.price)}'),
            ),
          );
        },
      ),
    ];
  }
}
