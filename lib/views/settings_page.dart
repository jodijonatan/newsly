import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "SETTINGS",
          style: GoogleFonts.orbitron(
            fontSize: 18,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader("Appearance"),
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: "Dark Mode",
            subtitle: "Always active for futuristic feel",
            trailing: Switch(
              value: true,
              onChanged: null, // Disabled: dark-only by design
              activeColor: AppColors.neonCyan,
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("AI & Reading"),
          _buildSettingsTile(
            icon: Icons.auto_awesome_outlined,
            title: "AI Analysis",
            subtitle: "Powered by Google Gemini",
            trailing: const Icon(Icons.chevron_right, color: AppColors.textLow),
          ),
          _buildSettingsTile(
            icon: Icons.record_voice_over_outlined,
            title: "TTS Voice",
            subtitle: "Text-to-Speech for article reading",
            trailing: const Icon(Icons.chevron_right, color: AppColors.textLow),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("System"),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: "Version",
            subtitle: "Newsly v1.0.0",
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.orbitron(
          fontSize: 12,
          color: AppColors.neonCyan,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 80,
        borderRadius: 20,
        blur: 10,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02)
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05)
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.textHigh),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textMed),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
