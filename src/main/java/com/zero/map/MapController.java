package com.zero.map;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MapController {
	
	private final MapService mapService;
	@GetMapping("/regimap")
	public String regist() {
		return "map/mapGeo";
	}
	
	@PostMapping("/regimap")
	public String registMap(MapVO mapInfo) {
		mapService.registMap(mapInfo);
		return "map/mapGeo";
	}
	
	@GetMapping("/mapList")
	public String mapList(Model m) {
		//DB에서 메뉴 리스트 가져오기
		List<MapVO> mapList = mapService.selectMapView();
		//log.info("hi");
		//가져온 리스트를 화면에 전달하기
		m.addAttribute("mapList", mapList);
		return "map/map";
	
	}
	
	@GetMapping(value="/mapSidebar2")
	public String mapSidebar2(Model m) {
		return "map/mapSidebar";
	}
	
	

	@GetMapping(value="/mapSidebar", produces="application/json; charset=UTF-8")
	@ResponseBody
	
	    public List<MapVO> mapList(MapVO vo) {
		System.out.print(vo);
		return mapService.getMapAll(vo);
	
	}
}