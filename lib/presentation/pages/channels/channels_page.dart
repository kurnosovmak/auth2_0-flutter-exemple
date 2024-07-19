import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lentach/domain/entities/channel.dart';
import 'package:lentach/domain/usecases/authenticate.dart';
import 'package:lentach/injection_container.dart' as di;
import 'package:lentach/presentation/blocs/channels_bloc.dart';
import 'package:lentach/presentation/pages/channels/channel_page.dart';

import '../../../domain/usecases/channel.dart';

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key});

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChannelsBloc(di.sl<GetChannels>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Каналы"),
        ),
        body: const ChannelBuild(),
      ),
    );
  }
}

class ChannelBuild extends StatelessWidget {
  const ChannelBuild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChannelsBloc>(context).add(GetChannelEvent());
    return BlocBuilder<ChannelsBloc, ChannelState>(
      builder: (context, state) {
        if (state is ChannelLoading) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is ChannelLoaded) {
          return LayoutBuilder(
            builder: (ctx, constrains) => Container(
              child: ListView.builder(
                  itemCount: state.channels.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 86.0,
                      width: 340,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://telegrator.ru/wp-content/uploads/2020/01/chat_avatar-46.jpg"),
                        ),
                        title: SizedBox(
                            width: 500,
                            height: 26,
                            child: Flexible(
                                child: Text(state.channels[index].title))),
                        subtitle: SizedBox(
                          width: 500,
                          height: 40,
                          child: Flexible(
                            child: Text(state.channels[index].description),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChannelPage(
                                channel: state.channels[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ),
          );
        } else if (state is ChannelError) {
          return Center(
            child: Text('Ошибка: ${state.message}'),
          );
        }
        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}
