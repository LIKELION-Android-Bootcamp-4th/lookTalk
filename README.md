# Flutter-Project-LookTalk
커뮤니티 기반 옷 쇼핑몰 플랫폼 


## 🖥️ 프로젝트 소개
옷 쇼핑몰과 커뮤니티 기능이 있는 애플리케이션입니다. 
<br>

### 🕰️ 개발 기간
* 25.06.25 - 25.07.17

### 🧑‍🤝‍🧑 맴버구성
 - 팀장  : 이수지 - 소셜 로그인, 회원가입, 커뮤니티, 공통 컴포넌트들 모듈화, API 통신 구조 설계, UI 화면 설계
 - 팀원1 : 김명헌 - 구매자 마이 페이지관리, 홈 화면, 통합 및 형상관리, 아키텍처 설계, 주문 상태 로직 관리, 영상 편집
 - 팀원2 : 신기루 - 장바구니 , 결제 , ppt제작
 - 팀원3 : 이창한 - 판매자 마이 페이지 관리, 사용자 관련 데이토 로직 담당, 리뷰 및 제품 상페 페이지 담당, 발표   


### ⚙️ 개발 환경
- **Flutter** : `3.22.1`
- **Dart** : `3.8.1`
- **IDE** : Android Studio Meerkat 
- **Android SDK** : 35
- **iOS Deployment  Target** : 13.0 이상 
- **Device** : Android Emulator 

### 📡 서버 Swagger 주소 
- 주소 : http://git.hansul.kr:3001/api/docs/

### 📐 아키텍처 설계 
- MVVM모델로 구성
- Model : Client, Repository, Response로 구성
- View : UI 담당. 공통 위젯 및 각 화면 UI 구성
- VIewMode : 상태 관리 및 비즈니스 로직 담당. 비즈니스 로직에 필요한 데이터는 Model에 의존.
<img width="511" height="239" alt="Image" src="https://github.com/user-attachments/assets/100e5ac7-db66-4bf2-9348-583a39448a03" />
<img width="458" height="243" alt="Image" src="https://github.com/user-attachments/assets/1ee5f675-d407-4d30-a4a2-bf3605e8c1d3" />

### 🌿 브랜치 관리
- 기능은 feature을 통해 관리.
- 각 feature에서 작성한 뒤, develop으로 merge 진행.
- 최종 프로젝트는 main 브렌치에서 관리.



## 📌 주요 기능
#### 🔐 소셜 로그인 - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C-(Login)" >상세보기 - WIKI 이동</a>
- 소셜 로그인 (OAuth 2.0 기반) 
- accessToken 및 refreshToken 발급 및 Secure Storage 저장 
- 신규 사용자 분기 처리 (`isNewUser`)

#### 📝 회원가입 - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C-(%ED%9A%8C%EC%9B%90%EA%B0%80%EC%9E%85)" >상세보기 - WIKI 이동</a>
- 플랫폼 역할 선택 (구매자/판매자)
- 닉네임 또는 상점명/상점 설명 입력
- 중복 체크 (닉네임/상점명)
  
#### 🛍️ 메인 Page - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C-(%EC%87%BC%ED%95%91%EB%AA%B0)" >상세보기 - WIKI 이동</a>
- 상위 카테고리별 상품 조회
- 카테고리 

#### 💬 커뮤니티 - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C-(%EC%BB%A4%EB%AE%A4%EB%8B%88%ED%8B%B0)" >상세보기 - WIKI 이동</a>
- 코디 질문 / 코디 추천 / My+ 탭 구성 
- 게시글 작성 
- 상품 정보 추가 (구매내역 / 검색)
- 게시글 상세 조회
- 게시글 좋아요 
- 댓글 작성 및 조회 

#### 🛒 장바구니 / 결제 - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C-(%EC%9E%A5%EB%B0%94%EA%B5%AC%EB%8B%88,-%EA%B2%80%EC%83%89)" >상세보기 - WIKI 이동</a>
- 장바구니 목록 조회
- 상품 결제 

#### 🙋 마이페이지 (사용자) - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C-(%EB%A7%88%EC%9D%B4%ED%8E%98%EC%9D%B4%EC%A7%80-%E2%80%90-%EA%B5%AC%EB%A7%A4%EC%9E%90)" >상세보기 - WIKI 이동</a>
- 로그아웃
- 공지사항 조회
- 주문/반품/취소 내역 조회
- 리뷰 작성
- 반품 신청/주문 취소 

#### 👨‍💼 마이페이지 (판매자)   - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C-(%EB%A7%88%EC%9D%B4%ED%8E%98%EC%9D%B4%EC%A7%80-%E2%80%90-%ED%8C%90%EB%A7%A4%EC%9E%90)" >상세보기 - WIKI 이동</a>
- 로그아웃
- 공지사항 조회
- 상품 조회/등록/수정 
- 주문 조회 및 배송 상태 변경


## 🛠️ 프로젝트 리팩토링 및 기능 추가 - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EB%A6%AC%ED%8C%A9%ED%86%A0%EB%A7%81-%EC%82%AC%EC%95%88-%EB%B0%8F-%EC%9C%A0%EC%A7%80%EB%B3%B4%EC%88%98-%EC%82%AC%ED%95%AD">상세보기 -WIKI 이동</a>
