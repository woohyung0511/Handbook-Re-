<div align='center'>
<h3>SNS 사이트 구현</h3>
<h2>HandBook</h2>
<img src='https://github.com/ssangyongHandbook/handbook/assets/124232240/f086e79a-7b6b-4cdb-9502-65050c27db90' alt='handbook logo' width='400'>
</div>
<div>

  ## 🚥 코드 컨벤션

- 3개 이상의 데이터를 request로 받는 경우 DTO를 사용한다. 
- if 또는 for 문의 뎁스는 최대 1개를 넘지 않는다. 
- 레이어간 서로 다른 DTO가 활용 되어야 한다.
- 디자인 패턴을 활용한다. 
- 레이어드 아키텍처를 지향하고 최대한 인터페이싱하여 유연한 설계를 한다. 
- JPA의 효율적인 사용을 위해 Domain 계층과 Entity를 분리하지 않되 최대한 Entity를 도메인 모델과 유사하게 설계한다. 
- REST에 response와 request는 모두 명확해야한다. (true, false 금지)
- Controller와 Service Dto는 REST Method로 구분한다. 
- 비즈니스 로직이 길어지면 Facade를 고려한다.
- 테스트 코드는 필수이다. 80% 이상을 고수하여야 한다. (서비스, 핸들러 등 기본 로직 단위 테스트와 통합 테스트는 필수)

  <h3>목차</h3>
  <hr>
  <ol>
    <li>프로젝트 개요</li>
    <li>기술스택</li>
    <li>ERD</li>
    <li>주요기능</li>
    <li>역할</li>
    <li>프로젝트 산출물</li>
  </ol>
  <br><br>
  <h3>프로젝트 개요</h3>
  <hr>
  <p>
    HandBook은 차세대 소셜 네트워킹 플랫폼으로, 사용자 중심의 커뮤니케이션과 개인화를 제공합니다.<br>
    HandBook은 모든 사용자에게 안전하고 개인화된 소셜 네트워킹 경험을 제공하는 것을 목표로 하고 있습니다.
  </p>
  <br><br>
  <h3>기술스택</h3>
  <hr>
  <b>사용언어</b>
  <br>
  <ul>
    <li>JavaScript</li>
    <li>Java</li>
  </ul>
  <br>
  <b>프론트엔드</b>
  <br>
  <ul>
    <li>html</li>
    <li>css</li>
    <li>jquery</li>
    <li>Bootstrap</li>
  </ul>
  <br>
  <b>백엔드</b>
  <br>
  <ul>
    <li>Spring Boot</li>
  </ul>
  <br>
  <b>데이터베이스</b>
  <br>
  <ul>
    <li>AWS</li>
    <li>MySql</li>
  </ul>
  <br><br>
  <h3>ERD</h3>
  <hr>
  <img src='https://github.com/ssangyongHandbook/handbook/assets/124232240/6f952ee4-58fb-4bd8-afbe-300a0dc70964'>
  ERDCloud 링크참고 https://www.erdcloud.com/d/5RBWkdXjoxxYPw3Nb
  <br><br>
  <h3>주요기능</h3>
  <hr>
  <ul>
    <li>회원가입</li>
    <li>로그인</li>
    <li>비밀번호 암호화</li>
    <li>검색</li>
    <li>타임라인</li>
    <li>팔로잉/팔로워</li>
    <li>즐겨찾기</li>
    <li>친구추천</li>
    <li>마이페이지</li>
    <li>메신저</li>
    <li>알림</li>
  </ul>
  <br><br>
  <h3>역할</h3>
  <hr>
  <b>타임라인</b>
  <ul>
    <li>지성웅</li>
    <li>박종수</li>
  </ul>
  <b>검색/즐겨찾기/메뉴/친구추천</b> 
  <ul>
    <li>김병훈</li>
    <li>박종수</li>
  </ul>
  <b>회원가입/로그인/비밀번호 암호화</b> 
  <ul>
    <li>김희수</li>
  </ul>
  <b>팔로잉/팔로워</b> 
  <ul>
    <li>박종수</li>
  </ul>
  <b>마이페이지</b> 
  <ul>
    <li>이우형</li> 
    <li>박종수</li>
  </ul>
  <b>메신저/알림</b> 
  <ul>
    <li>권예지</li>
  </ul>
  <br><br>
  <h3>프로젝트 산출물</h3>
  <hr>
  <a href='https://youtu.be/sdiJD54SL24'><img src='http://img.youtube.com/vi/sdiJD54SL24/0.jpg'></a>
 
  
</div>
