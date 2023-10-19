package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.mapper.FollowingMapperInter;

@Service
public class FollowingService implements FollowingServiceInter {

	@Autowired
	FollowingMapperInter mapper;
	
	@Override
	public int checkFollowing(String from_user, String to_user) {
		// TODO Auto-generated method stub
		
		Map<String, String> map=new HashMap<>();
		
		map.put("from_user", from_user);
		map.put("to_user", to_user);
		
		return mapper.checkFollowing(map);
	}
	
	@Override
	public int checkFollower(String to_user, String from_user) {
		// TODO Auto-generated method stub
		Map<String, String> map=new HashMap<>();
		
		map.put("to_user", to_user);
		map.put("from_user", from_user);
		
		
		return mapper.checkFollower(map);
	}
	
	@Override
	public void deleteFollowing(String from_user, String to_user) {
		// TODO Auto-generated method stub
		Map<String, String> map = new HashMap<>();
		
		map.put("from_user", from_user);
		map.put("to_user", to_user);
		
		mapper.deleteFollowing(map);
	}
	
	@Override
	public int getTotalFollowing(String from_user) {
		// TODO Auto-generated method stub
		return mapper.getTotalFollowing(from_user);
	}
	
	@Override
	public int getTotalFollower(String to_user) {
		// TODO Auto-generated method stub
		return mapper.getTotalFollower(to_user);
	}
	
	@Override
	public void insertFollowing(FollowingDto dto) {
		// TODO Auto-generated method stub
		mapper.insertFollowing(dto);
	}
	
	@Override
	public List<FollowingDto> getFollowList(String from_user, int offset) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();
		
		map.put("from_user", from_user);
		map.put("offset", offset);
		
		
		return mapper.getFollowList(map);
	}
	
	@Override
	public int togetherFollow(String to_user, String from_user) {
		// TODO Auto-generated method stub
		Map<String, String> map = new HashMap<>();
		
		map.put("to_user", to_user);
		map.put("from_user", from_user);
		
		return mapper.togetherFollow(map);
	}

	@Override
	public List<FollowingDto> followSearch(String from_user, String searchword, int offset) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();
		
		map.put("from_user", from_user);
		map.put("searchword", searchword);
		map.put("offset", offset);
		
		return mapper.followSearch(map);
	}

	@Override
	public List<UserDto> followRecommend(String from_user, String searchword, int offset) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();
		
		map.put("from_user", from_user);
		map.put("searchword", searchword);
		map.put("offset", offset);
		return mapper.followRecommend(map);
	}

	@Override
	public List<FollowingDto> getFollowingList(String to_user, int offset) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();
		
		map.put("to_user", to_user);
		map.put("offset", offset);
		
		return mapper.getFollowingList(map);
	}

	@Override
	public List<FollowingDto> followerSearch(String to_user, String searchword, int offset) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();
		
		map.put("to_user", to_user);
		map.put("searchword", searchword);
		map.put("offset", offset);
		
		return mapper.followerSearch(map);
	}

}
