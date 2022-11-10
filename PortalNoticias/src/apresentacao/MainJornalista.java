/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package apresentacao;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Scanner;
import negocio.Jornalista;
import persistencia.JornalistaDAO;

/**
 *
 * @author iapereira
 */
public class MainJornalista {
    public static void main(String[] args) throws SQLException {
        
//        Calendar calendar = Calendar.getInstance();
//        calendar.set(1998, 3, 1);
//        Date date = calendar.getTime();
//        
//        
//        new Jornalista().setData_nascimento(data);
        
        Scanner entrada = new Scanner(System.in);
        
        Jornalista jornalista = new Jornalista();
        jornalista.setCpf(entrada.nextLine());
        jornalista.setNome(entrada.nextLine());
        jornalista.setEmail(entrada.nextLine());
        jornalista.setSenha(entrada.nextLine());
        jornalista.setData_nascimento(LocalDate.of(entrada.nextInt(),entrada.nextInt(),entrada.nextInt()));
        new JornalistaDAO().inserir(jornalista);

//        new JornalistaDAO().remover(1);

        ArrayList<Jornalista> vetJornalistas = new JornalistaDAO().listar();
        for (int i = 0; i < vetJornalistas.size(); i++) {
            Jornalista j = vetJornalistas.get(i);
            System.out.println(j);
            
        }

//        Jornalista igor = new JornalistaDAO().obter(7);
//        igor.setNome("Igor Pereira");
//        new JornalistaDAO().atualizar(igor);
    }
    
}
