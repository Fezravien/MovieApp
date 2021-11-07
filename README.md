# 🎬 Favorite Movie 

[네이버 영화 검색 API](https://developers.naver.com/docs/serviceapi/search/movie/movie.md#영화)를 이용한 영화 목록, 즐겨 찾기, 상세 정보(Web) 기능을 할 수 잇는 앱이다.

<img src="https://user-images.githubusercontent.com/44525561/140640840-af808264-75e0-4772-b87f-a6b5c127a09d.gif" alt="Simulator Screen Recording - iPhone 12 Pro Max - 2021-11-07 at 19.03.36" width="30%" /> <img src="https://user-images.githubusercontent.com/44525561/140656283-5d1f4bc5-a82f-4457-9e33-0c59f6440151.gif" alt="Simulator Screen Recording - iPhone 12 Pro Max - 2021-11-07 at 19.04.08" width="30%" /> <img src="https://user-images.githubusercontent.com/44525561/140640855-f8b03dd0-6b99-4dee-abd6-3e7d8a5391c6.gif" alt="Simulator Screen Recording - iPhone 12 Pro Max - 2021-11-07 at 19.05.00" width="30%" />

<br>

## 목차 

[1. 프로젝트 개요](#프로젝트-개요)

[2. 기능](기능)

[3. 설계](#설계)

[4. 유닛 테스트](#유닛-테스트)


<br>

## 프로젝트 개요

### Index

[- 프로젝트 관리](#프로젝트-관리)

[- 기술 스택](#기술-스택)

<br>

### 프로젝트 관리

기능 단위 브랜치로 나눠서 프로젝트를 진행했다. [PR](https://github.com/Fezravien/MovieApp/pulls?q=is%3Apr+is%3Aclosed)

<img src="https://raw.githubusercontent.com/Fezravien/UploadForMarkdown/forUpload/img/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202021-11-08%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%201.32.27.png" alt="Simulator Screen Recording - iPhone 12 Pro Max - 2021-11-07 at 19.05.00" width="80%" />


#### 기능 단위 브랜치 내용

##### feature

`feature/Model` : 네이버 영화 검색 API를 기준으로 네트워킹을 포함한 Model 구현

`feature/MovieList` : 서버로 부터 받은 데이터를 TableView를 통해 영화 목록을 보여줌 

`feature/FavoriteList` : 영화 목록 중 사용자의 즐겨찾기로 추가된 영화를 TableView를 통해 즐겨찾기 목록을 보여줌

`feature/Detail` : 영화 상세 페이지로 WKWebView를 통해 Web으로 상세 정보를 보여줌



##### refactor

`refactor/Reactoring` : 전체적으로 코드의 일관성을 통일 및 구조 개선 

<br>

#### ✏️ Commit Message

기능 단위로 나눠 개발하는 과정의 커밋 메시지는 `깃 이모지`를 활용해서 가시성과 일관성을 높혔다. 

| Type     | Emoji | Description                                                  |
| :------- | :---: | :----------------------------------------------------------- |
| Feat     |   ✨   | 기능 (새로운 기능)                                           |
| Fix      |   🐛   | 버그 (버그 수정)                                             |
| Refactor |   ♻️   | 리팩토링 `기능 변경 없음`                                    |
| Style    |   🚚   | 파일 형식/네이밍, 폴더 구조/네이밍 수정하거나 옮기는 작업 `비즈니스 로직에 변경 없음` |
| Style    |   💄   | 스타일 (UI 스타일 변경)  `비즈니스 로직에 변경 없음`         |
| Docs     |   📝   | 문서 (문서 추가, 수정, 삭제)                                 |
| Test     |   ✅   | 테스트 (테스트 코드 추가, 수정, 삭제) `비즈니스 로직에 변경 없음` |
| Chore    |   🔧   | 기타 (빌드, 시스템 파일 및 설정 변경)                        |
| Comment  |   💡   | 필요한 주석 추가 및 변경                                     |
| Remove   |   🔥   | 파일, 폴더 삭제 작업                                         |

<br>

### 기술 스택

| UIKit                                                        | WebKit    | Network              | Decoing                                | Test   |
| :----------------------------------------------------------- | --------- | :------------------- | :------------------------------------------------- | :----- |
| UITableView <br />UISearchController <br />UIImageVIew<br />UILabel<br />UIAlert <br />UIActivityIndicatorView<br /> | WKWebView | URLSession<br />Data | Codable<br />JSONDecoder <br /> | XCTest |

<br>

## 기능

### Index

[- 영화 목록](#영화-목록)

[- 즐겨찾기](#즐겨찾기)

[- 영화 상세](#영화-상세)

<br>

### 영화 목록

#### 시나리오

검색어를 통해 서버로 부터 받은 데이터를 TableView를 통해 영화 목록을 보여준다.

- 영화 목록을 한번에 받아올 수 있는 개수는 10개로 10개 이상의 영화가 존재한다면 더 받아올 수 있다 **(Infinite Scroll)**
- 검색창에 Cancel을 통해 초기 화면으로 돌아갈 수 있다.
<img src="https://user-images.githubusercontent.com/44525561/140655201-04c54579-b135-40da-852a-8ea648d9e33d.png" alt="Simulator Screen Recording - iPhone 12 Pro Max - 2021-11-07 at 19.05.00" width="100%" />

<br>

---

### 즐겨찾기

#### 시나리오

영화 목록의 영화를 즐겨찾기에 추가할 수 있으며, 즐겨찾기 목록을 통해 확인할 수 있다.

- 영화 별로 즐겨찾기에 추가, 삭제 가능
- 즐겨찾기 목록을 통해 추가된 즐겨찾기 영화를 확인할 수 있으며, 삭제 또한 가능하다.

<img src="https://user-images.githubusercontent.com/44525561/140655226-73cfe8cc-5fe7-418d-aab6-6902b08495b3.png" alt="Simulator Screen Recording - iPhone 12 Pro Max - 2021-11-07 at 19.05.00" width="80%" />

<br>

---

### 영화 상세

#### 시나리오 1

영화 목록 중 영화를 눌러서 상세 정보를 WebView를 통해 확인할 수 있으며, 즐겨찾기 기능도 가능하다

- WebView를 통해 영화 상세 정보를 확인할 수 있다.
- 우측 상단(네이게이션 버튼)을 통해 즐겨찾기 추가, 삭제를 할 수 있다.
- 즐겨찾기 추가, 삭제에 따라 상세 페이지 종료 후 영화 목록에 반영된다.

<img src="https://user-images.githubusercontent.com/44525561/140655252-30415514-0d10-4032-a1b7-8406856441cb.png" alt="Simulator Screen Recording - iPhone 12 Pro Max - 2021-11-07 at 19.05.00" width="100%" />


<br>

#### 시나리오 2

즐겨찾기에서 특정 영화의 상세 정보 또한 위와 동일한 동작을 할 수 있다.

- 즐겨찾기 페이지에서 WebView를 통한 상세 정보를 볼 수 있다.
- 즐겨찾기 추가, 삭제 기능을 할 수 있다.

<img src="https://user-images.githubusercontent.com/44525561/140655275-af02081c-342f-475e-bebb-30a687852a04.png" alt="Simulator Screen Recording - iPhone 12 Pro Max - 2021-11-07 at 19.05.00" width="90%" />

<br>

## 설계

#### MVVM 

각각의 ViewController 마다 ViewModel을 가지고 있는 것을 선호했지만, 이 경우에는 `보일러 플레이트 코드`가 많이 발생함에 따라 ViewModel은 1:N 이 가능하므로 재사용성을 활용했다.

의존성을 프로토콜을 통해 역전시키고 외부에서 주입받도록 하여 유닛 테스트를 가능하게 했다.

![스크린샷 2021-11-08 오전 2.41.57](https://raw.githubusercontent.com/Fezravien/UploadForMarkdown/forUpload/img/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202021-11-08%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%202.41.57.png)

<br>

## 유닛 테스트

<img src="https://user-images.githubusercontent.com/44525561/136770969-5c17f959-4ef7-4eb2-85ea-acd2c13e2109.png" alt="스크린샷 2021-10-11 오후 5.46.39" width="80%;" />

**현재 유닛 테스트는 1, 2 번만 진행되었다.**

1. URLProtocol로 가짜 Session을 만들어 네트워크와 무관한 테스트를 진행
- 오류가 존재하는지
- 서버 응답은 잘 처리하는지
- 데이터를 잘 전달해 주는지

<br>

2. URLProtocol로 네트워크와 무관, 유관한 테스트를 진행했고, 요청을 만들고 응답을 받는 테스트를 진행
- 네트워크가 존재하는 서버에 요청을 보냈을때 원하는 데이터가 들어오는지 (유관)
- 네트워크가 없을떄 원하는 동작을 수행하는지 (무관)
