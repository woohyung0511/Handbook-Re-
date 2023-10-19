package com.sns.handbook.dto;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("PostalarmDto")
public class PostalarmDto {

	private String postal_num;
	private String receiver_num;
	private String sender_num;
	private String post_num;
	private String guest_num;
	private String comment_content;
	private Timestamp comment_writeday;

	private String sender_name;
	private String sender_photo;
	
	private long timeSec;
	private String time;
	
	private String type="post";
}
