// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/chat_bloc/chat_event.dart';
import '../bloc/chat_bloc/chat_state.dart';

import '../bloc/user_bloc/user_bloc.dart';
import '../bloc/user_bloc/user_event.dart';
import '../bloc/user_bloc/user_state.dart';

import '../widgets/chat_list_tile.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  final String currentUserId;

  const ChatListPage({super.key, required this.currentUserId});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.trim();
      if (q != _searchQuery) setState(() => _searchQuery = q);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper to get chat partner
  dynamic _chatPartner(chat) {
    try {
      return (chat.user1.id == widget.currentUserId) ? chat.user1 : chat.user2;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // keep your original behaviour: still dispatching here (unchanged)
    context.read<ChatBloc>().add(LoadChats());
    context.read<UserBloc>().add(LoadUsers());

    return Scaffold(
      // top-level gradient background for a modern look
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B9BFF), Color(0xFF2E7BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // AppBar-like area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.chat_bubble, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Chats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // small action icons
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Search field & small padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Icon(Icons.search, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.white),
                                textInputAction: TextInputAction.search,
                                decoration: const InputDecoration(
                                  hintText: 'Search chats or people',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () => _searchController.clear(),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(Icons.close, color: Colors.white70),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Horizontal user "stories" area (status avatars)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 100,
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UsersLoaded && state.users.isNotEmpty) {
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemBuilder: (context, i) {
                            final user = state.users[i];
                            return GestureDetector(
                              onTap: () {
                                // same behaviour as before — initiate chat with that user
                                context.read<ChatBloc>().add(InitiateChatEvent(userId: user.id));
                              },
                              child: Column(
                                children: [
                                  // gradient ring + avatar
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.18),
                                          Colors.white.withOpacity(0.06),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        (user.name?.isNotEmpty ?? false) ? user.name[0].toUpperCase() : '?',
                                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 68,
                                    child: Text(
                                      user.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemCount: state.users.length,
                        );
                      } else if (state is UsersLoading) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    buildWhen: (previous, current) => true,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Main chat list container with rounded top corners
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -6)),
                    ],
                  ),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatLoaded) {
                        // keep behaviour: still reading chats from state
                        final chats = state.chats;

                        // local (UI-only) filter by partner name — does not send anything to backend
                        final filtered = _searchQuery.isEmpty
                            ? chats
                            : chats.where((c) {
                                final partner = _chatPartner(c);
                                final name = (partner?.name ?? '').toString().toLowerCase();
                                return name.contains(_searchQuery.toLowerCase());
                              }).toList();

                        if (filtered.isEmpty) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<ChatBloc>().add(LoadChats());
                            },
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 80),
                                Center(child: Text('No chats found', style: TextStyle(color: Colors.grey))),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<ChatBloc>().add(LoadChats());
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final chat = filtered[index];
                              final partner = _chatPartner(chat);

                              // Staggered entrance animation (visual only)
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: Duration(milliseconds: 320 + (index * 35)),
                                curve: Curves.easeOut,
                                builder: (context, value, child) {
                                  final transformY = (1 - value) * 12;
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, transformY),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      // exact same navigation as before (functionality preserved)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatDetailPage(
                                            chat: chat,
                                            currentUserId: widget.currentUserId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.03),
                                            blurRadius: 8,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // avatar + small online dot
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    colors: [Colors.blue.shade100, Colors.blue.shade300],
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 26,
                                                  backgroundColor: Colors.grey[100],
                                                  child: Text(
                                                    (partner?.name?.isNotEmpty ?? false) ? partner!.name[0].toUpperCase() : '?',
                                                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: -2,
                                                bottom: -2,
                                                child: Container(
                                                  width: 14,
                                                  height: 14,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.white, width: 2),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),

                                          const SizedBox(width: 12),

                                          // title & subtitle
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        partner?.name ?? 'Unknown',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black87,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    // placeholder for message time (UI-only, if chat has a field you can replace)
                                                    const SizedBox(width: 8),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                // Use your ChatListTile to show preview / time if it already does that,
                                                // otherwise keep a compact placeholder
                                                // Here we place ChatListTile inside to preserve any existing rendering logic
                                                DefaultTextStyle(
                                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                                  child: ChatListTile(
                                                    chat: chat,
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => ChatDetailPage(
                                                            chat: chat,
                                                            currentUserId: widget.currentUserId,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is ChatError) {
                        return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    buildWhen: (prev, cur) => true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
