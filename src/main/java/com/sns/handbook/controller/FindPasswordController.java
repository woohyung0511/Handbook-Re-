package com.sns.handbook.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sns.handbook.dto.MailDto;
import com.sns.handbook.serivce.UserService;

@Controller
public class FindPasswordController {

	@Autowired
	UserService service;

	@GetMapping("/find/findpass")
	public String findpass() {
		return "/sub/login/findpass";
	}

	//임시 비밀번호 발급 로직.
	@PostMapping("/find/sendEmail")
	public String sendEmail(@RequestParam("memberEmail") String memberEmail) {
		MailDto dto = service.createMailAndChangePassword(memberEmail);
		service.mailSend(dto);
		return "redirect:/";
	}
	
	@GetMapping("/find/findemail")
	public String findemail() {
		return "/sub/login/findemail";
	}

	// 찾기 버튼 누르면 실행되는 로직.
	@PostMapping("/find/findemailaction")
	@ResponseBody
	public String findemailaction(Model model, @RequestParam String user_name,
								  @RequestParam String hp1, @RequestParam String hp2, @RequestParam String hp3) {
		String email = "";
		String hp = hp1+"-"+hp2+"-"+hp3;

		try {
			email = service.getUserEmailBynamehp(user_name, hp);
			model.addAttribute(email);
		} catch (Exception e) {
			email = "해당하는 이메일 없음";
			model.addAttribute(email);
		}
		//System.out.println(email);
		return email;
	}
}
