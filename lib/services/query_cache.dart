class QueryCache<T> {
  T? _data;
  DateTime? _lastFetched;
  final Duration ttl;
  final void Function(T data)? onUpdate;

  QueryCache({required this.ttl, this.onUpdate});

  T? get data => _data;

  bool get isFresh {
    if (_data == null || _lastFetched == null) return false;
    return DateTime.now().difference(_lastFetched!) < ttl;
  }

  bool get isEmpty => _data == null;

  bool get mustFetch => !isFresh || isEmpty;

  void setData(T data, {bool isFromStorage = false}) {
    _data = data;
    _lastFetched = DateTime.now();

    // Don't persist if this is loaded from storage
    if (!isFromStorage) {
      onUpdate?.call(data);
    }
  }

  void updateData(T Function(T? data) updater) {
    final newData = updater(_data);
    setData(newData);
  }

  void clear() {
    _data = null;
    _lastFetched = null;
  }
}
