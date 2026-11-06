import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'Sleepfy';
  static const String appVersion = '1.0.4';

  // Paleta moderna Sleep-Tech: "Deep Night & Serenity"
  // Fondo principal (Midnight Navy / Slate 900)
  static const Color kBackgroundColor = Color(0xFF0F172A);

  // Fondo de tarjetas y superficies (Slate 800)
  static const Color kSurfaceColor = Color(0xFF1E293B);
  static const Color kCardColor = Color(0xFF1E293B);
  static const Color kSurfaceLightColor = Color(0xFF26334D);

  // Color primario de acción (Índigo sueño / descanso)
  static const Color kPrimaryColor = Color(0xFF6366F1);

  // Color secundario de acento (Azul cielo sereno / Calm Sky)
  static const Color kSecondaryColor = Color(0xFF38BDF8);

  // Acento menta / salud
  static const Color kMintColor = Color(0xFF34D399);

  // Bordes sutiles
  static const Color kBorderColor = Color(0xFF334155);

  // Colores de texto
  static const Color kTextColor = Color(0xFFF8FAFC);
  static const Color kTextSecondaryColor = Color(0xFF94A3B8);

  // Estados
  static const Color kErrorColor = Color(0xFFEF4444);
  static const Color kSuccessColor = Color(0xFF10B981);
  static const Color kWarningColor = Color(0xFFF59E0B);

  // Degradados
  static const LinearGradient kPrimaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kHeaderGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient kCardAccentGradient = LinearGradient(
    colors: [Color(0xFF312E81), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
