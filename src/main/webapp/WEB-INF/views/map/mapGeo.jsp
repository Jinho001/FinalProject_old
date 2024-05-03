<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제로웨이스트 지도 추가</title>
</head>

<body>

<div id="map" style="width:100%;height:350px;"></div>
<div id="clickLatlng"></div>


<form id="addressForm">
    <input type="text" id="addressInput" placeholder="주소를 입력하세요" value="서울 종로구 사직로 161">
    <button type="submit">가게 조회</button>
</form>

<form name="regimap" method="post" action="/regimap" onsubmit="return validateForm()">
    <input type="text" name="shopName" id="shopName" value="가게 이름">
    <input type="hidden" name="addr" id="addr">
    <input type="hidden" name="lat" id="lat">
    <input type="hidden" name="lng" id="lng">
    <select id="category" name="category">
        <option value="5">베지테리안 옵션 가능</option>
        <option value="4">비건 식당</option>
        <option value="6">제로웨이스트샵</option>
    </select>
    <button type="submit">제출</button>
</form>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=39fcd7968ea1b9004701e015d2c75467&libraries=services"></script>
<script>
var mapContainer = document.getElementById('map'); // 지도를 표시할 div 
var addressForm = document.getElementById('addressForm'); // 주소 입력 폼
var addressInput = document.getElementById('addressInput'); // 주소 입력 필드

function validateForm() {
    var category = document.getElementById("category").value;
    // 문자열을 숫자로 변환
    var categoryInt = parseInt(category);
    // 숫자로 변환된 값을 다시 input 태그의 value에 설정
    document.getElementById("category").value = categoryInt;
    return true; // 폼 제출
}

function validateForm() {
    var shopName = document.getElementById("shopName").value;
    var addr = document.getElementById("addr").value;
    // 주소, 상점명을 입력하지 않았을 때 
    if (shopName === "" || addr === "") {
        alert("상점 이름과 주소를 입력하세요.");
        return false;
    }
    return true;
}

	mapOption = {
	center : new kakao.maps.LatLng(37.55489, 126.9708), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

addressForm.addEventListener('submit', function(event) {
    event.preventDefault(); // 기본 이벤트 방지

    var address = addressInput.value; // 입력된 주소 가져오기

    // 주소-좌표 변환 객체를 생성합니다
    var geocoder = new kakao.maps.services.Geocoder();
    
    // 주소로 좌표를 검색합니다
    geocoder.addressSearch(address, function(result, status) {
        // 정상적으로 검색이 완료됐으면 
        if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            var lat = parseFloat(result[0].y);
        	var lng = parseFloat(result[0].x);
        	var addrData = address;
        	
        	document.getElementById('addr').value = addrData;
        	document.getElementById('lat').value = lat;
        	document.getElementById('lng').value = lng;
        	
            var resultDiv = document.getElementById('clickLatlng'); 
        	// lat, lng 값 확인 시 주석 풀면 됩니다
        	resultDiv.innerHTML = lat + ' ' + lng;
        	
            // 결과값으로 받은 위치를 마커로 표시합니다
            var marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });

            // 인포윈도우로 장소에 대한 설명을 표시합니다
            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="width:150px;text-align:center;padding:6px 0;">장소</div>'
            });
            infowindow.open(map, marker);

            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
            map.setCenter(coords);
        } 
    });    
});
</script>
</body>
</html>
