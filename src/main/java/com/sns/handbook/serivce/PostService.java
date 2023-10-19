package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.catalina.mapper.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.PostDto;
import com.sns.handbook.mapper.PostMapperInter;

@Service
public class PostService implements PostServiceInter {

	@Autowired
	PostMapperInter pmapperInter;

	@Override
	public int getTotalCount() {
		// TODO Auto-generated method stub
		return pmapperInter.getTotalCount();
	}

	@Override
	public void insertPost(PostDto dto) {
		// TODO Auto-generated method stub
		pmapperInter.insertPost(dto);
	}

	@Override
	public List<PostDto> postList(String user_num,String searchcolumn, String searchword, int offset) { // 파라미터값 변경
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();

		map.put("user_num", user_num);
		map.put("searchcolumn", searchcolumn);
		map.put("searchword", searchword);
		map.put("offset", offset);

		return pmapperInter.postList(map);
	}

	@Override
	public void deletePost(String post_num) {
		// TODO Auto-generated method stub
		pmapperInter.deletePost(post_num);
	}

	@Override
	public void updatePost(PostDto dto) {
		// TODO Auto-generated method stub
		pmapperInter.updatePost(dto);
	}

	@Override
	public PostDto getDataByNum(String post_num) {
		// TODO Auto-generated method stub
		return pmapperInter.getDataByNum(post_num);
	}

	@Override
	public void updatePhoto(String post_num, String post_file) {
		// TODO Auto-generated method stub

		Map<String, String> map = new HashMap<>();
		map.put("post_num", post_num);
		map.put("post_file", post_file);

		pmapperInter.updatePhoto(map);

	}

	@Override
	public int checklogin(String post_num, String user_num) {
		// TODO Auto-generated method stub

		Map<String, String> map = new HashMap<>();
		map.put("post_num", post_num);
		map.put("user_num", user_num);

		return pmapperInter.checklogin(map);
	}


}
