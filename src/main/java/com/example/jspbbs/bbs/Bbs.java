package com.example.jspbbs.bbs;

import lombok.Data;

@Data
public class Bbs {
    private int bbsID;
    private String bbsTitle;
    private String userID;
    private String bbsDate;
    private String bbsContent;
    private int bbsAvailable;
}
