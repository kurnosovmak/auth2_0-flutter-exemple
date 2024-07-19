import 'dart:convert';

import 'package:lentach/domain/entities/channel.dart';
import 'package:lentach/domain/repositories/channel_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/auth.dart';
import '../repositories/auth_repository.dart';

class GetChannels {
  final ChannelRepository repository;

  GetChannels(this.repository);

  List<Channel> _channels = [];

  Future<List<Channel>> call() async {
    return await repository.getChannels();
  }

}
