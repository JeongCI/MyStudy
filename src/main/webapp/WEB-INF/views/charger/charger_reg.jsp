<%--
/**
  Class Name:
  Description:
  
  Modification information
  
    수정일     수정자      수정내용
  -----   -----  -------------------------------------------
    2022. 12. 15        최초작성 
    
    author eclass 개발팀 :ITSC
    since 2022.11.24
    Copyright (C) by KandJang All right reserved.
*/
 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<c:set var="CP" value="${pageContext.request.contextPath }"></c:set>
<c:set var="RES" value="/resources" ></c:set>
<c:set var="CP_RES" value="${CP}${RES}" ></c:set>
<!DOCTYPE html>
<html>  
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" type="image/x-icon" href="${CP_RES}/asset/cmn/favicon.ico"> 
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="${CP_RES}/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="${CP_RES}/main_home.css">

<!-- jQuery -->
<script src="${CP_RES}/bootstrap/js/jquery-1.12.4.js"></script>
<!-- callAjax -->
<script src="${CP_RES}/bootstrap/js/callAjax.js"></script>
<!-- String, Number, Date Util  -->
<script src="${CP_RES}/bootstrap/js/eUtil.js"></script>
<!-- paging -->
<script src="${CP_RES}/bootstrap/js/jquery.bootpag.js"></script>
<!-- bootstrap js -->
<script src="${CP_RES}/bootstrap/js/bootstrap.min.js"></script>
<meta charset="UTF-8">
<title>관리자_충전기</title>
<script >
  $(document).ready(function(){
	  console.log("document.ready");
	  
	  
	  function readImage(input) {
	      // 인풋 태그에 파일이 있는 경우
	      if(input.files && input.files[0]) {
	          // 이미지 파일인지 검사 (생략)
	          // FileReader 인스턴스 생성
	          const reader = new FileReader();
	          // 이미지가 로드가 된 경우
	          reader.onload = e => {
	              const previewImage = document.getElementById("preview-image");
	              previewImage.src = e.target.result;
	          }
	          // reader가 이미지 읽도록 하기
	          reader.readAsDataURL(input.files[0]);
	      }
	  }
	  // input file에 change 이벤트 부여
	  const inputImage = document.getElementById("file01");
	  inputImage.addEventListener("change", e => {
	      readImage(e.target);
	  });   
	  
	  
	     //관리자메뉴 이동
      $("#moveToManagerPage").on("click",function(){
        
        console.log('moveToManagerPage');
        
        window.location.href = "${CP}/charger/moveToManagerPage.do";
        
      //moveToManagerPage
      });
	  
	  
	//등록
	    $("#doSave").on("click",function(){
	      console.log("doSave");
	    
	      if(eUtil.ISEmpty($("#connector").val()) == true){
	        alert("충전기명을 입력 하세요.");
	        $("#connector").focus();
	        return;
	      }
	      
	      if(eUtil.ISEmpty($("#image").val()) == true){
	          alert("이미지를 추가 하세요.");
	          $("#image").focus();
	          return;
	      }
	        
	      if(eUtil.ISEmpty($("#ev_current").val()) == true){
	          alert("충전전류을 입력 하세요.");
	          $("#ev_current").focus();
	          return;
	      }       
	      
	      if(eUtil.ISEmpty($("#ev_voltage").val()) == true){
	          alert("충전전압 입력 하세요.");
	          $("#ev_voltage").focus();
	          return;
	      }       

	      if(eUtil.ISEmpty($("#ev_power").val()) == true){
	          alert("충전전력을 입력 하세요.");
	          $("#ev_power").focus();
	          return;
	      }       

	      if(eUtil.ISEmpty($("#ev_level").val()) == true){
	          alert("충전레벨을 입력 하세요.");
	          $("#ev_level").focus();
	          return;
	      }       

	      if(eUtil.ISEmpty($("#ev_support").val()) == true){
	          alert("지원차량을 입력 하세요.");
	          $("#ev_support").focus();
	          return;
	      }       
	        
	      if(confirm("등록 하시겠습니까?")==false)return;
	      
	      let method = "POST";
	      let url    = "/charger/doSave.do";
	      let async  = true;
	      let params = {
	    		  connector : $("#connector").val(),
	    		  image : $("#image").val(),
	    		  ev_current : $("#ev_current").val(),
	    		  ev_voltage : $("#ev_voltage").val(),
	    		  ev_power : $("#ev_power").val(),
	    		  ev_level : $("#ev_level").val(),
	    		  ev_support : $("#ev_support").val()
	      };
	      
	      PClass.callAjax(method,url,async,params,function(data){
	        console.log(data);
	      //JSON.parse() 메서드는 JSON 문자열의 구문을 분석하고, 
	      //그 결과에서 JavaScript 값이나 객체를 생성합니다.
	        let parsedJson = JSON.parse(data);
	      
	        if("1" == parsedJson.msgId){
	          alert(parsedJson.msgContents);
	          moveToManagerPage();
	        }else{
	          alert(parsedJson.msgContents);
	        }
	      
	      });
	      
	      
	    });
	
	    $("#doSaveFile").on("click",function(){
	        console.log("doSaveFile");
	        $("#preview-image").css("display","block");
	        
	        let fileInput = $("#file01")[0];
	        console.log("fileInput: "+fileInput);
	        
	        if(fileInput.files.length === 0){
	          alert("파일을 선택해 주셔요.");
	          return;
	        }
	        
	        console.log("fileInput.files.length: "+fileInput.files.length);
	        
	        //javascript : <form></form>
	        let formData = new FormData();
	        
	        for(let i=0;i<fileInput.files.length;i++){
	          formData.append("image"+i,fileInput.files[i]);
	        }
	        
	        //image란 이름으로, 파일객체 지정
	        
	        
	        //contentType : default값은 "application/x-www-form-urlencoded; charset=UTF-8"
	        //-->multipart/form-data로 전송되도록 false설정
	        //processData : true -> query string으로 데이터 전달! ex)http://localhost:8089?title = 1234
	        
	        console.log("data:formData: "+formData);
	        
	        $.ajax({ 
	           type: "POST",
	           url: "${CP}/file/ajaxUpload.do",
	           processData: false, //
	           contentType: false,
	           asyn: "true",
	           //dataType: "html",
	           data: formData,
	           success:function(data){ //통신 성공
	             console.log(data);
	           
	             let htmlData = "";
	             let imgPath = "";
	             
	             if(null != data && data.length > 0) {
	                   $.each(data, function(index, value) {
	                   ///ehr/resources/asset/imgs/evcar_imgs/G70.png
	                   imgPath = "/ehr"+value.imageViewPath+"/"+value.saveFileName;
	                   });
	             }
	             $("#image").val(imgPath);

	           },
	           error:function(data){//실패
	           
	           },
	           complete:function(data){//성공, 실패 관계 없이 출력
	           
	           }

	        });
	        
	        
	      });//-----------------------------doSaveFile 끝  
	    function moveToManagerPage(){
	        window.location.href="${CP}/charger/moveToManagerPage.do";
	      };

  });
  

  //==================================================================
  //=헤더부분 스크립트 이부분 꼭 넣으세요
  //==================================================================
  
   $(function() {
       let didScroll;
       let lastScrollTop = 0;
       let navbarHeight = $("header").outerHeight();
        $(window).scroll(function(event){
            didScroll = true;
        });
        setInterval(function() {
            if (didScroll) {
                hasScrolled();
                didScroll = false;
            }
        }); // 스크롤이 멈춘 후 동작이 실행되기 까지의 딜레이
        function hasScrolled() {
          if($(this).width() > 700) {       
          let st = $(this).scrollTop(); // 현재 window의 scrollTop 값
              if ($(window).scrollTop() > 50){
                  $(".logo-area").slideUp("fast"); // header 숨기기
                  $(".text-logo-area").addClass("visible");
              } else {
                  if($(window).scrollTop() < 200) {
                      $(".logo-area").slideDown("fast"); // header 보이기
                      $(".text-logo-area").removeClass("visible");
              }
           }
        }
     }
     });
 //==================================================================
 //=헤더부분 스크립트 이부분 꼭 넣으세요
 //==================================================================
	 
</script>

</head>
<body>
<header>
<jsp:include page ="/resources/asset/cmn/main_header.jsp" flush="false"/>
</header>

  <div id="contents">
  
  <div class="container">
    <!-- 제목 -->
    <div class="page-header">
       <h1 style="color: orange;">관리자메뉴</h1><br>
       <h2>충전기 데이터 등록</h2>
    </div>
    <!-- 제목 ------------------------------------------------------------------->
    <!--버튼  -->

    <div class="row text-right ">
        <label for="inputEmail3" class="col-sm-2 col-md-2 col-lg-2 control-label"></label>
        <div class="col-sm-10 col-md-10 col-lg-10">
          <input type="button" class="btn btn-info btn-sm" value="등록"  id="doSave" >
          <input type="button" class="btn btn-primary btn-sm" value="목록"  id="moveToManagerPage" >
        </div>

    </div>
    <!--버튼 -------------------------------------------------------------------->
        <!-- 폼 -->
    <form action="#" class="form-horizontal"> 
    <input type="hidden" id="charger_seq" name="charger_seq" value="${vo.charger_seq}">
    <input type="hidden" id="image" name="image" value="${vo.image}">  
	      <!-- 이미지 미리보기 -->
	      <div class="form-group">
	      <label for="preview-image" class="col-sm-2 col-md-2 col-lg-2 control-label" >미리보기</label>
	        <div class="col-sm-2 col-md-2 col-lg-2">
	          <img style="width:100%; display:none;" id="preview-image" src="#">
	        </div>
	      </div>
	      <!-- 이미지 등록하기 -->
        <div class="form-group">
          <label for="file01" class="col-sm-2 col-md-2 col-lg-2 control-label" >이미지</label>
          <div class="col-sm-10 col-md-10 col-lg-10">
            <input type="file" class="form-control" id="file01" name="file01" placeholder="파일을 입력해주세요" maxlength="100">
            <input type="button" class="btn btn-primary btn-sm" value="사진등록" id="doSaveFile">
          </div>
        </div>
      <div class="form-group">
        <label for="connector" class="col-sm-2 col-md-2 col-lg-2 control-label">충전기명</label>
        <div class="col-sm-10 col-md-10 col-lg-10">
          <input type="text" 
          maxlength="20"
          class="form-control" id="connector" name="connector" placeholder="충전기명을 입력하세요">
        </div>
      </div>

      <div class="form-group">
        <label for="ev_current" class="col-sm-2 col-md-2 col-lg-2 control-label">충전전류</label>
        <div class="col-sm-10 col-md-10 col-lg-10">
          <input type="text" 
          maxlength="20"
          class="form-control" id="ev_current" name="ev_current" placeholder="충전전류를 입력하세요">
        </div>
      </div>

      <div class="form-group">
        <label for="ev_voltage" class="col-sm-2 col-md-2 col-lg-2 control-label">충전전압</label>
        <div class="col-sm-10 col-md-10 col-lg-10">
          <input type="text" 
          maxlength="20"
          class="form-control" id="ev_voltage" name="ev_voltage" placeholder="충전전압을 입력하세요">
        </div>
      </div>

      <div class="form-group">
        <label for="ev_power" class="col-sm-2 col-md-2 col-lg-2 control-label">충전전력</label>
        <div class="col-sm-10 col-md-10 col-lg-10">
          <input type="text" 
          maxlength="20"
          class="form-control" id="ev_power" name="ev_power" placeholder="충전전력을 입력하세요">
        </div>
      </div>

      <div class="form-group">
        <label for="ev_level" class="col-sm-2 col-md-2 col-lg-2 control-label">충전레벨</label>
        <div class="col-sm-10 col-md-10 col-lg-10">
          <input type="text" 
          maxlength="20"
          class="form-control" id="ev_level" name="ev_level" placeholder="충전레벨을 입력하세요">
        </div>
      </div>

      <div class="form-group">
        <label for="ev_support" class="col-sm-2 col-md-2 col-lg-2 control-label">지원차량</label>
        <div class="col-sm-10 col-md-10 col-lg-10">
          <input type="text" 
          maxlength="20"
          class="form-control" id="ev_support" name="ev_support" placeholder="지원차량들을 입력하세요">
        </div>
      </div>
             

                                               
    </form>
    <!--폼   -------------------------------------------------------------------->
  </div>
  
  </div>
  
<footer>
  <jsp:include page="/resources/asset/cmn/main_footer.jsp" flush="false" />
</footer>
</body>
</html>