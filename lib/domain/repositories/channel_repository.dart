import 'package:lentach/data/models/channel_model.dart';
import 'package:lentach/domain/entities/channel.dart';

abstract class ChannelRepository {
  Future<List<Channel>> getChannels();
}
