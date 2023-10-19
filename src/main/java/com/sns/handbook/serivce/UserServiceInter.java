package com.sns.handbook.serivce;

import java.util.List;
import java.util.Map;

import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.GuestbookDto;
import com.sns.handbook.dto.MailDto;
import com.sns.handbook.dto.PostDto;
import com.sns.handbook.dto.UserDto;

public interface UserServiceInter {

	public int getTotalCount();
	public int loginIdPassCheck(String user_id, String user_pass);
	
	//예지
	public UserDto getUserById(String user_id);
	public UserDto getUserByNum(String user_num);
	
	//우형 시작	
	public void updateCover(String user_num,String user_cover);
	public List<UserDto> getAllUsers();
	public void updatePhoto(String user_num,String user_photo);
	public List<PostDto> getPost(String user_num);
	public void updateUserInfo(UserDto dto);
	public List<FollowingDto> getFollowList(String from_user, int offset);
	public void insertGuestBook(GuestbookDto dto);
	public List<GuestbookDto> getGuestPost(String owner_num);
	public void deleteGuestBook(String guest_num);
	public void updateGuestBook(GuestbookDto dto);
	public GuestbookDto getDataByGuestNum(String guest_num);
	public List<PostDto> selectPostsByAccess(String user_num,String from_user);
	public List<GuestbookDto> selectGuestbookByAccess(String user_num,String owner_num);
	//우형 끝	

	//희수 시작
	public void insertUserInfo(UserDto dto) throws Exception;
	public void insertOauthUserInfo(UserDto dto);
	public UserDto getUserDtoById(String user_id);
	public int loginEmailCheck(String user_email);

	public MailDto createMailAndChangePassword(String memberEmail);
	public void updatePassword(String user_num, String user_pass);
	public String getTempPassword();
	public void mailSend(MailDto mailDto);
	public String getUserIdByEmail(String user_email);
	public String getUserEmailBynamehp(String user_name, String user_hp);
	public int loginIdCheck(String user_id);
	public void userDelete(String user_num);
	public int updateMailKey(UserDto dto) throws Exception;
	public int updateMailAuth(UserDto dto) throws Exception;
	public int emailAuthFail(String user_num) throws Exception;
	public void updateUserPass(UserDto dto);
	public void updateMailAuthByOauthLogin(String user_num);
	//희수 끝
	
	//예지
	public List<UserDto> getUserByName(String user_name);
}
