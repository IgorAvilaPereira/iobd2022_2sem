/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package persistencia;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import negocio.Empresa;
import negocio.Modalidade;

/**
 *
 * @author iapereira
 */
public class EmpresaDAO implements DAO<Empresa>{

    private ConexaoPostgreSQL conexaoPostgreSQL;

    @Override
    public boolean inserir(Empresa modelo) throws SQLException { 
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "INSERT INTO publicidade.empresa (nome, endereco) VALUES (?,?) RETURNING id;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, modelo.getNome());
        preparedStatement.setString(2, modelo.getEndereco());
        ResultSet rs = preparedStatement.executeQuery();
        if (rs.next()){
            modelo.setId(rs.getInt("id"));
        }
        connection.close();
        return modelo.getId() != 0;
    }

   

    @Override
    public boolean atualizar(Empresa modelo) throws SQLException {
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "UPDATE publicidade.empresa SET nome = ?, endereco = ? WHERE id = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1,  modelo.getNome());
        preparedStatement.setString(2, modelo.getEndereco());
        preparedStatement.setInt(3, modelo.getId());
        boolean resultado = preparedStatement.execute();
        connection.close();
        return resultado;
    
    }

    @Override
    public boolean remover(int id) throws SQLException {
        
         this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "DELETE FROM publicidade.empresa WHERE id = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        int resultado = preparedStatement.executeUpdate();
        connection.close();
        return resultado == 1;
    }

    @Override
    public Empresa obter(int id) throws SQLException {
        Empresa empresa = new Empresa();
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "SELECT * FROM publicidade.empresa WHERE id = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        ResultSet rs = preparedStatement.executeQuery();
        if (rs.next()){
            empresa.setId(rs.getInt("id"));
            empresa.setNome(rs.getString("nome"));
            empresa.setEndereco(rs.getString("endereco"));
        }
        connection.close();
        return empresa;
    }

    @Override
    public ArrayList<Empresa> listar() throws SQLException {
        ArrayList<Empresa> vetEmpresa = new ArrayList<>();
         this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "SELECT * FROM publicidade.empresa;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()){
            Empresa empresa = new Empresa();
            empresa.setId(rs.getInt("id"));
            empresa.setNome(rs.getString("nome"));
            empresa.setEndereco(rs.getString("endereco"));
            vetEmpresa.add(empresa);            
        }
        connection.close();       
        return vetEmpresa;
    }
  
    
}
