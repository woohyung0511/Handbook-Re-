package com.sns.handbook.dto;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("CommentDto")
public class CommentDto {

	private String comment_num;
	private String user_num;
	private String post_num;
	private String guest_num;
	private String comment_content;
	private int comment_group;
	private int comment_step;
	private int comment_level;
	private Timestamp comment_writeday;
	
	//이후에 추가한 dto
	private String user_photo;
	private String user_name;
	private String perTime;
	private int like_count;
	private int like_check;
	private String post_user_num;
}
