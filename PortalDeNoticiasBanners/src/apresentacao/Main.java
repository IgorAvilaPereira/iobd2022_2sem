package apresentacao;

import java.awt.Desktop;
import java.awt.FlowLayout;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import negocio.Banner;
import persistencia.BannerDAO;
import persistencia.ConexaoPostgreSQL;

/**
 *
 * @author iapereira
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws SQLException, FileNotFoundException {
// remoção
        new BannerDAO().remover(1);
        new BannerDAO().remover(3);


//       leitura
//       mostrarBanner(3);

//          escrita
//          Banner bannerVetorial = new Banner();
//            bannerVetorial.setLink("http://vetorial.net");
//            bannerVetorial.setLegenda("clique aqui e contrate sua banda larga");
//            bannerVetorial.setTipo("SUPERIOR");
//            new BannerDAO().adicionar(bannerVetorial, "/home/iapereira/vetorial.png");

    }   

    private static void mostrarBanner(int id) throws SQLException {
        BannerDAO bannerDAO = new BannerDAO();
        Banner bannerGlobo = bannerDAO.obter(id);
        ImageIcon imageIcon = new ImageIcon(bannerGlobo.getArquivo());
        JFrame jFrame = new JFrame();
        jFrame.setLayout(new FlowLayout());
        jFrame.setSize(500, 500);
        JLabel jLabel = new JLabel();
        jLabel.setIcon(imageIcon);
        jFrame.add(jLabel);
        jFrame.setVisible(true);
        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

}
