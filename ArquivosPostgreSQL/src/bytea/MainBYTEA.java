/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package bytea;

import java.awt.FlowLayout;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.*;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;

/**
 *
 * @author iapereira
 * https://jdbc.postgresql.org/documentation/binary-data/
 */
public class MainBYTEA {

// funciona com o arquivo em qualquer diretorio
    public static void main(String[] args) throws FileNotFoundException, SQLException, IOException {
      escrita("/home/iapereira/teste2.png");
        leitura("teste2.png");
    }

    // renderizar
    private static void leitura(String imgname) throws SQLException {
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/teste", "postgres", "postgres");;
        PreparedStatement ps = conn.prepareStatement("SELECT img FROM images WHERE imgname = ?");
        ps.setString(1, imgname);
        ResultSet rs = ps.executeQuery();
        byte[] imgBytes = null;
        if (rs != null) {
            if (rs.next()) {
                imgBytes = rs.getBytes(1);
            }
            rs.close();
        }
        ps.close();

        ImageIcon imageIcon = new ImageIcon(imgBytes);
        JFrame jFrame = new JFrame();

        jFrame.setLayout(new FlowLayout());

        jFrame.setSize(500, 500);
        JLabel jLabel = new JLabel();

        jLabel.setIcon(imageIcon);
        jFrame.add(jLabel);
        jFrame.setVisible(true);

        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

    // salvar
    private static void escrita(String url) throws SQLException, FileNotFoundException, IOException {
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/teste", "postgres", "postgres");
        File file = new File(url);
        FileInputStream fis = new FileInputStream(file);
        PreparedStatement ps = conn.prepareStatement("INSERT INTO images (imgname, img) VALUES (?, ?)");
        ps.setString(1, file.getName());
        ps.setBinaryStream(2, fis, file.length());
        ps.executeUpdate();
        ps.close();
        fis.close();
    }

}
