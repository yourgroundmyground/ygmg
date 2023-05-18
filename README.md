<br />

# 📚 니땅내땅

![image-4.png](./image-4.png)

<br />


## 📖 프로젝트 소개
 

[개요] 독서 기록 및 독서 모임 플랫폼  

[기간] 2023.02.20~2023.04.07 (7주)  

[소속] SSAFY 8기 2학기 특화 프로젝트 (빅데이터 추천) 

<br />



## 🏷 기획의도
독서모임에는 여러 장점들이 있습니다. 새로운 지식 습득, 다른 사람과 소통 가능, 좋은 자극, 생각 발전 등등..    
하지만, 사람들은 왜 독서모임을 시작할 때 주저할까요? 그 이유에는 책을 기한 내에 읽기 힘들다거나, 오프라인 모임 참여에 부담감을 느낀다는 등 여러가지 이유가 있습니다. 저희는 기존의 독서모임의 불편함 점을 해결하여 사람들의 독서모임을 장려하기 위해 본 서비스를 기획하였습니다.
<br />



## 🛠️ 기술 스택 및 환경

BackEnd
- Spring Boot 2.7.10
- Spring Batch
- AWS RDS
- AWS API Gateway
- Redis

FrontEnd
- Flutter(3.11.0)
- Dart 3.1.0

CI/CD
- AWS EC2 (Ubuntu 20.04 LTS)
- Docker 23.0.1
- TeamCity 2022.04.2
- nginx/1.18.0 



<br />



## 💻 아키텍처


<br />




## 📋 요구사항 명세서


<br />




## ✔️ ERD


<br />




## 📁 프로젝트 파일 구조

#### BackEnd


#### FrontEnd



<br />




## ⭐ 주요 기능 소개

#### 1️⃣ 

#### 2️⃣  

#### 3️⃣  

#### 4️⃣ 



<br />




## 🤜 팀원

👩‍💻 김선규 - 팀장, BE   

👨‍💻 문태호 - BE, Infra   

👨‍💻 원채령 - FE  

👩‍💻 이수아 - BE   

👨‍💻 정혜수 - PM, FE   

👨‍💻 최보영 - FE 
 


















## 📌 Git 사용 규칙
<br/>

### 브랜치 생성, 병합
---
💡 사용 브랜치

- feature - develop에서 feature 분기, 기능 추가 후 develop에 병합
- develop - feature, release를 병합하기 위해 사용
- master - release 브랜치만 병합
</br></br>


💡 feature 브랜치 생성 및 종료 과정

```bash
// feature 브랜치(feature/login)를 'develop' 브랜치에서 분기
git checkout -b feature/login develop

/* ~ feature 브랜치에서 새로운 기능에 대한 코드 작성 ~ */
git add [작성 파일]
git commit -m "type: Subject"
git push origin feature/login

// 'develop' 브랜치로 이동한다.
git checkout develop

// 'develop' 브랜치에 feature/login 브랜치 내용을 병합(merge)한다.
git merge --no-ff feature/login

// Merging 메시지 입력
i 누르기 (INSERT 모드)
# 무시하고 아래로 이동해서 type: Subject 커밋 메시지 입력
입력 후 esc
:wq + enter

// (삭제 안해도됌) -d 옵션: feature/login에 해당하는 브랜치를 삭제한다.
git branch -d feature/login

// 'develop' 브랜치를 원격 중앙 저장소에 올린다.
git push origin develop
```

</br></br>

###  Commit Convention
---
```
커밋 메시지 양식

type: Subject 설명

ex) 
feat: Add 로그인 유효성 검사 기능
```
</br>

💡 type 규칙
- feat: 새로운 기능 추가
- fix: 버그 수정
- docs: 문서 수정
- style: 코드 포맷 변경, 세미콜론 누락, 코드 변경 없음
- refactor: 프로덕션 코드 리팩터링
- test: 테스트 추가, 테스트 코드 리팩터링, 프로덕션 코드 변경 없음
- chore: 빌드 테스크 업데이트, 패키지 매니저 환경설정, 프로덕션 코드 변경 없음
</br> </br>

💡 Subject 규칙
- 동사(ex. Add, Update, Modify)로 시작
- 첫 글자 대문자
- 끝에 마침표 x

</br></br>
