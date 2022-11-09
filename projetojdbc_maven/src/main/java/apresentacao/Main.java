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
