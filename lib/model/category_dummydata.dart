import 'package:look_talk/model/entity/category_entity.dart';

final List<CategoryEntity> manCategory = [
  CategoryEntity(
      id: 1,
      mainCategory: '상의'
      , subCategory: ['전체', '티셔츠',  '셔츠', '슬리브리스' , '니트/스웨터',  '맨투맨',  '후드']
  ),
  CategoryEntity(
      id: 2
      , mainCategory: '하의',
      subCategory: ['전체', '데님', '슬랙스', '트레이닝', '레깅스']
  ),
  CategoryEntity(
      id: 3
      , mainCategory: '아우터',
      subCategory: ['전체', '패딩', '코트', '트렌치 코트', '야상', '무스탕', '자켓']
  )
];

final List<CategoryEntity> womanCategory = [
  CategoryEntity(
      id: 1,
      mainCategory: '상의'
      , subCategory: ['전체', '티셔츠',  '셔츠','블라우스', '슬리브리스' , '니트/스웨터',  '맨투맨',  '후드']
  ),
  CategoryEntity(
      id: 2
      , mainCategory: '하의',
      subCategory: ['전체', '데님', '슬랙스', '트레이닝', '레깅스']
  ),
  CategoryEntity(
      id: 3
      , mainCategory: '원피스',
      subCategory: ['전체', '롱 원피스', '미니 원피스', '미디 원피스']
  ),
  CategoryEntity(
      id: 3
      , mainCategory: '스커트',
      subCategory: ['전체', '롱 스커트', '미니 스커트', '미디 스커트']
  ),
  CategoryEntity(
      id: 4
      , mainCategory: '아우터',
      subCategory: ['전체', '패딩', '코트', '트렌치 코트', '야상', '무스탕', '자켓']
  )
  ];
final List<String> homeCategoryData = ['전체','상의','하의','아우터'];