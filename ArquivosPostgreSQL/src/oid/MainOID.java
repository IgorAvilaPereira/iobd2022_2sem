/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package oid;

import java.awt.FlowLayout;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import org.postgresql.largeobject.BlobInputStream;
import org.postgresql.largeobject.LargeObject;
import org.postgresql.largeobject.LargeObjectManager;

/**
 *
 * @author iapereira
 * https://jdbc.postgresql.org/documentation/binary-data/
 */
public class MainOID {

    public static void main(String[] args) throws SQLException, IOException {
        escrita2("teste6", "/home/iapereira/teste6.png");
        leitura("teste6");
    }

    private static void leitura(String imgname) throws SQLException {
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/teste", "postgres", "postgres");
        conn.setAutoCommit(false);
        LargeObjectManager lobj = conn.unwrap(org.postgresql.PGConnection.class).getLargeObjectAPI();
        PreparedStatement ps = conn.prepareStatement("SELECT imgoid FROM images WHERE imgname = ?");
        ps.setString(1, imgname);
        ResultSet rs = ps.executeQuery();
        byte buf[] = null;
        if (rs.next()) {
            long oid = rs.getLong(1);
            LargeObject obj = lobj.open(oid, LargeObjectManager.READ);
            // Read the data
            buf = new byte[obj.size()];
            obj.read(buf, 0, obj.size());
            // Close the object
            obj.close();
        }
        rs.close();
        ps.close();
        conn.commit();

        ImageIcon imageIcon = new ImageIcon(buf);
        JFrame jFrame = new JFrame();
        jFrame.setLayout(new FlowLayout());
        jFrame.setSize(500, 500);
        JLabel jLabel = new JLabel();
        jLabel.setIcon(imageIcon);
        jFrame.add(jLabel);
        jFrame.setVisible(true);
        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

    // funciona mas soh no diretorio tmp
//    private static void escrita1(String imgname, String url_imgoid) throws SQLException, FileNotFoundException, IOException {
//        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/teste", "postgres", "postgres");
//        PreparedStatement ps = conn.prepareStatement("INSERT INTO images (imgname, imgoid) values (?, lo_import(?));");
//        ps.setString(1, imgname);
//        ps.setString(2, url_imgoid);
//        ps.executeUpdate();
//        ps.close();
//    }
    private static void escrita2(String imgname, String url_imgoid) throws IOException, SQLException {
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/teste", "postgres", "postgres");
        conn.setAutoCommit(false);

        LargeObjectManager lobj = conn.unwrap(org.postgresql.PGConnection.class).getLargeObjectAPI();

        long oid = lobj.createLO(LargeObjectManager.READ | LargeObjectManager.WRITE);
        
        LargeObject obj = lobj.open(oid, LargeObjectManager.WRITE);
        
        File file = new File(url_imgoid);
        FileInputStream fis = new FileInputStream(file);

        byte buf[] = new byte[2048];
        int s, tl = 0;
        while ((s = fis.read(buf, 0, 2048)) > 0) {
            obj.write(buf, 0, s);
            tl += s;
        }
        obj.close();

        PreparedStatement ps = conn.prepareStatement("INSERT INTO images (imgname, imgoid) VALUES (?, ?)");
        ps.setString(1, imgname);
        ps.setLong(2, oid);
        ps.executeUpdate();
        ps.close();
        fis.close();

        conn.commit();
    }
}
