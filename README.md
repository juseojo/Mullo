<h1>어플리케이션 Mullo</h1>
<h3>&#8226; 고민 투표 어플리케이션</h3>
<body> 
    <h3>전체구성</h3>
    <img src="mullo_all.png" alt="전체 구성">
    <ul>
        <li>로그인 화면</li>
        <li>메인 화면</li>
        <li>댓글 화면</li>
        <li>설정 화면</li>
        <li>유저정보 화면</li>
        <li>게시글 작성 화면</li>
    </ul>
    <hr>
    <h3>사용된 기술</h3>
      <p>MVVM, Code-Base UI, UIKit, snapKit, realmDB, Alamofire, aws EC2, Flask, Figma</p>
    <h3>새로 사용한 기술과 이유</h3>
    <ul>
        <li><b>RxSwift</b> : Collection view에서 데이터 바인딩할때 복잡도가 너무 올라가 사용</li>
        <li><b>amazon S3</b> : 게시글에 이미지를 넣기위해 사용</li>
        <li><b>Firebase Auth</b> : 이메일로 로그인, 회원가입하기 위해 사용</li>
        <li><b>Kingfisher</b> : 게시글 이미지를 효율적으로 게시하기 위해 사용</li>
    </ul>
    <hr>
    <h3>코드 구성</h3>
    <img src="mullo_code.png" alt="코드 구성">
    <h5>Main VC 중심으로 코드를 구성</h5>
</body>
