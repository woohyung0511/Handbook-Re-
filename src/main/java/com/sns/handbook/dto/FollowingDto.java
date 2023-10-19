package com.sns.handbook.dto;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("FollowingDto")
public class FollowingDto {

	private String fing_num;
	private String from_user;
	private String to_user;

	private String user_num;
	private String user_name;
	private String user_photo;
	
	private int tf_count;
	
	private int bookmarkcheck;
	private String bfriend_num;
	private String owner_num;
}
