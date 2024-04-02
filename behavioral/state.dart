/*
* State lets an object alter its behavior when its internal state changes. It
* appears as if the object changed its class.
*
* The State pattern allows us to easily expand the application to support more
* and more valid states by representing states as a given class that we can swap
* out for other states as the finite state machine modeled by our program
* dictates. This keeps the codebase maintainable unlike if we were to manage the
* state through a simple conditional logic branch.
*
* The example shown here is of a media player class that has specific behavior
* depending on whether it is in a `ready` state, `playing` state, or `locked`
* state.
* */

void main() {
  AudioPlayer player = AudioPlayer();
  player.clickPlay();
  player.clickNext();
  player.clickNext();
  player.clickLock();
  player.clickPrevious();
  player.clickLock();
  player.clickPrevious();
  player.clickPlay();
}

class AudioPlayer {
  AudioPlayer() :
        isPlaying = false
  {
    _playerState = ReadyState(this);
  }

  late State _playerState;

  bool isPlaying;

  void changeState(State s) {
    this._playerState = s;
  }

  void clickLock() {
    _playerState.clickLock();
  }

  void clickPlay() {
    _playerState.clickPlay();
  }

  void clickNext() {
    _playerState.clickNext();
  }

  void clickPrevious() {
    _playerState.clickPrevious();
  }


  void startPlayback() {
    isPlaying = true;
    print('Staring playback...');
  }

  void stopPlayback() {
    isPlaying = false;
    print('Stopping playback...');
  }

  void nextSong() {
    print('Skipping to next song...');
  }

  void previousSong() {
    print('Skipping to previous song...');
  }
}

abstract class State {
  State(this._player);
  AudioPlayer _player;

  void clickPlay();
  void clickNext();
  void clickPrevious();
  void clickLock();
}

class ReadyState extends State {
  ReadyState(super.player);

  @override
  void clickLock() {
    print('Locking player...');
    _player.changeState(LockedState(_player));
  }

  @override
  void clickNext() {
    _player.nextSong();
  }

  @override
  void clickPlay() {
    _player.startPlayback();
    _player.changeState(PlayingState(_player));
    print('Changed state to `Playing`');
  }

  @override
  void clickPrevious() {
    _player.previousSong();
  }
}

class LockedState extends State {
  LockedState(super.player);
  @override
  void clickLock() {
    print('Unlocking player...');
    if (_player.isPlaying) {
      _player.changeState(PlayingState(_player));
    } else {
      _player.changeState(ReadyState(_player));
    }
  }

  @override
  void clickNext() {
    print('Player is locked! Doing nothing...');
  }

  @override
  void clickPlay() {
    print('Player is locked! Doing nothing...');
  }

  @override
  void clickPrevious() {
    print('Player is locked! Doing nothing...');
  }
}

class PlayingState extends State {
  PlayingState(super.player);

  @override
  void clickLock() {
    _player.changeState(LockedState(_player));
  }

  @override
  void clickNext() {
    _player.nextSong();
  }

  @override
  void clickPlay() {
    _player.stopPlayback();
    _player.changeState(ReadyState(_player));
  }

  @override
  void clickPrevious() {
    _player.previousSong();
  }
}