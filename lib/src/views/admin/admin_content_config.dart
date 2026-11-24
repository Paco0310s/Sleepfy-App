import 'package:flutter/material.dart';
import 'package:sleepfy/models/content_item_model.dart';
import 'package:sleepfy/src/utils/constants.dart';

class AdminSectionConfig {
  final String section;
  final String tabLabel;
  final String singularLabel;
  final IconData icon;
  final Color accentColor;

  final String titleLabel;
  final String titleHint;

  final String? subtitleLabel;
  final String? subtitleHint;
  final bool subtitleRequired;

  final String? bodyLabel;
  final String? bodyHint;
  final bool bodyRequired;

  final String? urlLabel;
  final String? urlHint;
  final bool urlRequired;

  final String? imageUrlLabel;
  final String? imageUrlHint;

  final bool showIconPicker;

  const AdminSectionConfig({
    required this.section,
    required this.tabLabel,
    required this.singularLabel,
    required this.icon,
    required this.accentColor,
    required this.titleLabel,
    required this.titleHint,
    this.subtitleLabel,
    this.subtitleHint,
    this.subtitleRequired = false,
    this.bodyLabel,
    this.bodyHint,
    this.bodyRequired = false,
    this.urlLabel,
    this.urlHint,
    this.urlRequired = false,
    this.imageUrlLabel,
    this.imageUrlHint,
    this.showIconPicker = false,
  });
}

class AdminSectionConfigs {
  static const insomniaCard = AdminSectionConfig(
    section: ContentSections.insomniaCard,
    tabLabel: 'Tarjetas',
    singularLabel: 'tarjeta informativa',
    icon: Icons.menu_book_outlined,
    accentColor: Constants.kSageGreen,
    titleLabel: 'Título *',
    titleHint: 'Ej. ¿Qué es el Insomnio?',
    bodyLabel: 'Contenido *',
    bodyHint: 'Explicación o puntos informativos...',
    bodyRequired: true,
    showIconPicker: true,
  );

  static const insomniaLink = AdminSectionConfig(
    section: ContentSections.insomniaLink,
    tabLabel: 'Enlaces',
    singularLabel: 'enlace médico',
    icon: Icons.open_in_new_rounded,
    accentColor: Constants.kSoftAmber,
    titleLabel: 'Nombre del recurso *',
    titleHint: 'Ej. MedlinePlus en Español',
    urlLabel: 'URL del sitio web *',
    urlHint: 'https://...',
    urlRequired: true,
  );

  static const meditation = AdminSectionConfig(
    section: ContentSections.meditation,
    tabLabel: 'Ejercicios',
    singularLabel: 'meditación',
    icon: Icons.self_improvement_rounded,
    accentColor: Constants.kSageGreen,
    titleLabel: 'Nombre del ejercicio *',
    titleHint: 'Ej. Respiración Profunda (4-4-6)',
    bodyLabel: 'Instrucciones paso a paso *',
    bodyHint: '◆ Acuéstate en tu cama...',
    bodyRequired: true,
  );

  static const meditationVideo = AdminSectionConfig(
    section: ContentSections.meditationVideo,
    tabLabel: 'Videos',
    singularLabel: 'video de YouTube',
    icon: Icons.play_circle_outline_rounded,
    accentColor: Constants.kSoftAmber,
    titleLabel: 'Título del video *',
    titleHint: 'Ej. Música Relajante con Sonidos de Lluvia',
    urlLabel: 'URL de YouTube *',
    urlHint: 'https://youtu.be/...',
    urlRequired: true,
  );

  static const music = AdminSectionConfig(
    section: ContentSections.music,
    tabLabel: 'Playlists',
    singularLabel: 'playlist',
    icon: Icons.music_note_rounded,
    accentColor: Constants.kSageGreen,
    titleLabel: 'Nombre de la playlist *',
    titleHint: 'Ej. Peaceful Piano',
    subtitleLabel: 'Descripción *',
    subtitleHint: 'Breve descripción de la playlist...',
    subtitleRequired: true,
    urlLabel: 'Enlace de Spotify / audio *',
    urlHint: 'https://open.spotify.com/...',
    urlRequired: true,
    imageUrlLabel: 'URL de portada (opcional)',
    imageUrlHint: 'https://i.scdn.co/image/...',
  );

  static const podcast = AdminSectionConfig(
    section: ContentSections.podcast,
    tabLabel: 'Podcasts',
    singularLabel: 'podcast',
    icon: Icons.headphones_rounded,
    accentColor: Constants.kSageGreen,
    titleLabel: 'Nombre del podcast *',
    titleHint: 'Ej. Durmiendo Podcast',
    subtitleLabel: 'Descripción *',
    subtitleHint: '¿De qué trata el podcast?',
    subtitleRequired: true,
    urlLabel: 'Enlace al podcast *',
    urlHint: 'https://open.spotify.com/... o YouTube',
    urlRequired: true,
  );

  static const challenge = AdminSectionConfig(
    section: ContentSections.challenge,
    tabLabel: 'Desafíos',
    singularLabel: 'desafío',
    icon: Icons.emoji_events_outlined,
    accentColor: Constants.kSoftAmber,
    titleLabel: 'Título del desafío *',
    titleHint: 'Ej. Sin Pantallas Antes de Dormir',
    subtitleLabel: 'Objetivo *',
    subtitleHint: 'Ej. Evitar pantallas 1 hora antes de dormir.',
    subtitleRequired: true,
    bodyLabel: 'Cómo lograrlo *',
    bodyHint: 'Consejo práctico para cumplir el reto...',
    bodyRequired: true,
  );

  static const homeBanner = AdminSectionConfig(
    section: ContentSections.homeBanner,
    tabLabel: 'Avisos',
    singularLabel: 'aviso en Inicio',
    icon: Icons.campaign_outlined,
    accentColor: Constants.kSoftAmber,
    titleLabel: 'Título del aviso *',
    titleHint: 'Ej. ¡Nuevo lote de Kits Sleepfy disponible!',
    subtitleLabel: 'Mensaje *',
    subtitleHint: 'Texto breve que aparecerá en la pantalla de inicio...',
    subtitleRequired: true,
    urlLabel: 'Enlace opcional (al tocar el aviso)',
    urlHint: 'https://... (opcional)',
    urlRequired: false,
  );
}
