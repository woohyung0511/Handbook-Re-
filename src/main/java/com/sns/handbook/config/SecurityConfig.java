package com.sns.handbook.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

//https://spring.io/blog/2022/02/21/spring-security-without-the-websecurityconfigureradapter deprecated 설명
//https://devlog-wjdrbs96.tistory.com/434
//https://pika-chu.tistory.com/608 기본로그인 화면 제거
//아래 코드는 모든 요청에 대한 접근을 허용하기 때문에 보안에 문제를 일으킬 수 있다.
@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http
                .csrf().disable()
                .authorizeRequests()
                .antMatchers("/**").permitAll() // "/","/image/**", .antMatchers에 있었던것
                //.anyRequest().authenticated()//이 설정은 모든 요청이 인증을 받아야 함을 의미합니다.
                .and()
                .formLogin()
                .loginPage("/user/login") //default : .loginPage("/user/login")
                .permitAll()
                .and()
                .logout()
                .permitAll();
        return http.build();
    }
}
/*
 * antMatchers에 누구나 접근할수있는 경로를 넣어준다.
 * /** 는 resources 경로의 모든 하위 경로(디렉토리) 매핑 /* 는 바로 아래 하위만 이라 적지않음.
 * /image/**를 해줘야 image/logobtn에 접근이 가능. /image/* 만하면 /logobtn 접근 불가.
 *
 */

/*
 * 
 * 		String[] staticResources  =  {
                "/css/**",
                "/images/**",
                "/fonts/**",
                "/scripts/**",
            };
            */
