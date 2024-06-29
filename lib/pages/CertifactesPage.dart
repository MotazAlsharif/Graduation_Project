import 'package:flutter/material.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color of the scaffold to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set background color of the app bar to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Set back arrow color to black
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Coach Certificates',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Set text color to black and bold
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CertificateCard(
            imageUrl:
                'https://marketplace.canva.com/EADaoR1v0uE/1/0/1600w/canva-dark-blue-%26-beige-simple-sport-certificate-8vBJASueSfE.jpg',
            title: 'Certificate 1',
            certificationType: 'Certification Type: Level 3 Coaching',
          ),
          const SizedBox(height: 20),
          CertificateCard(
            imageUrl:
                'https://marketplace.canva.com/EADaoR1v0uE/1/0/1600w/canva-dark-blue-%26-beige-simple-sport-certificate-8vBJASueSfE.jpg',
            title: 'Certificate 2',
            certificationType: 'Certification Type: Football Coaching',
          ),
          const SizedBox(height: 20),
          CertificateCard(
            imageUrl:
                'https://marketplace.canva.com/EADaoR1v0uE/1/0/1600w/canva-dark-blue-%26-beige-simple-sport-certificate-8vBJASueSfE.jpg',
            title: 'Certificate 3',
            certificationType: 'Certification Type: Tennis Coaching',
          ),
        ],
      ),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String certificationType;

  const CertificateCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.certificationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            height: 150, // Adjusted height to 150
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(certificationType),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
