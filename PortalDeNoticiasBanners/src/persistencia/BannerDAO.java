/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package persistencia;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import negocio.Banner;
import java.sql.*;
import java.util.ArrayList;
/**
 *
 * @author iapereira
 */
public class BannerDAO {
    private ConexaoPostgreSQL conexaoPostgreSQL;

    
    public Banner obter(int id) throws SQLException{
        Banner b = new Banner();
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection conn = this.conexaoPostgreSQL.getConexao();
        String sql = "SELECT * FROM publicidade.banner WHERE id = ?";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        ResultSet rs = preparedStatement.executeQuery();
        if (rs.next()){
            b.setId(rs.getInt("id"));
            b.setAltura(rs.getInt("altura"));
            b.setLargura(rs.getInt("largura"));
            b.setLegenda(rs.getString("legenda"));
            b.setLink(rs.getString("link"));
            b.setQtdeCliques(rs.getInt("qtde_cliques"));
            b.setTipo(rs.getString("tipo"));
            b.setArquivo(rs.getBytes("arquivo"));
        }
        conn.close();
        return b;
    }

    public void adicionar(Banner banner, String dir) throws SQLException, FileNotFoundException {
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection conn = this.conexaoPostgreSQL.getConexao();
        String sql = "INSERT INTO publicidade.banner "
                + " (arquivo, legenda, link, tipo) VALUES " +
                        "(?,?,?,?);";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        File file = new File(dir);
        FileInputStream fis = new FileInputStream(file);
        preparedStatement.setBinaryStream(1, fis, file.length());
        preparedStatement.setString(2, banner.getLegenda());
        preparedStatement.setString(3, banner.getLink());
        preparedStatement.setString(4, banner.getTipo());
        preparedStatement.executeUpdate();
        conn.close();
    }
    
    public void remover(int id) throws SQLException{
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection conn = this.conexaoPostgreSQL.getConexao();
        String sql = "DELETE FROM publicidade.banner WHERE id = ?";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        preparedStatement.executeUpdate();
        conn.close();
    }

    public ArrayList<Banner> listar() throws SQLException {
        
        ArrayList<Banner> vetBanner = new ArrayList<Banner>();
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection conn = this.conexaoPostgreSQL.getConexao();
        String sql = "SELECT * FROM publicidade.banner";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()){
            Banner b = new Banner();
            b.setId(rs.getInt("id"));
            b.setAltura(rs.getInt("altura"));
            b.setLargura(rs.getInt("largura"));
            b.setLegenda(rs.getString("legenda"));
            b.setLink(rs.getString("link"));
            b.setQtdeCliques(rs.getInt("qtde_cliques"));
            b.setTipo(rs.getString("tipo"));
            b.setArquivo(rs.getBytes("arquivo"));
            vetBanner.add(b);
        }
        conn.close();
        return vetBanner;
    }
    
}
