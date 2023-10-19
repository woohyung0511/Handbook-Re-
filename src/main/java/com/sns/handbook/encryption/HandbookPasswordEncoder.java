package com.sns.handbook.encryption;

import org.springframework.context.annotation.Scope;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

//PasswordEncoder 구현(하나의 객체만 쓰기 위함)
@Component
@Scope("singleton")
public class HandbookPasswordEncoder implements PasswordEncoder {

    @Override
    public String encode(CharSequence rawPassword) {
        // 비밀번호를 암호화하여 반환하는 로직
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        //System.out.println("password인코딩했다 appconfig에서 호출");
        return encoder.encode(rawPassword);
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        // 입력받은 비밀번호(rawPassword)와 저장된 암호화된 비밀번호(encodedPassword)를 비교하는 로직
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        //System.out.println("password비교한다! appconfig에서 호출");
        return encoder.matches(rawPassword, encodedPassword);
    }

}
