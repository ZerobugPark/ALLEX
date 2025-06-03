# 🧗‍♂️ 클라이밍 기록 관리 서비스 앱 ALLEX
![ReadMeTitle](https://github.com/user-attachments/assets/5f81374c-e918-4aaf-ac9e-de722f5479e4)
<br><br><br>


## 프로젝트 소개
- **Allex**는 프랑스어의 Allez과 extreme의 합쳐진 합성어로, 클라이머들의 극한의 도전을 기록하고 관리하는 애플리케이션입니다.
- 월간 클라이밍 기록을 확인하고, 자주 방문하는 클라이밍장을 쉽게 확인할 수 있습니다.
- 운동 기록은 **실시간으로 바로 기록하거나, 나중에 수동으로 등록**할 수 있으며, 언제든지 수정이 가능합니다.
- 국내 클라이밍장 정보를 검색하고 확인할 수 있습니다.
<br><br>
## 프로젝트 정보
기획 및 개발: 2025.03.29 ~ 2025.04.08(10일간)  
유지보수 및 기능 업데이트: 2025.04.09 ~  
[업데이트 이력 보기](/.CHANGELOG.md)

<br><br>

### 기술 스택
- **FrameWork** - UIKit  
- **Library** - Lottie, Realm, RxSwift, RxDataSource, SnapKit, KingFisher
- **Architecture** - MVVM-C
<br><br>

### 기술 스택
- **FrameWork** - UIKit  
- **Library** - Lottie, Realm, RxSwift, RxDataSource, SnapKit, KingFisher
- **Architecture** - MVVM-C
<br><br>
### 기술 설명
- **최소 지원 iOS 버전**: iOS 16.0  
- **다크모드**: 지원  
- **다국어 지원**: 영어 (`Localizable.strings`)
- **Local DB**: Realm
- **API**: Google Sheet (Rest API)
<br><br>

Swift의 UICalendarView(iOS 16.0+)를 사용하기 위해 최소버전은 16.0 이상으로 설정하였습니다.

<b>[MVVM-C]</b>  
MVVM 패턴을 기반으로 설계하였으며, View의 책임을 최소화하고 비즈니스 로직과의 분리를 강화하기 위해 Coordinator 패턴을 도입하여 화면 전환을 전담시켰습니다.  
이를 통해 ViewModel은 순수하게 상태 관리와 로직에 집중할 수 있으며, 화면 흐름에 대한 관리가 보다 명확하고 테스트 가능한 구조로 분리되었습니다.

<b>[네트워크 통신]</b> 

<b>[비동기 처리]</b>




***

### DB Schema
 프로젝트에서는 클라이밍 체육관 정보를 다음과 같은 구조로 구글 시트에 정리하고 있습니다.

**Gyms**
- 체육관의 기본 정보 (이름, 주소, 이미지 등)를 담고 있는 메인 테이블입니다.
- 브랜드(Brand)와 연결되어 있으며, 국가 및 도시 정보를 다국어로 포함합니다.

**BoulderingRoutes**
- 각 브랜드의 난이도 범위를 지정합니다 

**BrandID**
- 각 체육관이 속한 브랜드 이름을 관리합니다.
 ![image](https://github.com/user-attachments/assets/35749599-a92f-49a8-97c8-618796e9e48e)

***
### 트러블 슈팅





