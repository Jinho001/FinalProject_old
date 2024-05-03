package com.zero.map;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zero.waste.mapper.MapMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MapServiceImpl implements MapService {
	
	@Autowired
	private final MapMapper mapMapper;
	
	@Override
	public int registMap(MapVO mapInfo) {
		return mapMapper.registMap(mapInfo);
	}

	@Override 
	public List<MapVO> selectMapView() {
		return mapMapper.selectMapView();
	}

	@Override
	public List<MapVO> getMapAll(MapVO vo){
		return mapMapper.getMapAll(vo);
	}


}
