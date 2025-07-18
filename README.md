# Flutter-Project-LookTalk
커뮤니티 기반 옷 쇼핑몰 플랫폼 


## 🖥️ 프로젝트 소개
옷 쇼핑몰과 커뮤니티 기능이 있는 애플리케이션입니다. 
<br>

## 🕰️ 개발 기간
* 25.06.25일 - 25.07.17일

### 🧑‍🤝‍🧑 맴버구성
 - 팀장  : 이수지 - 소셜 로그인, 회원가입, 커뮤니티, 공통 컴포넌트들 모듈화, API 통신 구조 설계 및 구현
 - 팀원1 : 김명헌 - 구매자 마이 페이지관리, 홈 화면, 통합 및 형상관리, 아키텍처 설게. 주문 상태 로직 관리, 영상 편집
 - 팀원2 : 신기루 - 장바구니 , 결제 , ptt제작
 - 팀원3 : 이창한 - 판매자 마이 페이지 관리, 사용자 관련 데이토 로직 담당, 리뷰 및 제품 상페 페이지 담당, ,발표   


### ⚙️ 개발 환경
- **Flutter** : `3.22.1`
- **Dart** : '3.8.1'
- **IDE** : Android Studio Meerkat 
- **Android SDK** : 35
- **iOS Deployment  Target** : 13.0 이상 
- **Device** : Android Emulator 
- **ORM** : Mybatis

### 📐 아키텍처 설계 
- MVVM모델로 구성
- Model : Client, Repository, Response로 구성
- View : UI 담당. 공통 위젯 및 각 화면 UI 구성
- VIewMode : 상태 관리 및 비즈니스 로직 담당. 비즈니스 로직에 필요한 데이터는 Model에 의존.
<img width="1192" height="608" alt="image" src="https://github.com/user-attachments/assets/f76a8eea-7eae-4038-9a23-1a4f9dc193ee" />
<img width="962" height="620" alt="image" src="https://github.com/user-attachments/assets/3179a9f6-bec3-4120-bc7c-a4dc754e6362" />

### ⚙️ 브랜치 관리
- 기능은 feature을 통해 관리.
- 각 feature에서 작성한 뒤, develop으로 merge 진행.
- 최종 프로젝트는 main 브렌치에서 관리. 




## 📌 주요 기능
#### 소셜 로그인 - <a href="https://github.com/LIKELION-Android-Bootcamp-4th/lookTalk/wiki/%EB%A1%9C%EA%B7%B8%EC%9D%B8-%ED%8E%98%EC%9D%B4%EC%A7%80" >상세보기 - WIKI 이동</a>
- DB값 검증
- ID찾기, PW찾기
- 로그인 시 쿠키(Cookie) 및 세션(Session) 생성

#### 🌐 회원가입 - <a href="https://github.com/chaehyuenwoo/SpringBoot-Project-MEGABOX/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C(Member)" >상세보기 - WIKI 이동</a>
- 주소 API 연동
- ID 중복 체크
#### 🛍️ 메인 Page - <a href="https://github.com/chaehyuenwoo/SpringBoot-Project-MEGABOX/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C(Member)" >상세보기 - WIKI 이동</a>
- 주소 API 연동
- 회원정보 변경

#### 💬 커뮤니티 - <a href="https://github.com/chaehyuenwoo/SpringBoot-Project-MEGABOX/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C(%EC%98%81%ED%99%94-%EC%98%88%EB%A7%A4)" >상세보기 - WIKI 이동</a>
- 영화 선택(날짜 지정)
- 영화관 선택(대분류/소분류 선택) 및 시간 선택
- 좌석 선택
- 결제 페이지
- 예매 완료
#### 🛒 장바구니 / 결제
- 
-
#### 🙋 마이페이지 (사용자) - <a href="https://github.com/chaehyuenwoo/SpringBoot-Project-MEGABOX/wiki/%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5-%EC%86%8C%EA%B0%9C(%EB%A9%94%EC%9D%B8-Page)" >상세보기 - WIKI 이동</a>
- YouTube API 연동
- 메인 포스터(영화) 이미지 슬라이드(CSS)

#### 👨‍💼 마이페이지 (판매자)  
- 영화관 추가(대분류, 소분류)
- 영화 추가(상영시간 및 상영관 설정)
