import 'dart:async';
import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:lentach/data/models/channel_model.dart';
import 'package:lentach/domain/entities/channel.dart';
import 'package:lentach/domain/repositories/channel_repository.dart';
import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;

class ChannelRepositoryImpl implements ChannelRepository {
  final endpoint = 'http://192.168.0.156:8080/api/channel';
  final http.Client httpClient;

  ChannelRepositoryImpl(this.httpClient);

  @override
  Future<List<Channel>> getChannels() async {
    final response = await httpClient.get(Uri.parse(endpoint));

    if (response.statusCode != 200) {
      throw Exception('Channels failed');
    }
    final rawChannels = jsonDecode(response.body)['data']['channels'] as List;

    var channels = List<Channel>.generate(
        rawChannels.length,
        (index) => Channel(
            id: rawChannels[index]['id'],
            title: rawChannels[index]['title'],
            description: rawChannels[index]['description'],
            slug: rawChannels[index]['slug'],
            created_at: rawChannels[index]['created_at'],
            is_subscribe: rawChannels[index]['is_subscribe'] ?? false));
    // rawChannels.forEach((element) {
    //   channels.add(Channel(
    //       id: element['id'],
    //       title: element['title'],
    //       description: element['description'],
    //       slug: element['slug'],
    //       created_at: element['created_at'],
    //       is_subscribe: element['is_subscribe'] ?? false));
    // });

    return channels;
  }
}
