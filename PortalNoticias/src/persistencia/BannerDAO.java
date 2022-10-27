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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author iapereira
 */
public class BannerDAO implements DAO<Banner> {

    private ConexaoPostgreSQL conexaoPostgreSQL;

    @Override
    public Banner obter(int id) throws SQLException {
        Banner b = new Banner();
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection conn = this.conexaoPostgreSQL.getConexao();
        String sql = "SELECT * FROM publicidade.banner WHERE id = ?";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        ResultSet rs = preparedStatement.executeQuery();
        if (rs.next()) {
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

    @Override
    public boolean inserir(Banner modelo) throws SQLException {
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection conn = this.conexaoPostgreSQL.getConexao();
        String sql = "INSERT INTO publicidade.banner "
                + " (arquivo, legenda, link, tipo, empresa_id) VALUES "
                + "(?,?,?,?, ?);";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        File file = new File(modelo.getDiretorio());
        FileInputStream fis;
        int resultado = 0;
        try {
            fis = new FileInputStream(file);
            preparedStatement.setBinaryStream(1, fis, file.length());
            preparedStatement.setString(2, modelo.getLegenda());
            preparedStatement.setString(3, modelo.getLink());
            preparedStatement.setString(4, modelo.getTipo());
            preparedStatement.setInt(5, modelo.getEmpresa().getId());
            resultado = preparedStatement.executeUpdate();
        } catch (FileNotFoundException ex) {
            Logger.getLogger(BannerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        conn.close();
        return resultado == 1;
    }

    @Override
    public boolean remover(int id) throws SQLException {
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection conn = this.conexaoPostgreSQL.getConexao();
        String sql = "DELETE FROM publicidade.banner WHERE id = ?";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        int resultado = preparedStatement.executeUpdate();
        conn.close();
        return resultado == 1;
    }

    @Override
    public ArrayList<Banner> listar() throws SQLException {
        ArrayList<Banner> vetBanner = new ArrayList<Banner>();
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection conn = this.conexaoPostgreSQL.getConexao();
        String sql = "SELECT * FROM publicidade.banner";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()) {
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

    @Override
    public boolean atualizar(Banner modelo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
