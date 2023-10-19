package com.sns.handbook.controller;

import com.sns.handbook.dto.UserDto;
import com.sns.handbook.serivce.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SignupController {

    @Autowired
    UserService service;

    @Autowired
    PasswordEncoder passwordEncoder;


    @GetMapping("/signupform")
    public String signupform() {
        return "/sub/login/signup";
    }

    @PostMapping("/signupform/emailcheck")
    @ResponseBody
    public int emailCheck(String email) {
        if (email.equals("")) {
            return -1;
        }

        int result = service.loginEmailCheck(email);
        return result;
    }

    @PostMapping("/signupprocess")
    public String signupprocess(@RequestParam String hp1, @RequestParam String hp2, @RequestParam String hp3,
                                @RequestParam String user_name, @RequestParam String user_email, @RequestParam String user_pass,
                                @RequestParam String user_birth, @RequestParam String user_gender, @RequestParam String addr1,
                                @RequestParam String addr2) throws Exception {

        System.out.println("signupprocess 들어옴");
        String user_addr;
        if (addr2.equals("")) {
            user_addr = addr1;
        } else {
            user_addr = addr1 + "," + addr2;
        }

        String user_hp = hp1 + "-" + hp2 + "-" + hp3;
        String split_user_email[] = user_email.split("@");
        String encodedPassword = passwordEncoder.encode(user_pass);//비밀번호 암호화.

        UserDto user = new UserDto();
        user.setUser_addr(user_addr);
        user.setUser_birth(user_birth);
        user.setUser_email(user_email);
        user.setUser_gender(user_gender);
        user.setUser_hp(user_hp);
        user.setUser_id(split_user_email[0]);
        user.setUser_pass(encodedPassword);
        user.setUser_name(user_name);

        service.insertUserInfo(user);
        //service.updateMailKey(user);
        return "redirect:/";
    }

    //메일함에서 이메일 인증확인 눌렀을때 실행.
    @GetMapping("/signupform/registerEmail")
    public String emailConfirm(UserDto dto) throws Exception {
//		System.out.println("Mail Key: " + dto.getMail_key());
//		System.out.println("User Email: " + dto.getUser_email());
        service.updateMailAuth(dto);//email과 mail_key값이 일치하면 mail_auth값이 0에서 1로 바뀜.

        //그후 이메일 인증 완료 페이지로 감.
        return "/login/emailAuthSuccess";
    }

    //이메일 인증 실패했을 때 다시 요청 했을 때(메일 재요청)
    @GetMapping("/signup/reregisterEmail")
    public String reregisterEmail(String user_num) throws Exception {
        //System.out.println("이메일 발송 버튼 누름");
        //System.out.println("User Number: " + user_num);
        UserDto dto = service.getUserByNum(user_num);
        String mail_key = service.getTempPassword();
        dto.setMail_key(mail_key);

        service.sendEmailLogic(dto, mail_key);
        return "redirect:/";
    }

    @GetMapping("/signup/moveEmailAuthFail")
    public String moveEmailAuthFail() {
        return "redirect:/login/emailAuthFail";
    }
}
