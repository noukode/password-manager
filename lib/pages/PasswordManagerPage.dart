import 'package:flutter/material.dart';
import 'package:password_manager/helpers/DatabaseHelper.dart';
import 'package:password_manager/helpers/EncryptionHelper.dart';
import 'package:password_manager/models/Password.dart';

class PasswordManagerPage extends StatefulWidget {
  final int userId;
  final String username;

  PasswordManagerPage({required this.userId, required this.username});

  @override
  _PasswordManagerPageState createState() => _PasswordManagerPageState();
}

class _PasswordManagerPageState extends State<PasswordManagerPage> {
  List<Password> password_lists = [];
  final DBHelper = DatabaseHelper();
  final encryptHelper = EncryptionHelper();

  @override
  void initState() {
    super.initState();
    _fetchPasswords();
  }

  void _fetchPasswords() async {
    final passwords = await DatabaseHelper.instance.getPasswords(widget.userId, widget.username);
    setState(() {
      password_lists = passwords;
    });
  }

  void _addOrUpdatePassword({Password? input}) async {
    final nama_akunController = TextEditingController(text: input?.nama_akun);
    final usernameController = TextEditingController(text: input?.username);
    final passwordController = TextEditingController(text: input?.password);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(input == null ? "Tambah Password" : "Edit Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nama_akunController, decoration: InputDecoration(labelText: 'Nama Akun'),),
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username/Email'),),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'),),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final newPassword = Password(
                id: input?.id,
                user_id: widget.userId, nama_akun: nama_akunController.text, username: usernameController.text, password: encryptHelper.encrypt(widget.username, passwordController.text)
              );

              if (input == null) {
                DBHelper.addPassword(newPassword);
              } else {
                DBHelper.updatePassword(newPassword);
              }

              _fetchPasswords();
              Navigator.of(context).pop();

            },
            child: Text(input == null ? "Tambah" : "Simpan"), 
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Batal"),
          ),
        ],
      )
    );
  }

  void _deletePassword(int id) {
    DBHelper.deletePassword(id);
    _fetchPasswords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Manager"),
      ),
      body: ListView.builder(
        itemCount: password_lists.length,
        itemBuilder: (context, index) {
          final item = password_lists[index];
          return ListTile(
            title: Text(item.nama_akun),
            subtitle: Text(item.username),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _addOrUpdatePassword(input: item),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _deletePassword(item.id!),
                  icon: Icon(Icons.delete),
                ),
              ],
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrUpdatePassword(),
        child: Icon(Icons.add),
      ),
    );
  }
}