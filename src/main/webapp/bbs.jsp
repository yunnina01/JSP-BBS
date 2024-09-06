<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.example.jspbbs.bbs.BbsDAO" %>
<%@ page import="com.example.jspbbs.bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width", initial-scale="1">
    <title>JSP-BBS</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/custom.css">
    <style type="text/css">
        a, a:hover {
            color: #000000;
            text-decoration: none;
        }
    </style>
    <script type="text/javascript">
        let request = new XMLHttpRequest();
        function searchFunction() {
            request.open("POST", "./BbsSearchServlet?bbsTitle="
                + encodeURIComponent(document.getElementById("bbsTitle").value), true);
            request.onreadystatechange = searchProcess;
            request.send(null);
        }

        function searchProcess() {
            let table = document.getElementById("ajaxTable");
            table.innerHTML = "";
            if (request.readyState == 4 && request.status == 200) {
                let object = eval('(' + request.responseText + ')');
                let result = object.result;
                for (let i = 0; i < result.length; i++) {
                    let row = table.insertRow();
                    for (let j = 0; j < result[i].length; j++) {
                        let cell = row.insertCell(j);
                        cell.innerHTML = result[i][j].value;
                    }
                }
            }
        }
    </script>
</head>
<body>
    <%
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }
        int pageNumber = 1;
        if (request.getParameter("pageNumber") != null) {
            pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
        }
    %>
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed"
                    data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">Home</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
                <li class="active"><a href="bbs.jsp">게시판</a></li>
            </ul>
            <%
                if (userID == null) {
            %>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                        aria-expanded="false">접속하기<span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="login.jsp">로그인</a></li>
                            <li><a href="join.jsp">회원가입</a></li>
                        </ul>
                    </li>
                </ul>
            <%
                } else {
            %>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                           aria-expanded="false">회원관리<span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="logoutAction.jsp">로그아웃</a></li>
                        </ul>
                    </li>
                </ul>
            <%
                }
            %>
        </div>
    </nav>
    <div class="container">
        <div class="form-group row pull-right">
            <div class="col-xs-8">
                <input id="bbsTitle" type="text" class="form-control" size="20" onkeyup="searchFunction();">
            </div>
            <div class="col-xs-2">
                <button type="button" class="btn btn-primary" onclick="searchFunction();">검색</button>
            </div>
        </div>
        <div class="row">
            <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                <thead>
                    <tr>
                        <th style="background-color: #eeeeee; text-align: center;">번호</th>
                        <th style="background-color: #eeeeee; text-align: center;">제목</th>
                        <th style="background-color: #eeeeee; text-align: center;">작성자</th>
                        <th style="background-color: #eeeeee; text-align: center;">작성시간</th>
                    </tr>
                </thead>
                <tbody id="ajaxTable">
                    <%
                        BbsDAO bbsDAO = new BbsDAO();
                        ArrayList<Bbs> bbsList = bbsDAO.getList(pageNumber);
                        for (int i = 0; i < bbsList.size(); i++) {
                    %>
                        <tr>
                            <td><%= bbsList.get(i).getBbsID() %></td>
                            <td><a href="view.jsp?bbsID=<%= bbsList.get(i).getBbsID() %>">
                                <%= bbsList.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
                                        .replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
                            <td><%= bbsList.get(i).getUserID() %></td>
                            <td><%= bbsList.get(i).getBbsDate().substring(0, 13) + "시"
                                    + bbsList.get(i).getBbsDate().substring(14, 16) + "분" %></td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                if (pageNumber != 1) {
            %>
                <a href="bbs.jsp?pageNumber=<%= pageNumber - 1 %>" class="btn btn-success btn-arraw-left">이전</a>
            <%
                }
                if (bbsDAO.nextPage(pageNumber + 1)) {
            %>
                <a href="bbs.jsp?pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arraw-right">다음</a>
            <%
                }
            %>
            <a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>