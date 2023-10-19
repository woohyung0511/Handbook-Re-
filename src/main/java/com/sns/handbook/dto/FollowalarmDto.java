package com.sns.handbook.dto;

import java.sql.Timestamp;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("FollowalarmDto")
public class FollowalarmDto {
	
	private String followal_num;
	private String receiver_num;
	private String sender_num;
	private Timestamp alarmtime;
	
	private String sender_name;
	private String sender_photo;
	
	private long timeSec;
	private String time;
	
	private String type="follow";
}
