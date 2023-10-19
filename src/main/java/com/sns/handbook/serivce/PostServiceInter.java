package com.sns.handbook.serivce;

import java.util.List;
import java.util.Map;

import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.PostDto;

public interface PostServiceInter {

	public int getTotalCount();
	public void insertPost(PostDto dto);
	public List<PostDto> postList(String user_num,String searchcolumn, String searchword,int offset); //파리미터값 변경
	public void deletePost(String post_num);
	public void updatePost(PostDto dto);
	public PostDto getDataByNum(String post_num);
	public void updatePhoto(String post_num,String post_file);
	
	//logincheck
	public int checklogin(String post_num, String user_num);
	

}
