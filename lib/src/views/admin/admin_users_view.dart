import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/controllers/admin_controller.dart';
import 'package:sleepfy/models/admin_models.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/my_snackbar.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;
  List<AdminUserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final list = await AdminController.listUsers(search: _searchCtrl.text);
    if (!mounted) return;
    setState(() {
      _users = list;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _loadUsers);
    setState(() {});
  }

  Future<void> _confirmToggleAdmin(AdminUserModel user, bool nextValue) async {
    if (user.id == UserPreferences.id && !nextValue) {
      MySnackBar.showSnackBarError('No puedes quitarte permisos de administrador a ti mismo');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Constants.surface(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Constants.border(ctx)),
        ),
        title: MyText(
          nextValue ? 'Dar permisos de administrador' : 'Revocar administrador',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Constants.textPrimary(ctx),
        ),
        content: MyText(
          nextValue
              ? '¿Deseas otorgar permisos de administrador a ${user.fullName} (${user.email})?'
              : '¿Deseas quitar los permisos de administrador a ${user.fullName}?',
          fontSize: 13.5,
          color: Constants.textSecondary(ctx),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: MyText('Cancelar', color: Constants.textSecondary(ctx)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: MyText(
              nextValue ? 'Confirmar' : 'Revocar',
              color: nextValue ? Constants.kSageGreen : Constants.kSoftRose,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final updated = await AdminController.toggleUserAdmin(user.id, nextValue);
    if (updated != null) {
      MySnackBar.showSnackBarSuccess(
        updated.isAdmin
            ? '${updated.name} ahora es administrador'
            : 'Permisos revocados a ${updated.name}',
      );
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Gestión de Administradores'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              style: TextStyle(color: Constants.textPrimary(context), fontSize: 13.5),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o correo...',
                hintStyle: TextStyle(
                  color: Constants.textSecondary(context).withValues(alpha: 0.7),
                  fontSize: 13,
                ),
                prefixIcon: Icon(Icons.search_rounded, color: Constants.textSecondary(context)),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close_rounded, color: Constants.textSecondary(context)),
                        onPressed: () {
                          _searchCtrl.clear();
                          _loadUsers();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Constants.surface(context),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Constants.border(context)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Constants.border(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Constants.kSageGreen, width: 1.4),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Constants.primary(context)))
                : _users.isEmpty
                    ? RefreshIndicator(
                        color: Constants.kSageGreen,
                        onRefresh: _loadUsers,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
                              child: Center(
                                child: MyText(
                                  'No se encontraron usuarios con ese criterio.',
                                  fontSize: 13.5,
                                  color: Constants.textSecondary(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: Constants.kSageGreen,
                        onRefresh: _loadUsers,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                          itemCount: _users.length,
                          itemBuilder: (context, index) => _buildUserCard(context, _users[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, AdminUserModel user) {
    final isSelf = user.id == UserPreferences.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Constants.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user.isAdmin
              ? Constants.kSageGreen.withValues(alpha: 0.45)
              : Constants.border(context),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: user.isAdmin
                ? Constants.kSageGreen.withValues(alpha: 0.16)
                : Constants.surfaceLight(context),
            child: MyText(
              user.initials,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: user.isAdmin ? Constants.kSageGreen : Constants.textPrimary(context),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: MyText(
                        user.fullName,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Constants.textPrimary(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelf) ...[
                      const Gap(6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Constants.accent(context).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: MyText(
                          'Tú',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Constants.accent(context),
                        ),
                      ),
                    ],
                  ],
                ),
                const Gap(2),
                MyText(
                  user.email,
                  fontSize: 12,
                  color: Constants.textSecondary(context),
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                Row(
                  children: [
                    Icon(
                      user.isEmailVerified
                          ? Icons.verified_outlined
                          : Icons.hourglass_bottom_rounded,
                      size: 13,
                      color: user.isEmailVerified
                          ? Constants.kSageGreen
                          : Constants.textSecondary(context),
                    ),
                    const Gap(4),
                    MyText(
                      user.isEmailVerified ? 'Correo verificado' : 'Sin verificar',
                      fontSize: 11,
                      color: user.isEmailVerified
                          ? Constants.kSageGreen
                          : Constants.textSecondary(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(8),
          Column(
            children: [
              Switch.adaptive(
                value: user.isAdmin,
                activeTrackColor: Constants.kSageGreen,
                onChanged: isSelf
                    ? null
                    : (val) => _confirmToggleAdmin(user, val),
              ),
              MyText(
                user.isAdmin ? 'Admin' : 'Usuario',
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: user.isAdmin
                    ? Constants.kSageGreen
                    : Constants.textSecondary(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
