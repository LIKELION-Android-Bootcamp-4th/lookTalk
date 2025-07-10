enum GenderType{ male, female}

class GenderCategoryId {
  static const Map<GenderType, String> id = {
    GenderType.male : '686ca0fb5cb34c70a30b4618',
    GenderType.female : '686ca1165cb34c70a30b4650',
  };
  static const Map<GenderType, String> label = {
    GenderType.male: '남자',
    GenderType.female: '여자',
  };
  static final Map<String, GenderType> labelToGender = {
    for (var entry in label.entries) entry.value: entry.key
  };
}
