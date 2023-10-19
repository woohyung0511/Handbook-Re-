package com.sns.handbook.controller;

import com.sns.handbook.oauth.GoogleLoginBO;
import com.sns.handbook.oauth.KakaoLoginBO;
import com.sns.handbook.oauth.NaverLoginBO;
import com.sns.handbook.serivce.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

@Controller
public class MainController {

    /* NaverLoginBO */
    @Autowired
    private NaverLoginBO naverLoginBO;
    // private String apiResult = null;

    /* KakaoLogin */
    @Autowired
    private KakaoLoginBO kakaoLoginBO;

    /* GoogleLogin */
    @Autowired
    private GoogleLoginBO googleLoginBO;

    @Autowired
    UserService uservice;

    @RequestMapping("/")
    public ModelAndView start(HttpSession session) {
        ModelAndView mv = new ModelAndView();
        String loginok = (String) session.getAttribute("loginok"); // 로그인상태인지 아닌지 확인

        int totalCount = uservice.getTotalCount();
        mv.addObject("total", totalCount);

        // 로그인이 안되어있으면, 로그인 폼으로 이동
        if (loginok == null) {
            // 네이버 로그인 인증 URL을 생성하기 위하여 naverLoginBO클래스의 getAuthorizationUrl메소드 호출
            String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
            // 생성한 인증 URL을 View로 전달
            mv.addObject("urlNaver", naverAuthUrl);// loginmain.jsp에서 ${urlNaver}로 쓴다.

            // 카카오 로그인 url
            String kakaoAuthUrl = kakaoLoginBO.getAuthorizationUrl(session);
            // 생성한 인증 URL을 View로 전달
            mv.addObject("urlKakao", kakaoAuthUrl);

            /* 구글 로그인 url */
            String googleAuthUrl = googleLoginBO.getAuthorizationUrl(session);
            /* 생성한 인증 URL을 View로 전달 */
            mv.addObject("urlGoogle", googleAuthUrl);

            mv.setViewName("/sub/login/loginmain");
        } else {
            // 로그인이 되어있으면 타임라인으로 이동
            mv.setViewName("redirect:/post/timeline");
        }
        return mv;
    }
}
