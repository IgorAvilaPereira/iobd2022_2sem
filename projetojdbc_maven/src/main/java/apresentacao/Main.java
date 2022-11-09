/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Project/Maven2/JavaApp/src/main/java/${packagePath}/${mainClassName}.java to edit this template
 */

package apresentacao;

import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author iapereira
 */
public class Main {

    public static void main(String[] args) {        
        String dbname = "postgres";
        try {
            DriverManager.getConnection("jdbc:postgresql://localhost:5432/"+dbname, "postgres", "postgres");
            System.out.println("CONECTADO COM SUCESSO!");
        } catch (SQLException e){
            System.out.println("ERRO DE CONEXAO!");
        }
    }
}
