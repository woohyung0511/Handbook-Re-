package com.sns.handbook.controller;

import com.github.scribejava.core.model.OAuth2AccessToken;
import com.sns.handbook.dto.MailDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.oauth.GoogleLoginBO;
import com.sns.handbook.oauth.KakaoLoginBO;
import com.sns.handbook.oauth.NaverLoginBO;
import com.sns.handbook.serivce.UserService;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class LoginController {

    /* NaverLoginBO */
    @Autowired
    private NaverLoginBO naverLoginBO;

    @Autowired
    private void setNaverLoginBO(NaverLoginBO naverLoginBO) {
        this.naverLoginBO = naverLoginBO;
    }

    /* KakaoLogin */
    @Autowired
    private KakaoLoginBO kakaoLoginBO;

    // googleLogin
    @Autowired
    private GoogleLoginBO googleLoginBO;

    private String apiResult = null;

    @Autowired
    UserService service;

    @Autowired
    PasswordEncoder passwordEncoder;

    @PostMapping("/login/loginprocess")
    public String loginproc(@RequestParam String user_id, @RequestParam String user_pass, HttpSession session, Model model) throws Exception {
        int idCheck = service.loginIdCheck(user_id);

        if (idCheck == 0) {
            System.out.println("id틀림");
            return "/login/passfail";
        }

        UserDto user = service.getUserById(user_id);                                // 암호화된 유저의 비밀번호 가져오기 위함.
        int inputIdPassCheck = service.loginIdPassCheck(user_id, user_pass);        // 입력한 아이디 비번에 맞는 계정 있는지 없는지 확인
        boolean matches = passwordEncoder.matches(user_pass, user.getUser_pass());  // 유저가 적은 비밀번호와, 저장되어있는 암호화된 비밀번호가 같은지

        // 비번이 암호화된 계정으로 로그인 할 때
        if (matches == true) {
            if (!user.getMail_auth().equals("1")) { //이메일 인증 했는지 확인
                // 암호화 비번 비교하는 if문 안에 있어야 비번을 막쳤을 때 로그인 실패가 뜬다.
                model.addAttribute("user_num", user.getUser_num());
                return "/login/emailAuthFail";
            }

            setSessionByLogin(user_id, session);

            return "redirect:../post/timeline";
        } else if (inputIdPassCheck == 1) { // 계정 있으면(기존), 비번이 암호화 안된 계정으로 로그인할 때.
            setSessionByLogin(user_id, session);

            return "redirect:../post/timeline"; // 로그인 하면 타임라인으로 넘어감.
        } else { // 로그인 실패시
            return "/login/passfail";
        }
    }

    // 중복되는 코드라 loginproc() 메서드에서만 사용한다.
    private void setSessionByLogin(String user_id, HttpSession session) {
        UserDto dto = service.getUserDtoById(user_id);
        session.setMaxInactiveInterval(60 * 60 * 8);
        session.setAttribute("myid", user_id);
        session.setAttribute("loginok", "yes");
        session.setAttribute("email", dto.getUser_email());
        session.setAttribute("name", dto.getUser_name());
        session.setAttribute("user_num", dto.getUser_num());
        session.setAttribute("user_photo", dto.getUser_photo());
        session.setAttribute("mail_auth", dto.getMail_auth());
    }

    @GetMapping("/login/logincenterform")
    public String logincenter() {
        return "/login/logincenter";
    }

    // 로그아웃 버튼 누르면 로그아웃되게함. 그 후에 메인화면으로 리다이렉트
    @GetMapping("/login/logoutprocess")
    public String logout(HttpSession session) {
        session.removeAttribute("loginok");
        session.invalidate(); // 세션의 모든 속성을 삭제
        return "redirect:/";
    }

    // 네이버 로그인 callback
    @GetMapping("/navercallback")
    public String callbackNaver(Model model, @RequestParam String code, @RequestParam String state, HttpSession session)
            throws Exception {

        OAuth2AccessToken oauthToken;
        oauthToken = naverLoginBO.getAccessToken(session, code, state);
        // 로그인 사용자 정보를 읽어온다.
        apiResult = naverLoginBO.getUserProfile(oauthToken);

        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj;

        jsonObj = (JSONObject) jsonParser.parse(apiResult);
        JSONObject response_obj = (JSONObject) jsonObj.get("response");
        // 프로필 조회, 네이버는 나이, 프로필 이미지(가져와야하는데 안가져와짐), 닉네임 안가져오는걸로.
        String name = (String) response_obj.get("name");
        String email = (String) response_obj.get("email");
        String gender = (String) response_obj.get("gender");
        String birthday = (String) response_obj.get("birthday");
        String birthyear = (String) response_obj.get("birthyear");
        String mobile = (String) response_obj.get("mobile");

        // 이메일에서 user_id 추출
        String[] splitemail = email.split("@");
        String user_id;
        user_id = splitemail[0];

        int check = service.loginEmailCheck(email); // 입력한 이메일이 가입되어있는지 아닌지 판단

        // 이 아래는 아무튼 로그인 한다.
        // 이미 예전에 로그인한 네이버 계정이면 그냥 로그인
        // 아니면 db에 회원정보 입력 후 로그인.
        if (check == 1) { // 계정 있으면
            UserDto dto = service.getUserDtoById(user_id);
            session.setMaxInactiveInterval(60 * 60 * 8); // 8시간
            session.setAttribute("signIn", apiResult);
            session.setAttribute("email", email);
            session.setAttribute("name", name);
            session.setAttribute("loginok", "yes");
            session.setAttribute("myid", user_id);
            session.setAttribute("user_num", dto.getUser_num()); // session에 num값 넣음.
            session.setAttribute("user_photo", dto.getUser_photo());// session에 photo 넣음.
            return "redirect:post/timeline"; // 로그인 하면 타임라인으로 넘어감.
        } else {
            // 계정 로그인 안 되어있으면 db에 넣고(일단회원가입) 로그인 세션 유지
            UserDto user = new UserDto();
            String user_birth;
            user_birth = birthyear + "-" + birthday;
            user.setUser_birth(user_birth);
            user.setUser_email(email);
            if (gender.equalsIgnoreCase("m")) {
                user.setUser_gender("남자");
            } else if (gender.equalsIgnoreCase("f")) {
                user.setUser_gender("여자");
            } else {
                user.setUser_gender("기타");
            }
            user.setUser_hp(mobile);
            user.setUser_id(user_id);
            user.setUser_name(name);
            //user.setUser_pass("naver");


            service.insertOauthUserInfo(user);
            //임시 비밀번호 자동 생성
            MailDto mail_dto = service.createMailAndChangePassword(email);
            service.mailSend(mail_dto);

            UserDto user1 = service.getUserById(user_id);
            session.setMaxInactiveInterval(60 * 60 * 8); // 8시간
            session.setAttribute("signIn", apiResult);
            session.setAttribute("email", user1.getUser_email());
            session.setAttribute("name", user1.getUser_name());
            session.setAttribute("myid", user_id);
            session.setAttribute("loginok", "yes");
            session.setAttribute("user_num", user1.getUser_num()); // session에 num값 넣음.
            session.setAttribute("user_photo", user1.getUser_photo());// session에 photo 넣음.
            service.updateMailAuthByOauthLogin(user1.getUser_num());//mail_auth값이 0에서 1로 바뀜.

            return "redirect:post/timeline";
        }
    }

    @GetMapping("/kakaocallback")
    public String callbackKakao(Model model, @RequestParam String code, @RequestParam String state, HttpSession session)
            throws Exception {
        OAuth2AccessToken oauthToken;
        oauthToken = kakaoLoginBO.getAccessToken(session, code, state);
        // 로그인 사용자 정보를 읽어온다
        apiResult = kakaoLoginBO.getUserProfile(oauthToken);

        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj;

        jsonObj = (JSONObject) jsonParser.parse(apiResult);
        JSONObject response_obj = (JSONObject) jsonObj.get("kakao_account");
        JSONObject response_obj2 = (JSONObject) response_obj.get("profile");

        // 프로필 조회
        String email = (String) response_obj.get("email");
        String name = (String) response_obj2.get("nickname");
        // id 이메일에서 가져오기
        String splitemail[] = email.split("@");
        String user_id;
        user_id = splitemail[0];
        String gender = (String) response_obj.get("gender");

        int check = service.loginEmailCheck(email); // 입력한 이메일이 가입되어있는지 아닌지 판단
        // 이 아래는 아무튼 로그인 한다.
        // 이미 예전에 로그인한 네이버 계정이면 그냥 로그인
        // 아니면 db에 회원정보 입력 후 로그인.
        if (check == 1) { // 계정 있으면
            UserDto dto = service.getUserDtoById(user_id);
            session.setMaxInactiveInterval(60 * 60 * 8); // 8시간
            session.setAttribute("signIn", apiResult);
            session.setAttribute("email", email);
            session.setAttribute("name", name);
            session.setAttribute("loginok", "yes");
            session.setAttribute("myid", user_id);
            session.setAttribute("user_num", dto.getUser_num()); // session에 num값 넣음.
            session.setAttribute("user_photo", dto.getUser_photo());// session에 photo 넣음.
            return "redirect:post/timeline"; // 로그인 하면 타임라인으로 넘어감.
        } else {
            // 계정 로그인 안 되어있으면 db에 넣고(일단회원가입) 로그인 세션 유지
            UserDto user = new UserDto();
            user.setUser_email(email);
            if (gender.equalsIgnoreCase("male")) {
                user.setUser_gender("남자");
            } else if (gender.equalsIgnoreCase("female")) {
                user.setUser_gender("여자");
            } else {
                user.setUser_gender("기타");
            }
            user.setUser_id(user_id);
            user.setUser_name(name);
            //user.setUser_pass("kakao");

            service.insertOauthUserInfo(user);
            //임시 비밀번호 자동 생성
            MailDto mail_dto = service.createMailAndChangePassword(email);
            service.mailSend(mail_dto);
            UserDto user1 = service.getUserById(user_id);
            session.setMaxInactiveInterval(60 * 60 * 8); // 8시간
            session.setAttribute("signIn", apiResult);
            session.setAttribute("email", user1.getUser_email());
            session.setAttribute("name", user1.getUser_name());
            session.setAttribute("myid", user_id);
            session.setAttribute("loginok", "yes");
            session.setAttribute("user_num", user1.getUser_num()); // session에 num값 넣음.
            //session.setAttribute("user_photo", user1.getUser_photo());// session에 photo 넣음.
            service.updateMailAuthByOauthLogin(user1.getUser_num());//mail_auth값이 0에서 1로 바뀜.
            return "redirect:post/timeline";
        }
    }

    @GetMapping("/googlecallback")
    public String googlecallback(Model model, @RequestParam String code, @RequestParam String state,
                                 HttpSession session) throws Exception {
        OAuth2AccessToken oauthToken;
        oauthToken = googleLoginBO.getAccessToken(session, code, state);
        // 로그인 사용자 정보를 읽어온다
        apiResult = googleLoginBO.getUserProfile(oauthToken);
        // System.out.println("apiResult : " + apiResult);

        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj;

        jsonObj = (JSONObject) jsonParser.parse(apiResult);
        JSONObject response_obj = (JSONObject) jsonObj;

        // 프로필 조회
        String email = (String) response_obj.get("email");
        String name = (String) response_obj.get("name");

        // id 이메일에서 가져오기
        String[] splitemail = email.split("@");
        String user_id;
        user_id = splitemail[0];

        int check = service.loginEmailCheck(email); // 입력한 이메일이 가입되어있는지 아닌지 판단

        if (check == 1) {
            UserDto dto = service.getUserDtoById(user_id);
            session.setMaxInactiveInterval(60 * 60 * 8);
            session.setAttribute("signIn", apiResult);
            session.setAttribute("email", email);
            session.setAttribute("name", name);
            session.setAttribute("loginok", "yes");
            session.setAttribute("myid", user_id);
            session.setAttribute("user_num", dto.getUser_num());
            session.setAttribute("user_photo", dto.getUser_photo());
            return "redirect:post/timeline";
        } else {
            UserDto user = new UserDto();
            user.setUser_email(email);
            user.setUser_gender("기타");
            user.setUser_id(user_id);
            user.setUser_name(name);
            //user.setUser_pass("google");

            service.insertOauthUserInfo(user);
            MailDto mail_dto = service.createMailAndChangePassword(email);
            service.mailSend(mail_dto);
            UserDto user1 = service.getUserById(user_id);
            session.setMaxInactiveInterval(60 * 60 * 8);
            session.setAttribute("signIn", apiResult);
            session.setAttribute("email", user1.getUser_email());
            session.setAttribute("name", user1.getUser_name());
            session.setAttribute("myid", user_id);
            session.setAttribute("loginok", "yes");
            session.setAttribute("user_num", user1.getUser_num());
            session.setAttribute("user_photo", user1.getUser_photo());
            service.updateMailAuthByOauthLogin(user1.getUser_num());//mail_auth값이 0에서 1로 바뀜.
            return "redirect:post/timeline";
        }
    }
}
