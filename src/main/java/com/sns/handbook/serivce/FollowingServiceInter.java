package com.sns.handbook.serivce;




import java.util.List;
import java.util.Map;

import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.UserDto;

public interface FollowingServiceInter {

	public int checkFollowing(String from_user,String to_user);
	public int checkFollower(String to_user,String from_user);
	public int getTotalFollowing(String from_user);
	public int getTotalFollower(String to_user);
	public void insertFollowing(FollowingDto dto);
	public void deleteFollowing(String to_user, String from_user);
	public List<FollowingDto> getFollowList(String from_user, int offset);
	public int togetherFollow(String to_user, String from_user);
	public List<FollowingDto> followSearch(String from_user, String searchword, int offset);
	public List<FollowingDto> followerSearch(String to_user, String searchword, int offset);
	public List<UserDto> followRecommend(String from_user, String searchword, int offset);
	public List<FollowingDto> getFollowingList(String to_user, int offset);
}
