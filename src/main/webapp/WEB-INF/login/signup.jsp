<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>sign up(회원가입)</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.3.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap"
          rel="stylesheet">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        .wrapper {
            display: flex;
            justify-content: center; /* 가로 중앙. */
            align-items: center; /*새로중앙*/
            min-height: 100%;
        }

        @media (max-width: 600px) {
            div.title {
                font-size: 20px; /* 적절한 크기로 조정 */
            }
        }
    </style>
</head>
<body>
<div>
    <div class="wrapper">
        <div>
            <p style="font-size: 3em; font-weight: bold;" align="center" class="title">HandBook</p>
            <div>
                <form action="signupprocess" method="post" onsubmit="return validateForm()">
                    <p align="center" style="font-size: 1.2em;">새 계정 만들기</p>
                    <div class="form-floating">
                        <input type="text" class="form-control" id="user_name" name="user_name" placeholder="이름 입력"
                               required>
                    </div>
                    <br>


                    <div class="row">
                        <div class="col-md-8" style="padding-right: 5px;">
                            <input type="email" class="form-control" id="user_email" name="user_email"
                                   placeholder="이메일 입력" required>
                        </div>

                        <div class="col-md-4">
                            <button type="button" style="" class="btn btn-primary btn-block" onclick="fn_emailCheck();">
                                중복체크
                            </button>
                        </div>
                    </div>
                    <br>


                    <div class="form-floating">
                        <input type="password" class="form-control" id="user_pass" name="user_pass"
                               placeholder="비밀번호 입력" required pattern=".{6,20}" title="6자리 이상 20자리 이하로 작성하세요."
                               onchange="check_pw()"><br>
                        <input type="password" class="form-control" id="user_pass_r" name="user_pass_r"
                               placeholder="비밀번호 다시 입력" required onchange="check_pw()">
                        <span id="check"></span>
                    </div>
                    <br>


                    <div class="form-floating">
                        <p>핸드폰 번호</p>
                        <p>
                            <select class="form-control" id="hp1" name="hp1" size="1"
                                    style="width:100px; display:inline-block;">
                                <option value="010" class="hp1">010</option>
                                <option value="011" class="hp2">011</option>
                                <option value="016" class="hp3">016</option>
                                <option value="017" class="hp4">017</option>
                                <option value="019" class="hp5">019</option>
                            </select>
                            <span>-</span>
                            <input type="text" class="form-control" id="hp2" name="hp2" size="3" required="required"
                                   style="width:100px;display:inline-block;" required="required">
                            <span>-</span>
                            <input type="text" class="form-control" id="hp3" name="hp3" size="3" required="required"
                                   style="width:100px;display:inline-block;" required="required">
                        </p>
                    </div>


                    <div class="addrform">
                        <p>주소</p>
                        <div class="row">
                            <div class="col-md-9" style="padding-right: 5px;">
                                <input id="member_post" style=" background-color: white;" class="form-control"
                                       type="text" placeholder="우편번호" readonly required>
                            </div>

                            <div class="col-md-3">
                                <button type="button" style="" class="btn btn-primary btn-block" onclick="findAddr()">
                                    검색
                                </button>
                            </div>
                        </div>
                        <br>
                        <input id="member_addr" name="addr1" class="form-control" type="text" placeholder="주소" readonly
                               style="background-color: white;" required><br>
                        <input type="text" name="addr2" class="form-control" placeholder="상세주소" required>
                    </div>
                    <br>

                    <div class="form-floating">
                        <p>생일</p>
                        <input type="date" class="form-control" name="user_birth" value="1990-01-01" required>
                    </div>
                    <br>


                    <div class="form-floating">
                        <p>성별</p>
                        <label class="radio-inline">
                            <input type="radio" name="user_gender" value="여자" checked>여자
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="user_gender" value="남자">남자
                        </label><label class="radio-inline">
                        <input type="radio" name="user_gender" value="기타">기타
                    </label>
                    </div>
                    <br>

                    <div class="d-grid gap-2">
                        <button class="btn btn-primary btn-block" type="submit">가입하기</button>
                    </div>
                    <br>

                </form>
            </div>
        </div>
    </div>
</div>
</body>
<script>
    // 브라우저 화면크기 바뀔 때마다 리로드하지 않고, 중앙에 배치.
    window.onresize = function (event) {
        var windowHeight = window.innerHeight;
        $(".wrapper").css('height', windowHeight - 80);
    }
</script>
<script type="text/javascript">
    // 주소입력 다음 api 활용.
    function findAddr() {
        new daum.Postcode({
            oncomplete: function (data) {

                console.log(data);

                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var jibunAddr = data.jibunAddress; // 지번 주소 변수
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('member_post').value = data.zonecode;
                if (roadAddr !== '') {
                    document.getElementById("member_addr").value = roadAddr;
                } else if (jibunAddr !== '') {
                    document.getElementById("member_addr").value = jibunAddr;
                }
            }
        }).open();
    }
</script>
<script>
    // 회원가입 시 비밀번호 유효성 검사. 비밀번호 다시입력 일치 판별
    function check_pw() {
        var pw = document.getElementById('user_pass').value;
        var SC = ["!", "@", "#", "$", "%"];
        var check_SC = 0; //특수문자 있는지 없는지 판별

        for (var i = 0; i < SC.length; i++) {
            if (pw.indexOf(SC[i]) != -1) { //일치하는 값이 없으면 -1반환
                check_SC = 1;
            }
        }
        if (check_SC == 0) {
            window.alert('!,@,#,$,% 의 특수문자가 들어가 있지 않습니다.')
            document.getElementById('user_pass').value = '';
            document.getElementById('user_pass_r').value = '';
        }
        if (document.getElementById('user_pass').value != '' && document.getElementById('user_pass_r').value != '') {
            if (document.getElementById('user_pass').value == document.getElementById('user_pass_r').value) {
                document.getElementById('check').innerHTML = '비밀번호가 일치합니다.'
                document.getElementById('check').style.color = 'blue';
            } else {
                document.getElementById('check').innerHTML = '비밀번호가 일치하지 않습니다.';
                document.getElementById('check').style.color = 'red';
            }
        }
    }

    // 회원가입 버튼 눌렀을때, 유효성 검사 불통시 회원가입 안되게 막는다.
    function validateForm() {
        var password = document.getElementById("user_pass").value;
        var confirmPassword = document.getElementById("user_pass_r").value;

        if (password !== confirmPassword) {
            //alert("비밀번호가 일치하지 않습니다.");
            return false;
        }
        return true;
    }

    //회원가입 시 이메일 중복 체크
    function fn_emailCheck() {
        $.ajax({
            url: "/signupform/emailcheck",
            type: "POST",
            dataType: "JSON",
            data: {"email": $("#user_email").val()},
            success: function (data) {
                if (data == 1) {
                    alert("중복된 이메일입니다.");
                    $("#user_email").val("");
                } else if (data == 0) {
                    $("#emailCheck").attr("value", "Y");
                    alert("사용 가능한 이메일입니다.")
                } else if (data == -1) {
                    alert("공백입니다.");
                }
            }
        })
    }
</script>

</html>