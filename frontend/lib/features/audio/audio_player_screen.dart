import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/api_client.dart';
import '../../core/location_service.dart';
import '../experiences/experience_detail_screen.dart';
import 'audio_cache_store.dart';

class AudioPlayerScreen extends ConsumerStatefulWidget {
  const AudioPlayerScreen({super.key, required this.slug});
  final String slug;

  @override
  ConsumerState<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen> {
  final _player = AudioPlayer();
  late final AudioCacheStore _cacheStore;
  bool _loading = false;
  bool _downloaded = false;

  @override
  void initState() {
    super.initState();
    _cacheStore = AudioCacheStore(apiClient);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _load(String url) async {
    final localPath = await _cacheStore.localPathFor(url);
    if (localPath != null) {
      _downloaded = true;
      await _player.setFilePath(localPath);
    } else {
      await _player.setUrl(url);
    }
  }

  Future<void> _toggle(String url) async {
    setState(() => _loading = true);
    try {
      if (_player.processingState == ProcessingState.idle) await _load(url);
      _player.playing ? await _player.pause() : await _player.play();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _download(String url) async {
    setState(() => _loading = true);
    try {
      await _cacheStore.download(url);
      _downloaded = true;
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Audio saved for offline listening.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _seekRelative(Duration offset) async {
    final target = _player.position + offset;
    await _player.seek(target.isNegative ? Duration.zero : target);
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(experienceDetailProvider(widget.slug));
    return Scaffold(
        appBar: AppBar(title: const Text('Audio guide')),
        body: detail.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Audio guide is unavailable.')),
          data: (experience) {
            final audioUrl = experience['audio_url'] as String;
            if (audioUrl.isEmpty) return const Center(child: Text('This experience does not have an audio guide yet.'));
            return Padding(
          padding: const EdgeInsets.all(28),
          child: Column(children: [
            const Spacer(),
            Container(
              height: 190,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(24)),
              child: const Center(child: Icon(Icons.graphic_eq, size: 100)),
            ),
            const SizedBox(height: 28),
            Text(experience['title'] as String, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            ref.watch(locationLabelProvider).when(
              loading: () => const Text('GPS: locating you…'),
              error: (_, __) => const Text('GPS: unavailable'),
              data: Text.new,
            ),
            const SizedBox(height: 32),
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (_, snapshot) => Slider(
                value: snapshot.data?.inMilliseconds.toDouble() ?? 0,
                min: 0,
                max: ((_player.duration?.inMilliseconds.toDouble() ?? 1).clamp(1, double.infinity)).toDouble(),
                onChanged: (value) => _player.seek(Duration(milliseconds: value.round())),
              ),
            ),
            StreamBuilder<Duration?>(stream: _player.durationStream, builder: (_, duration) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              StreamBuilder<Duration>(stream: _player.positionStream, builder: (_, position) => Text(_format(position.data ?? Duration.zero))),
              Text(_format(duration.data ?? Duration.zero)),
            ])),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton(iconSize: 36, onPressed: () => _seekRelative(const Duration(seconds: -15)), icon: const Icon(Icons.replay_10)),
              StreamBuilder<bool>(stream: _player.playingStream, builder: (_, playing) => FilledButton(
                style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(22)),
                onPressed: _loading ? null : () => _toggle(audioUrl),
                child: Icon(playing.data == true ? Icons.pause : Icons.play_arrow, size: 40),
              )),
              IconButton(iconSize: 36, onPressed: () => _seekRelative(const Duration(seconds: 15)), icon: const Icon(Icons.forward_10)),
            ]),
            const Spacer(),
            OutlinedButton.icon(onPressed: _loading || _downloaded ? null : () => _download(audioUrl), icon: const Icon(Icons.download_for_offline_outlined), label: Text(_downloaded ? 'Available offline' : 'Download for offline listening')),
          ]),
        );
          },
        ),
      );
  }

  String _format(Duration duration) => '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}
