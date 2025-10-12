import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _wifiOnlyDownload = true;
  bool _restrictMode = false;

  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = 'v${packageInfo.version}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      body: ListView(
        children: [
          _buildSectionHeader('Conta'),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white70),
            title: const Text('Editar Perfil',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Alterar nome, avatar, etc.',
                style: TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white70, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.white70),
            title: const Text('Alterar Senha',
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white70, size: 16),
            onTap: () {},
          ),
          const Divider(color: Colors.white24),
          _buildSectionHeader('Preferências'),
          SwitchListTile(
            title: const Text('Habilitar Notificações',
                style: TextStyle(color: Colors.white)),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary:
                const Icon(Icons.notifications_outlined, color: Colors.white70),
            activeColor: Colors.teal,
          ),
          SwitchListTile(
            title: const Text('Baixar somente via Wi-Fi',
                style: TextStyle(color: Colors.white)),
            value: _wifiOnlyDownload,
            onChanged: (bool value) {
              setState(() {
                _wifiOnlyDownload = value;
              });
            },
            secondary: const Icon(Icons.wifi, color: Colors.white70),
            activeColor: Colors.teal,
          ),
          SwitchListTile(
            title: const Text('Modo restrito',
                style: TextStyle(color: Colors.white)),
            value: _restrictMode,
            onChanged: (bool value) {
              setState(() {
                _restrictMode = value;
              });
            },
            secondary:
                const Icon(Icons.lock_person_outlined, color: Colors.white70),
            activeColor: Colors.teal,
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.white70),
            title: const Text('Limpar Cache',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Cache limpo com sucesso!'),
                ),
              );
            },
          ),
          const Divider(color: Colors.white24),
          _buildSectionHeader('Sobre'),
          AboutListTile(
            icon: const Icon(Icons.info_outline, color: Colors.white70),
            applicationIcon: Image.asset(
              'assets/images/white_logo.png',
              height: 65,
            ),
            applicationName: 'Tramatec',
            applicationVersion: _appVersion,
            applicationLegalese: '© 2025 Tramatec',
            aboutBoxChildren: const [
              SizedBox(height: 16),
              Text('Objetivo do Aplicativo:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  'Este aplicativo tem como objetivo fornecer uma plataforma rica e imersiva para a criação, descoberta e leitura de novos livros, contos e crônicas.'),
              SizedBox(height: 24),
              Text('Equipe de Desenvolvimento:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('👻 Lucas da Silva de Menezes 👻'),
            ],
            child: const Text(
              'Sobre o App',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.description_outlined, color: Colors.white70),
            title: const Text('Termos de Serviço',
                style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading:
                const Icon(Icons.privacy_tip_outlined, color: Colors.white70),
            title: const Text('Política de Privacidade',
                style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
