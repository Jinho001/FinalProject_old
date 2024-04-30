package com.zero.waste.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import com.zero.map.MapVO;
@Mapper
public interface MapMapper {
	//@Insert("INSERT INTO shop (shopName, addr, lat, lng, category) VALUES (#{shopName},#{addr}, 0, 0, 0)")
	int registMap(MapVO mapInfo);
	
	int addlatlng(String addr);
}
