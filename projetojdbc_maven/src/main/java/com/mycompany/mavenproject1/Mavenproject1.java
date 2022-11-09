/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Project/Maven2/JavaApp/src/main/java/${packagePath}/${mainClassName}.java to edit this template
 */

package com.mycompany.mavenproject1;

import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author iapereira
 */
public class Mavenproject1 {

    public static void main(String[] args) throws SQLException {
        
        String dbname = "postgres";
        DriverManager.getConnection("jdbc:postgresql://localhost:5432/"+dbname, "postgres", "postgres");
    }
}
