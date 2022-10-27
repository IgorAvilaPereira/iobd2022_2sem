/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package persistencia;

import java.sql.*;
import java.util.ArrayList;
import negocio.Modalidade;

/**
 *
 * @author iapereira
 */
public class ModalidadeDAO implements DAO<Modalidade>{
    private ConexaoPostgreSQL conexaoPostgreSQL;
    
    public boolean inserir(Modalidade modalidade) throws SQLException{
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "INSERT INTO modalidade (nome, valor) VALUES (?,?) RETURNING id;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, modalidade.getNome());
        preparedStatement.setDouble(2, modalidade.getValor());
        ResultSet rs = preparedStatement.executeQuery();
        if (rs.next()){
            modalidade.setId(rs.getInt("id"));
        }
        connection.close();
        return modalidade.getId() != 0;
    }
    
    public boolean atualizar(Modalidade modalidade) throws SQLException{
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "UPDATE modalidade SET nome = ?, valor = ? WHERE id = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, modalidade.getNome());
        preparedStatement.setDouble(2, modalidade.getValor());
        preparedStatement.setInt(3, modalidade.getId());
        boolean resultado = preparedStatement.execute();
        connection.close();
        return resultado;
    }
    
    public boolean remover(int id) throws SQLException{
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "DELETE FROM modalidade WHERE id = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        int resultado = preparedStatement.executeUpdate();
        connection.close();
        return resultado == 1;
    }
    
    public Modalidade obter(int id) throws SQLException{
        Modalidade modalidade = new Modalidade();
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "SELECT * FROM modalidade WHERE id = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        ResultSet rs = preparedStatement.executeQuery();
        if (rs.next()){
            modalidade.setId(rs.getInt("id"));
            modalidade.setNome(rs.getString("nome"));
            modalidade.setValor(rs.getDouble("valor"));
        }
        connection.close();
        return modalidade;
    }
    
    public ArrayList<Modalidade> listar() throws SQLException{
        ArrayList<Modalidade> vetModalidade = new ArrayList<>();
         this.conexaoPostgreSQL = new ConexaoPostgreSQL();
        Connection connection = conexaoPostgreSQL.getConexao();
        String sql = "SELECT * FROM modalidade;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()){
            Modalidade modalidade = new Modalidade();
            modalidade.setId(rs.getInt("id"));
            modalidade.setNome(rs.getString("nome"));
            modalidade.setValor(rs.getDouble("valor"));
            vetModalidade.add(modalidade);            
        }
        connection.close();       
        return vetModalidade;
               
    }
    
    
}
