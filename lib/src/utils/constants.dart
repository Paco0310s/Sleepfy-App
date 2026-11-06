import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'Sleepfy';
  static const String appVersion = '1.0.4';

  // -------------------------------------------------------------
  // PALETA INSPIRADA EN EL LOGO DE SLEEPFY:
  // Fondo logo: Slate Gris Cálido/Noche (#3A444C)
  // Elementos logo: Luna, estrella y hoja en Crema Sereno (#F2EDE4)
  // -------------------------------------------------------------

  // --- MODO OSCURO (Minimalista, sereno y fiel al logo) ---
  static const Color kDarkBackground = Color(0xFF2A3238);      // Fondo profundo gris slate
  static const Color kDarkSurface = Color(0xFF353E46);         // Tarjetas gris slate suave
  static const Color kDarkSurfaceLight = Color(0xFF404B54);    // Hover / inputs / chips
  static const Color kDarkBorder = Color(0xFF4A5661);          // Bordes discretos y sutiles
  static const Color kDarkTextPrimary = Color(0xFFF4F0E8);     // Crema luna (del logo)
  static const Color kDarkTextSecondary = Color(0xFFAEB8C2);   // Gris claro sereno
  static const Color kDarkPrimary = Color(0xFF4F5B66);         // Botones principales pizarra
  static const Color kDarkSecondary = Color(0xFFE2DCD0);      // Acento crema sereno

  // --- MODO CLARO (Limpio, estético y natural) ---
  static const Color kLightBackground = Color(0xFFF6F4EF);     // Blanco crema orgánico
  static const Color kLightSurface = Color(0xFFFFFFFF);        // Tarjetas blanco puro
  static const Color kLightSurfaceLight = Color(0xFFECE7DE);   // Chips y campos
  static const Color kLightBorder = Color(0xFFDDD7CC);         // Borde suave
  static const Color kLightTextPrimary = Color(0xFF2B3339);    // Texto carbón slate (del logo)
  static const Color kLightTextSecondary = Color(0xFF6B7680);  // Gris medio sutil
  static const Color kLightPrimary = Color(0xFF3E4850);        // Botones pizarra oscuro
  static const Color kLightSecondary = Color(0xFF55616C);      // Acento pizarra

  // Acentos funcionales suaves (no chillones ni fluorescentes)
  static const Color kSageGreen = Color(0xFF7E9F88);           // Hoja del logo (salud y calma)
  static const Color kSoftAmber = Color(0xFFC79E62);           // Estrellas / logros
  static const Color kSoftRose = Color(0xFFC0706F);            // Advertencias / errores suaves

  // -------------------------------------------------------------
  // HELPERS DINÁMICOS SEGÚN EL TEMA (Context-aware)
  // -------------------------------------------------------------
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color background(BuildContext context) =>
      isDark(context) ? kDarkBackground : kLightBackground;

  static Color surface(BuildContext context) =>
      isDark(context) ? kDarkSurface : kLightSurface;

  static Color surfaceLight(BuildContext context) =>
      isDark(context) ? kDarkSurfaceLight : kLightSurfaceLight;

  static Color border(BuildContext context) =>
      isDark(context) ? kDarkBorder : kLightBorder;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? kDarkTextPrimary : kLightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? kDarkTextSecondary : kLightTextSecondary;

  static Color primary(BuildContext context) =>
      isDark(context) ? const Color(0xFFECE7DD) : const Color(0xFF363F46);

  static Color primaryContent(BuildContext context) =>
      isDark(context) ? const Color(0xFF242C32) : const Color(0xFFF7F5F0);

  static Color accent(BuildContext context) =>
      isDark(context) ? const Color(0xFFD6CEBF) : const Color(0xFF4C5862);

  // -------------------------------------------------------------
  // RETROCOMPATIBILIDAD CON CONSTANTES ESTÁTICAS
  // Ahora adaptadas al color gris slate y crema sereno del logo
  // -------------------------------------------------------------
  static const Color kBackgroundColor = Color(0xFF2B3339);
  static const Color kSurfaceColor = Color(0xFF363F46);
  static const Color kCardColor = Color(0xFF363F46);
  static const Color kSurfaceLightColor = Color(0xFF424D56);
  static const Color kPrimaryColor = Color(0xFFE8E2D5);
  static const Color kSecondaryColor = Color(0xFFD6CEBF);
  static const Color kMintColor = Color(0xFF7E9F88);
  static const Color kBorderColor = Color(0xFF495560);
  static const Color kTextColor = Color(0xFFF6F2EA);
  static const Color kTextSecondaryColor = Color(0xFFA6B0B8);
  static const Color kErrorColor = Color(0xFFBF616A);
  static const Color kSuccessColor = Color(0xFF7E9F88);
  static const Color kWarningColor = Color(0xFFC79E62);

  static const LinearGradient kPrimaryGradient = LinearGradient(
    colors: [Color(0xFF434D56), Color(0xFF333B42)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kHeaderGradient = LinearGradient(
    colors: [Color(0xFF333B42), Color(0xFF2B3339)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient kCardAccentGradient = LinearGradient(
    colors: [Color(0xFF3C464F), Color(0xFF313940)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
