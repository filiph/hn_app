// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Article> _$articleSerializer = new _$ArticleSerializer();

class _$ArticleSerializer implements StructuredSerializer<Article> {
  @override
  final Iterable<Type> types = const [Article, _$Article];
  @override
  final String wireName = 'Article';

  @override
  Iterable<Object?> serialize(Serializers serializers, Article object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'by',
      serializers.serialize(object.by, specifiedType: const FullType(String)),
      'time',
      serializers.serialize(object.time, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.deleted;
    if (value != null) {
      result
        ..add('deleted')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.text;
    if (value != null) {
      result
        ..add('text')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.dead;
    if (value != null) {
      result
        ..add('dead')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.parent;
    if (value != null) {
      result
        ..add('parent')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.poll;
    if (value != null) {
      result
        ..add('poll')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.kids;
    if (value != null) {
      result
        ..add('kids')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(int)])));
    }
    value = object.url;
    if (value != null) {
      result
        ..add('url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.score;
    if (value != null) {
      result
        ..add('score')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.parts;
    if (value != null) {
      result
        ..add('parts')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(int)])));
    }
    value = object.descendants;
    if (value != null) {
      result
        ..add('descendants')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Article deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArticleBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'deleted':
          result.deleted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'by':
          result.by = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'time':
          result.time = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'dead':
          result.dead = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'parent':
          result.parent = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'poll':
          result.poll = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'kids':
          result.kids.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'parts':
          result.parts.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
        case 'descendants':
          result.descendants = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
      }
    }

    return result.build();
  }
}

class _$Article extends Article {
  @override
  final int id;
  @override
  final bool? deleted;
  @override
  final String type;
  @override
  final String by;
  @override
  final int time;
  @override
  final String? text;
  @override
  final bool? dead;
  @override
  final int? parent;
  @override
  final int? poll;
  @override
  final BuiltList<int>? kids;
  @override
  final String? url;
  @override
  final int? score;
  @override
  final String? title;
  @override
  final BuiltList<int>? parts;
  @override
  final int? descendants;

  factory _$Article([void Function(ArticleBuilder)? updates]) =>
      (new ArticleBuilder()..update(updates)).build();

  _$Article._(
      {required this.id,
      this.deleted,
      required this.type,
      required this.by,
      required this.time,
      this.text,
      this.dead,
      this.parent,
      this.poll,
      this.kids,
      this.url,
      this.score,
      this.title,
      this.parts,
      this.descendants})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Article', 'id');
    BuiltValueNullFieldError.checkNotNull(type, 'Article', 'type');
    BuiltValueNullFieldError.checkNotNull(by, 'Article', 'by');
    BuiltValueNullFieldError.checkNotNull(time, 'Article', 'time');
  }

  @override
  Article rebuild(void Function(ArticleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArticleBuilder toBuilder() => new ArticleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Article &&
        id == other.id &&
        deleted == other.deleted &&
        type == other.type &&
        by == other.by &&
        time == other.time &&
        text == other.text &&
        dead == other.dead &&
        parent == other.parent &&
        poll == other.poll &&
        kids == other.kids &&
        url == other.url &&
        score == other.score &&
        title == other.title &&
        parts == other.parts &&
        descendants == other.descendants;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc($jc(0, id.hashCode),
                                                            deleted.hashCode),
                                                        type.hashCode),
                                                    by.hashCode),
                                                time.hashCode),
                                            text.hashCode),
                                        dead.hashCode),
                                    parent.hashCode),
                                poll.hashCode),
                            kids.hashCode),
                        url.hashCode),
                    score.hashCode),
                title.hashCode),
            parts.hashCode),
        descendants.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Article')
          ..add('id', id)
          ..add('deleted', deleted)
          ..add('type', type)
          ..add('by', by)
          ..add('time', time)
          ..add('text', text)
          ..add('dead', dead)
          ..add('parent', parent)
          ..add('poll', poll)
          ..add('kids', kids)
          ..add('url', url)
          ..add('score', score)
          ..add('title', title)
          ..add('parts', parts)
          ..add('descendants', descendants))
        .toString();
  }
}

class ArticleBuilder implements Builder<Article, ArticleBuilder> {
  _$Article? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _by;
  String? get by => _$this._by;
  set by(String? by) => _$this._by = by;

  int? _time;
  int? get time => _$this._time;
  set time(int? time) => _$this._time = time;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  bool? _dead;
  bool? get dead => _$this._dead;
  set dead(bool? dead) => _$this._dead = dead;

  int? _parent;
  int? get parent => _$this._parent;
  set parent(int? parent) => _$this._parent = parent;

  int? _poll;
  int? get poll => _$this._poll;
  set poll(int? poll) => _$this._poll = poll;

  ListBuilder<int>? _kids;
  ListBuilder<int> get kids => _$this._kids ??= new ListBuilder<int>();
  set kids(ListBuilder<int>? kids) => _$this._kids = kids;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ListBuilder<int>? _parts;
  ListBuilder<int> get parts => _$this._parts ??= new ListBuilder<int>();
  set parts(ListBuilder<int>? parts) => _$this._parts = parts;

  int? _descendants;
  int? get descendants => _$this._descendants;
  set descendants(int? descendants) => _$this._descendants = descendants;

  ArticleBuilder();

  ArticleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _deleted = $v.deleted;
      _type = $v.type;
      _by = $v.by;
      _time = $v.time;
      _text = $v.text;
      _dead = $v.dead;
      _parent = $v.parent;
      _poll = $v.poll;
      _kids = $v.kids?.toBuilder();
      _url = $v.url;
      _score = $v.score;
      _title = $v.title;
      _parts = $v.parts?.toBuilder();
      _descendants = $v.descendants;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Article other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Article;
  }

  @override
  void update(void Function(ArticleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Article build() {
    _$Article _$result;
    try {
      _$result = _$v ??
          new _$Article._(
              id: BuiltValueNullFieldError.checkNotNull(id, 'Article', 'id'),
              deleted: deleted,
              type: BuiltValueNullFieldError.checkNotNull(
                  type, 'Article', 'type'),
              by: BuiltValueNullFieldError.checkNotNull(by, 'Article', 'by'),
              time: BuiltValueNullFieldError.checkNotNull(
                  time, 'Article', 'time'),
              text: text,
              dead: dead,
              parent: parent,
              poll: poll,
              kids: _kids?.build(),
              url: url,
              score: score,
              title: title,
              parts: _parts?.build(),
              descendants: descendants);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'kids';
        _kids?.build();

        _$failedField = 'parts';
        _parts?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Article', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
