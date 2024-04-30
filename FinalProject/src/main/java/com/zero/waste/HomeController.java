package com.zero.waste;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller // Controller 등록
@RequiredArgsConstructor //lombok, final 생성자 자동 생성
public class HomeController {
	
	@RequestMapping("/index")
	public String test() {
		return "index";
	}
}
