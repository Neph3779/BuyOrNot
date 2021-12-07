# BuyOrNot 앱

### 앱 다운로드 링크
https://apps.apple.com/app/%EC%82%B4%EA%B9%8C-%EB%A7%90%EA%B9%8C-it-%EC%A0%84%EC%9E%90%EC%A0%9C%ED%92%88-%EB%A6%AC%EB%B7%B0-%EB%AA%A8%EC%9D%8C/id1596846381

### 기능

**카테고리별 랭킹 제공**

- IT 기기 카테고리별 랭킹 제공
  
  <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20211203181754.png" alt="Simulator Screen Shot - iPhone 11 Pro Max - 2021-12-01 at 04.42.59" width= "50%" height= "50%">

**제품 별 리뷰 모아보기 기능**

- 특정 IT 기기의 제품 정보 + 상품 리뷰 (유튜브, 네이버 블로그, 다음 블로그)를 한 번에 볼 수 있는 기능 제공
- 
  <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20211203181613.png" alt="Simulator Screen Shot - iPhone 8 Plus - 2021-12-01 at 04.47.04" width= "50%" height= "50%">

**검색 기능**

- 검색 창을 통해 제품을 검색할 수 있고, 최근에 검색한 검색어들을 저장해둘 수 있음
- 
  <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20211203181736.png" alt="Simulator Screen Shot - iPhone 8 Plus - 2021-12-01 at 04.48.21" width= "50%" height= "50%">



### 사용한 라이브러리

- Alamofire (네트워크 통신 작업을 위해 사용)
- Kingfisher (이미지 캐싱을 위해 사용)
- SwiftSoup (크롤링을 위해 사용)
- Realm (랭킹 정보와 검색 기록을 저장하기 위한 DB)
- Snapkit (코드를 통한 UI 제작을 위해 사용)



### 사용 API

**리뷰를 가져오기 위한 API**

- 유튜브 검색 API
- 네이버 검색(블로그) API
- 네이버 검색(쇼핑) API (예정)
- 카카오 검색(블로그) API



### 크롤링

- 유튜브 검색 결과 크롤링
  - 유튜브 api에서 제공하는 search list의 quota(요청 1회당 사용되는 할당량)는 100
  - 기본으로 제공하는 1일당 api 제한은 10,000 이므로 검색 api를 활용해서는 1일 100회만 리뷰를 봐도 더 이상 유튜브 검색 결과 제공 불가능
  - 이를 해결하기 위해 유튜브 검색 결과를 크롤링 하여 videoId를 구한 뒤, 이를 다시 serach video api를 통해 영상 데이터 요청
  - search video api의 quota는 1이고, 평균 20개의 videoId를 크롤링 결과로 받아오므로 이전보다 5배에 가까운 검색이 가능
- 다나와 사이트 크롤링
  - 랭킹 정보 제공을 위해 현재는 다나와 사이트 크롤링만 사용중



#### 크롤링에 대한 여담

- 유튜브 검색 결과를 앱 내에서 받아올 시, html안에 javascript 코드가 삽입된 형태로 제공됨
- 이것을 해결하기 위해 javascript 코드를 string으로 변환하여 그 중 원하는 데이터를 뽑아내는 로직을 구현했음
- 유튜브 검색 결과 제공이 주요 서비스이 되어선 안됐다는 사실과, 초기 기획 단계에서 가능 여부에 대해 더 잘 따져보아야 했음
  - 다만 지금처럼 search list api를 사용하지 않았을때 앱의 하루 api 할당량이 10,000을 넘는다면 유튜브 api 할당량 증가 신청이 받아들여질 것이라 기대하고 있음 



### 백그라운드 패치

- 다나와 랭킹정보를 가져오는 과정에 상당한 시간이 소요됨
  - 따라서 앱을 처음 깔았을 때를 제외하곤 랭킹 정보를 1일 1회, 백그라운드에서 패치하도록 구현



> 현재(2021.12.03) iOS 13 이상의 기기에서도 iOS 13.0이후로 deprecate된 api를 통해 백그라운드 패치가 진행되는 버그(?)가 있음
>
> 13.0 이후 버전을 위한 코드를 작성했고 분기처리를 마쳤음에도 이러한 현상이 계속되고 있음





### 피드백, 조언, 버그 제보 모두 환영합니다! 

### 이슈 발행해주시거나 neph3779@gmail.com으로 메일주시면 감사하겠습니다.
