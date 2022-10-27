/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package apresentacao;

import java.sql.SQLException;
import java.util.ArrayList;
import negocio.Banner;
import negocio.Empresa;
import negocio.Modalidade;
import persistencia.BannerDAO;
import persistencia.EmpresaDAO;
import persistencia.ModalidadeDAO;

/**
 *
 * @author iapereira
 */
public class MainDAO {
    
    public static void main(String[] args) throws SQLException {
        Empresa vetorial = new Empresa();
        vetorial = new EmpresaDAO().obter(1);
//        System.out.println(vetorial);
    
        Banner bannerVetorial = new Banner();
        bannerVetorial.setLink("http://vetorial.net");
        bannerVetorial.setLegenda("clique aqui e contrate sua banda larga");
        bannerVetorial.setTipo("SUPERIOR");
        bannerVetorial.setDiretorio("/home/iapereira/vetorial.png");
        bannerVetorial.setEmpresa(vetorial);
        new BannerDAO().inserir(bannerVetorial);

//        ModalidadeDAO modalidadeDAO = new ModalidadeDAO();
//        ArrayList<Modalidade> vetModalidade = new ArrayList<>();
//        vetModalidade = modalidadeDAO.listar();
//        for (int i = 0; i < vetModalidade.size(); i++) {
//            Modalidade m = vetModalidade.get(i);
//            System.out.println(m.getNome()+";"+m.getValor());
//            
//        }
//        modalidadeDAO.remover(4);
//        Modalidade modalidade = new Modalidade();
//        modalidade = modalidadeDAO.obter(4);
//        modalidade.setValor(200.0);
//        modalidadeDAO.atualizar(modalidade);
//        modalidade.setNome("ANUAL");
//        modalidade.setValor(11.90);
//        System.out.println("antes da inserção:"+modalidade.getId());
//        boolean resultado = modalidadeDAO.inserir(modalidade);
//        System.out.println((resultado==true) ? "Inserido com sucesso" : "deu xabum na insercao");
//        System.out.println("depois da inserção:"+modalidade.getId());
    }
    
}
