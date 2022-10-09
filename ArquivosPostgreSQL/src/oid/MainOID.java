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
 */
public class MainOID {

    public static void main(String[] args) throws SQLException, IOException {
        escrita2("teste2", "/home/iapereira/teste2.png");
        leitura("teste2");
    }

    private static void leitura(String imgname) throws SQLException {
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/teste", "postgres", "postgres");
        // All LargeObject API calls must be within a transaction block
        conn.setAutoCommit(false);
        // Get the Large Object Manager to perform operations with
        LargeObjectManager lobj = ((org.postgresql.PGConnection) conn).getLargeObjectAPI();
        PreparedStatement ps = conn.prepareStatement("SELECT imgoid FROM images WHERE imgname = ?");
        ps.setString(1, imgname);
        ResultSet rs = ps.executeQuery();
        byte buf[] = null;
        if (rs != null) {
            while (rs.next()) {
                int oid = rs.getInt(1);
                LargeObject obj = lobj.open(oid, LargeObjectManager.READ);
                // Read the data
                buf = new byte[obj.size()];
                obj.read(buf, 0, obj.size());
                // Do something with the data read here

                // Close the object
                obj.close();
            }
            rs.close();
        }
        ps.close();

//        renderizar
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

// Get the Large Object Manager to perform operations with
        LargeObjectManager lobj = conn.unwrap(org.postgresql.PGConnection.class).getLargeObjectAPI();

// Create a new large object
        long oid = lobj.createLO(LargeObjectManager.READ | LargeObjectManager.WRITE);

// Open the large object for writing
        LargeObject obj = lobj.open(oid, LargeObjectManager.WRITE);

// Now open the file
        File file = new File(url_imgoid);
        FileInputStream fis = new FileInputStream(file);

// Copy the data from the file to the large object
        byte buf[] = new byte[2048];
        int s, tl = 0;
        while ((s = fis.read(buf, 0, 2048)) > 0) {
            obj.write(buf, 0, s);
            tl += s;
        }

// Close the large object
        obj.close();

// Now insert the row into imageslo
        PreparedStatement ps = conn.prepareStatement("INSERT INTO images (imgname, imgoid) VALUES (?, ?)");
        ps.setString(1, imgname);
        ps.setLong(2, oid);
        ps.executeUpdate();
        ps.close();
        fis.close();

// Finally, commit the transaction.
        conn.commit();

    }

}
