// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/friend.dart';
import 'package:logger_app/pages/friends-list/bloc/friends_bloc.dart';
import 'package:logger_app/pages/friends-list/functions.dart';
import 'package:logger_app/pages/friends-list/widgets/status.dart';
import 'package:logger_app/pages/friends_home/bloc/friends_home_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/avatar.dart';
import 'package:logger_app/widgets/divider.dart';
import 'package:logger_app/widgets/empty_list.dart';
import 'package:logger_app/widgets/fader.dart';

class MobileFriends extends StatelessWidget {
  const MobileFriends({super.key, required this.state});

  final FriendsLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.friends.isEmpty) {
      return EmptyList(
        title: Strings.friends,
        press: () async => addNewFriendDialog(
          context: context,
          state: state,
        ),
      );
    }

    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.friends)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => addNewFriendDialog(
            context: context,
            state: state,
          ),
          icon: const Icon(Icons.add),
          label: Text(Strings.newItemFAB),
        ),
        body: RefreshIndicator(
          onRefresh: () => refresh(
            context: context,
            state: state,
          ),
          child: ListView.separated(
            separatorBuilder: (c, i) => const ListDivider(height: 8),
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 8 : 0,
                  bottom: i == state.friends.length - 1 ? 88 : 0,
                ),
                child: ListTile(
                  onTap: () {
                    if (state.friends[i].status == FriendStatus.accepted) {
                      BlocProvider.of<FriendsHomeBloc>(context).add(
                        LoadFriendsHome(
                          friend: state.friends[i],
                          token: state.token,
                        ),
                      );

                      Navigator.pushNamed(context, Routes.friendsHome);
                    }
                  },
                  onLongPress: () {
                    if (state.friends[i].status != FriendStatus.action) {
                      deleteFriendDialog(
                        context: context,
                        friend: state.friends[i],
                        token: state.token,
                      );
                    }
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Avatar(profileUrl: state.friends[i].profileUrl),
                  title: Text(
                    state.friends[i].username,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    dateTitle(state.friends[i].timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: FriendTrailing(
                    friend: state.friends[i],
                    token: state.token,
                  ),
                ),
              );
            },
            itemCount: state.friends.length,
          ),
        ),
      ),
    );
  }
}
