/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package extras;

import java.awt.Desktop;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author iapereira
 */
public class QualquerArquivo {

    public static void main(String[] args) throws SQLException, IOException {
        escrita("/home/iapereira/locadora-de-filmes-online.txt");
        leitura("/home/iapereira/locadora-de-filmes-online.txt");

    }

    // salvar
    private static void escrita(String url) throws SQLException, FileNotFoundException, IOException {
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/teste", "postgres", "postgres");
        File file = new File(url);
        FileInputStream fis = new FileInputStream(file);
        PreparedStatement ps = conn.prepareStatement("INSERT INTO images VALUES (?, ?)");
        ps.setString(1, file.getName());
        ps.setBinaryStream(2, fis, file.length());
        ps.executeUpdate();
        ps.close();
        fis.close();
    }

    private static void leitura(String url) throws SQLException {

        if (Desktop.isDesktopSupported()) {
            try {
                File myFile = new File(url);
                Desktop.getDesktop().open(myFile);
            } catch (IOException ex) {
                // no application registered for PDFs
            }
        }
    }
}
