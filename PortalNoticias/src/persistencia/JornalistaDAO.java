/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package persistencia;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import negocio.Jornalista;

/**
 *
 * @author iapereira
 */
public class JornalistaDAO implements DAO<Jornalista> {

    private ConexaoPostgreSQL conexaoPostgreSQL;

    public JornalistaDAO() {
        this.conexaoPostgreSQL = new ConexaoPostgreSQL();
    }

    @Override
    public boolean inserir(Jornalista modelo) throws SQLException {
        String sql = "INSERT INTO admin.jornalista("
                + "	nome, cpf, data_nascimento, email, senha)"
                + "	VALUES (?, ?, ?, ?, md5(?));";
        Connection connection = this.conexaoPostgreSQL.getConexao();
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, modelo.getNome());
        preparedStatement.setString(2, modelo.getCpf());
        preparedStatement.setDate(3, Date.valueOf(modelo.getData_nascimento()));
        preparedStatement.setString(4, modelo.getEmail());
        preparedStatement.setString(5, modelo.getSenha());
        int resultado = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return resultado == 1;
    }

    @Override
    public boolean atualizar(Jornalista modelo) throws SQLException {
        String sql = "UPDATE admin.jornalista SET nome = ?, cpf = ?, data_nascimento = ?, email = ?, senha = ? WHERE id = ?";
        Connection connection = this.conexaoPostgreSQL.getConexao();
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, modelo.getNome());
        preparedStatement.setString(2, modelo.getCpf());
        preparedStatement.setDate(3, Date.valueOf(modelo.getData_nascimento()));
        preparedStatement.setString(4, modelo.getEmail());
        preparedStatement.setString(5, modelo.getSenha());
        preparedStatement.setInt(6, modelo.getId());
        int resultado = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return resultado == 1;
    }

    @Override
    public boolean remover(int id) throws SQLException {
        String sql = "BEGIN; DELETE FROM assinante_noticia WHERE noticia_id in (SELECT id FROM externo.noticia WHERE jornalista_id = ?); DELETE FROM externo.noticia WHERE jornalista_id = ?; DELETE FROM admin.jornalista WHERE id = ?; COMMIT;";
        Connection connection = this.conexaoPostgreSQL.getConexao();
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        preparedStatement.setInt(2, id);       
        preparedStatement.setInt(3, id);       
        int resultado = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return resultado == 1;
    }

    @Override
    public Jornalista obter(int id) throws SQLException {
        Jornalista jornalista = new Jornalista();
        String sql = "SELECT * FROM admin.jornalista WHERE id = ?;";
        Connection connection = this.conexaoPostgreSQL.getConexao();
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, id);
        ResultSet rs = preparedStatement.executeQuery();
        if (rs.next()) {
            jornalista.setId(rs.getInt("id"));
            jornalista.setCpf(rs.getString("cpf"));
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");            
            jornalista.setData_nascimento(LocalDate.parse(fmt.format(rs.getDate("data_nascimento"))));
            jornalista.setEmail(rs.getString("email"));
            jornalista.setNome(rs.getString("nome"));
            jornalista.setSenha(rs.getString("senha"));
        }
        preparedStatement.close();
        connection.close();
        return jornalista;
    }

    @Override
    public ArrayList<Jornalista> listar() throws SQLException {
        ArrayList<Jornalista> vetJornalistas = new ArrayList<>();
        String sql = "SELECT * FROM admin.jornalista ORDER BY id;";
        Connection connection = this.conexaoPostgreSQL.getConexao();
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()) {
            Jornalista jornalista = new Jornalista();
            jornalista.setId(rs.getInt("id"));
            jornalista.setCpf(rs.getString("cpf"));
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");            
            jornalista.setData_nascimento(LocalDate.parse(fmt.format(rs.getDate("data_nascimento"))));
            jornalista.setEmail(rs.getString("email"));
            jornalista.setNome(rs.getString("nome"));
            jornalista.setSenha(rs.getString("senha"));
            vetJornalistas.add(jornalista);
        }
        preparedStatement.close();
        connection.close();
        return vetJornalistas;
    }

}
