import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repositories/cep_repository.dart';
import 'package:cep_app/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
        backgroundColor: Colors.teal, // Change app bar color
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: cepEC,
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.teal), // Add border color
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CEP obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final valid = formKey.currentState?.validate() ?? false;
                    if (valid) {
                      try {
                        setState(() {
                          loading = true;
                        });
                        final endereco = await cepRepository.getCep(cepEC.text);
                        setState(() {
                          loading = false;
                          enderecoModel = endereco;
                        });
                      } catch (e) {
                        setState(() {
                          loading = false;
                          enderecoModel = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao buscar cep')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Change button color here
                    // You can add more styling options as needed
                  ),
                  child: const Text('Buscar'),
                ),
                SizedBox(height: 16),
                if (loading)
                  Center(
                      child: CircularProgressIndicator(
                          color:
                              Colors.teal)), // Change loading indicator color
                if (enderecoModel != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Logradouro: ${enderecoModel?.logradouro}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal), // Change text color
                      ),
                      Text(
                        'Complemento: ${enderecoModel?.complemento}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal), // Change text color
                      ),
                      Text(
                        'CEP: ${enderecoModel?.cep}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal), // Change text color
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
