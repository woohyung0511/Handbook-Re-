package com.sns.handbook.dto;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("PostDto")
public class PostDto {

	
	//table
	private String post_num;
	private String user_num;
	private String post_content;
	private String post_file;
	private String post_access;
	private Timestamp post_writeday;
	
	
	private String user_name;
	private String user_photo;
	
	//add 
	private int comment_count;
	private int like_count;
	private int likecheck;
	private String post_time;
	private int checklogin;
	private int checkfollowing;
	private String type="post";

}
