package com.zero.waste.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.zero.map.MapVO;

@Mapper
public interface MapMapper {
	//@Insert("INSERT INTO shop (shopName, addr, lat, lng, category) VALUES (#{shopName},#{addr}, 0, 0, 0)")
	int registMap(MapVO mapInfo);
	
	int addlatlng(String addr);
	
	List<MapVO> selectMapView();

	List<MapVO> showMapPage();

	List<MapVO> searchKeyword();
	
	List<MapVO> getMapAll(MapVO vo);
}
