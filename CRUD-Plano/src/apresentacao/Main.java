/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package apresentacao;

import java.sql.*;
import java.util.Scanner;

/**
 *
 * @author iapereira
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            Scanner entrada = new Scanner(System.in);
            Connection conexao = DriverManager.getConnection("jdbc:postgresql://localhost:5432/aula030822", "postgres", "postgres");
            String str_menu = "1) insere, 2) delete, 3) update, 4) listar 0) sair";
            System.out.println(str_menu);
            int menu = entrada.nextInt();
            while (menu != 0) {
                if (menu == 1) {
                    System.out.println("Digite um NOVO plano:");
                    String novo_plano = entrada.next();
                    System.out.println("Digite o valor deste novo plano:");
                    float valor_novo_plano = entrada.nextFloat();
                    conexao.prepareStatement("INSERT INTO plano (nome, valor) VALUES ('" + novo_plano + "', " + valor_novo_plano + ");").execute();
                } else if (menu == 2) {
                    System.out.println("Digite o id do plano que vc deseja excluir");
                    int plano_id = entrada.nextInt();
                    conexao.prepareStatement("DELETE FROM plano WHERE id = " + plano_id + ";").execute();

                } else if (menu == 3) {
                    System.out.println("Digite o id do plano que vc deseja atualizar");
                    int plano_update_id = entrada.nextInt();
                    entrada.nextLine();  // Consume newline left-over
                    System.out.println("Digite um NOVO nome do plano:");
                    String plano_update_nome = entrada.nextLine();
                    System.out.println("Digite o novo valor deste plano:");
                    float plano_update_valor = entrada.nextFloat();
                    entrada.nextLine();  // Consume newline left-over
                    conexao.prepareStatement("UPDATE plano SET nome = '" + plano_update_nome.trim() + "', valor = " + plano_update_valor + " WHERE id = " + plano_update_id + ";").execute();
                } else if (menu == 4) {
                    ResultSet rs = conexao.prepareStatement("SELECT * FROM plano;").executeQuery();
                    while (rs.next()){
                        System.out.println(rs.getInt("id")+";"+rs.getString("nome")+";"+rs.getFloat("valor"));
                    }
                }
                System.out.println(str_menu);
                menu = entrada.nextInt();
            }
            System.out.println("xau!!");
        } catch (Exception e) {
            System.out.println("deu xabum");
        }
    }

}
