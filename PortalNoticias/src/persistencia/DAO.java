/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package persistencia;

import java.sql.SQLException;
import java.util.ArrayList;
import negocio.Modalidade;

/**
 *
 * @author iapereira
 * @param <Modelo>
 */
public interface DAO<Modelo> {
  public boolean inserir(Modelo modelo) throws SQLException;
  public boolean atualizar(Modelo modelo) throws SQLException;
  public boolean remover(int id) throws SQLException;
  public Modelo obter(int id) throws SQLException;
  public ArrayList<Modelo> listar() throws SQLException;
   
}
