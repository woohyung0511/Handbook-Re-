package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sns.handbook.handler.SignupMailHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.GuestbookDto;
import com.sns.handbook.dto.MailDto;
import com.sns.handbook.dto.PostDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.mapper.UserMapperInter;

@Service
public class UserService implements UserServiceInter {

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	UserMapperInter mapperInter;

	@Override
	public int getTotalCount() {
		// TODO Auto-generated method stub
		return mapperInter.getTotalCount();
	}

	@Override
	public int loginIdPassCheck(String user_id, String user_pass) {
		Map<String, String> map = new HashMap<>();
		map.put("user_id", user_id);
		map.put("user_pass", user_pass);
		return mapperInter.loginIdPassCheck(map);
	}

	// 예지
	@Override
	public UserDto getUserById(String user_id) {
		// TODO Auto-generated method stub
		return mapperInter.getUserById(user_id);
	}

	@Override
	public UserDto getUserByNum(String user_num) {
		// TODO Auto-generated method stub
		return mapperInter.getUserByNum(user_num);
	}

	//커버 사진 변경
	@Override
	public void updateCover(String user_num, String user_cover) {
		Map<String, String> params = createParamMap("user_num", user_num, "user_cover", user_cover);
		mapperInter.updateCover(params);
	}
	//값 넘겨주기
	private Map<String, String> createParamMap(String key1, String value1, String key2, String value2){
		Map<String, String> map =new HashMap<>();
		map.put(key1, value1);
		map.put(key2, value2);
		
		return map;
	}

	@Override
	public List<UserDto> getAllUsers() {
		// TODO Auto-generated method stub
		return mapperInter.getAllUsers();

	}
	//프로필 사진 변경
	@Override
	public void updatePhoto(String user_num, String user_photo) {
		// TODO Auto-generated method stub
		Map<String, String> params  = createParamMap("user_num", user_num, "user_photo", user_photo);
		mapperInter.updatePhoto(params);
	}

	@Override
	public List<PostDto> getPost(String user_num) {
		// TODO Auto-generated method stub
		return mapperInter.getPost(user_num);
	}

	@Override
	public void updateUserInfo(UserDto dto) {
		// TODO Auto-generated method stub
		mapperInter.updateUserInfo(dto);
	}


	@Override
	public List<FollowingDto> getFollowList(String from_user, int offset) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();

		map.put("from_user", from_user);
		map.put("offset", offset);


		return mapperInter.getFollowList(map);
	}

	@Override
	public void insertGuestBook(GuestbookDto dto) {
		// TODO Auto-generated method stub
		mapperInter.insertGuestBook(dto);
	}

	@Override
	public List<GuestbookDto> getGuestPost(String owner_num) {
		// TODO Auto-generated method stub
		return mapperInter.getGuestPost(owner_num);
	}
	
	@Override
	public void deleteGuestBook(String guest_num) {
		// TODO Auto-generated method stub
		mapperInter.deleteGuestBook(guest_num);
	}
	
	@Override
	public void updateGuestBook(GuestbookDto dto) {
		// TODO Auto-generated method stub
		mapperInter.updateGuestBook(dto);
	}
	
	@Override
	public GuestbookDto getDataByGuestNum(String guest_num) {
		// TODO Auto-generated method stub
		return mapperInter.getDataByGuestNum(guest_num);
	}

	@Override
	public List<PostDto> selectPostsByAccess(String user_num, String from_user) {
		// TODO Auto-generated method stub
		Map<String, String> map = new HashMap<>();

		map.put("user_num", user_num);
		map.put("from_user", from_user);

		return mapperInter.selectPostsByAccess(map);
	}
	

	@Override
	public List<GuestbookDto> selectGuestbookByAccess(String user_num, String owner_num) {
		// TODO Auto-generated method stub
		Map<String, String> map = new HashMap<>();

		map.put("user_num", user_num);
		map.put("owner_num", owner_num);

		return mapperInter.selectGuestbookByAccess(map);
	}

	//우형 끝	

	//희수 시작
	@Override
	public void insertUserInfo(UserDto dto) throws Exception {
		//일반 회원가입은 이메일인증을 하는 로직 추가.
		System.out.println("회원가입 메서드 들어옴.");
		String mail_key = getTempPassword();
		dto.setMail_key(mail_key);


		// 회원 가입
		mapperInter.insertUserInfo(dto);
		sendEmailLogic(dto, mail_key);
	}

	public void sendEmailLogic(UserDto dto, String mail_key) throws Exception {
		mapperInter.updateMailKey(dto);

		//회원가입완료후 인증이메일 발송
		SignupMailHandler sendMail = new SignupMailHandler(mailSender);
		sendMail.setSubject("[handbook 인증메일 입니다.]"); //메일제목
		sendMail.setText(
				"<h1>handbook 메일인증</h1>" +
						"<br>handbook 오신것을 환영합니다!" +
						"<br>아래 [이메일 인증 확인]을 눌러주세요." +
						"<br><a href='http://localhost:7777/signupform/registerEmail?user_email=" + dto.getUser_email() +
						"&mail_key=" + mail_key +
						"' target='_blank'>이메일 인증 확인</a>");
		sendMail.setFrom("handbookspring@gmail.com", "handbook");
		System.out.println("보낼 유저 이메일 : "+ dto.getUser_email());
		sendMail.setTo(dto.getUser_email());
		sendMail.send();
	}

	@Override
	public void insertOauthUserInfo(UserDto dto) {
		//oauth 회원가입은 이메일인증을 하지 않는다.
		mapperInter.insertOauthUserInfo(dto);
	}

	@Override
	public UserDto getUserDtoById(String user_id) {
		return mapperInter.getUserDtoById(user_id);
	}

	@Override
	public int loginEmailCheck(String user_email) {
		return mapperInter.loginEmailCheck(user_email);
	}

	@Override
	public MailDto createMailAndChangePassword(String memberEmail) {
		String temporaryPass = getTempPassword();
        MailDto dto = new MailDto();
        dto.setAddress(memberEmail);
        dto.setTitle("Handbook 임시비밀번호 안내 이메일 입니다.");
        dto.setMessage("안녕하세요. Handbook 임시비밀번호 안내 관련 이메일 입니다." + " 회원님의 임시 비밀번호는 "
                + temporaryPass + " 입니다." + "로그인 후에 비밀번호를 변경을 해주세요");
        String user_num = getUserIdByEmail(memberEmail);
        updatePassword(user_num, temporaryPass);
        return dto;
	}

	@Override
	public void updatePassword(String user_num, String user_pass) {
		Map<String, String> map = new HashMap<>();
        map.put("user_pass", user_pass);
        map.put("user_num", user_num);
		mapperInter.updatePassword(map);
	}

	@Override
	public String getTempPassword() {
		char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
                'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
        String str = "";

        // 문자 배열 길이의 값을 랜덤으로 10개를 뽑아 구문을 작성함
        int idx = 0;
        for (int i = 0; i < 10; i++) {
            idx = (int) (charSet.length * Math.random());
            str += charSet[idx];
        }
        return str;
	}

	@Override
	public void mailSend(MailDto mailDto) {
		//System.out.println("전송 완료!");
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(mailDto.getAddress());
        message.setSubject(mailDto.getTitle());
        message.setText(mailDto.getMessage());
        message.setFrom("handbookspring@gmail.com");
        message.setReplyTo("handbookspring@gmail.com");
        //System.out.println("message"+message);
        mailSender.send(message);
	}

	@Override
	public String getUserIdByEmail(String user_email) {
		return mapperInter.getUserIdByEmail(user_email);
	}

	@Override
	public String getUserEmailBynamehp(String user_name, String user_hp) {
		Map<String, String> map = new HashMap<>();
		map.put("user_name", user_name);
		map.put("user_hp", user_hp);
		return mapperInter.getUserEmailBynamehp(map);
	}

	@Override
	public int loginIdCheck(String user_id) {
		return mapperInter.loginIdCheck(user_id);
	}

	@Override
	public void userDelete(String user_num) {
		mapperInter.userDelete(user_num);
	}

	@Override
	public int updateMailKey(UserDto dto) throws Exception {
		return mapperInter.updateMailKey(dto);
	}

	@Override
	public int updateMailAuth(UserDto dto) throws Exception {
		return mapperInter.updateMailAuth(dto);
	}

	@Override
	public int emailAuthFail(String user_num) throws Exception {
		return mapperInter.emailAuthFail(user_num);
	}

	@Override
	public void updateUserPass(UserDto dto) {
		mapperInter.updateUserPass(dto);
	}

	@Override
	public void updateMailAuthByOauthLogin(String user_num) {
		mapperInter.updateMailAuthByOauthLogin(user_num);
	}
	// 희수 끝

	//예지
	@Override
	public List<UserDto> getUserByName(String user_name) {
		// TODO Auto-generated method stub
		return mapperInter.getUserByName(user_name);
	}



}
