package com.sns.handbook.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.GuestbookDto;
import com.sns.handbook.dto.PostDto;
import com.sns.handbook.dto.UserDto;

@Mapper
public interface UserMapperInter {

	public int getTotalCount();
	public int loginIdPassCheck(Map<String, String> map);
	
	//예지
	public UserDto getUserById(String user_id);
	public UserDto getUserByNum(String user_num);

	//우형 시작
	public void updateCover(Map<String, String> map);
	public List<UserDto> getAllUsers();
	public void updatePhoto(Map<String, String> map);
	public List<PostDto> getPost(String user_num);
	public void updateUserInfo(UserDto dto);
	public List<FollowingDto> getFollowList(Map<String, Object> map);
	public void insertGuestBook(GuestbookDto dto);
	public List<GuestbookDto> getGuestPost(String owner_num);
	public void deleteGuestBook(String guest_num);
	public void updateGuestBook(GuestbookDto dto);
	public GuestbookDto getDataByGuestNum(String guest_num);
	public List<PostDto> selectPostsByAccess(Map<String, String> map);
	public List<GuestbookDto> selectGuestbookByAccess(Map<String, String> map);
	//우형 끝
	
	//희수 시작
	public void insertUserInfo(UserDto dto);
	public void insertOauthUserInfo(UserDto dto);
	public UserDto getUserDtoById(String user_id);
	public int loginEmailCheck(String user_email);
	public String getUserIdByEmail(String user_email);
	public void updatePassword(Map<String, String> map);
	public String getUserEmailBynamehp(Map<String ,String> map);
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
