import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lentach/domain/entities/channel.dart';
import 'package:lentach/domain/usecases/channel.dart';

abstract class ChannelEvent {}

class GetChannelEvent extends ChannelEvent {}

abstract class ChannelState {}

class ChannelInitial extends ChannelState {}

class ChannelLoading extends ChannelState {}

class ChannelLoaded extends ChannelState {
  final List<Channel> channels;

  ChannelLoaded(this.channels);
}

class ChannelError extends ChannelState {
  final String message;

  ChannelError(this.message);
}

class ChannelsBloc extends Bloc<ChannelEvent, ChannelState> {
  final GetChannels getChannels;

  ChannelsBloc(this.getChannels) : super(ChannelInitial()) {
    on<GetChannelEvent>((event, emit) async {
      emit(ChannelLoading());
      try {
        final channels = await getChannels();
        emit(ChannelLoaded(channels));
      } catch (e) {
        emit(ChannelError('ошибка загрузки каналов ' + e.toString()));
      }
    });
  }
}
