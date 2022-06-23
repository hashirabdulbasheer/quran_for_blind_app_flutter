enum QuranReadingTypeEnum { wordByWord, ayat }

extension QuranReadingTypeEnumExtension on QuranReadingTypeEnum {
  String get rawValue {
    switch (this) {
      case QuranReadingTypeEnum.wordByWord:
        return 'Word by word';
      case QuranReadingTypeEnum.ayat:
        return 'Entire aayat';
      default:
        return 'Word by word';
    }
  }
}
