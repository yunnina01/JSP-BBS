package com.example.jspbbs.bbs;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(value="/BbsSearchServlet")
public class BbsSearchServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String bbsTitle = request.getParameter("bbsTitle");
        response.getWriter().write(getJSON(bbsTitle));
    }

    public String getJSON(String bbsTitle) {
        if (bbsTitle == null || bbsTitle.equals("")) {
            bbsTitle = "%";
        }
        BbsDAO bbsDAO = new BbsDAO();
        ArrayList<Bbs> bbsList = bbsDAO.search(bbsTitle);

        StringBuffer result = new StringBuffer("");
        result.append("{\"result\":[");
        for (int i = 0; i < bbsList.size(); i++) {
            result.append("[{\"value\": \"" + bbsList.get(i).getBbsID() + "\"},");
            result.append("{\"value\": \"" + bbsList.get(i).getBbsTitle() + "\"},");
            result.append("{\"value\": \"" + bbsList.get(i).getUserID() + "\"},");
            result.append("{\"value\": \"" + bbsList.get(i).getBbsDate() + "\"}],");
        }
        result.append("]}");
        return result.toString();
    }
}