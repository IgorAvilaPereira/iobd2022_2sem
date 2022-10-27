/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package negocio;

import java.io.File;

/**
 *
 * @author iapereira
 */
public class Banner {
    private int id;
    private String diretorio;
    private byte[] arquivo;
    private String legenda;
    private int largura;
    private int altura;
    private String link;
    private String tipo;
    private int qtdeCliques;
    private Empresa empresa;
    
    
    public Banner (){
        
    }

    public Empresa getEmpresa() {
        return empresa;
    }

    public void setEmpresa(Empresa empresa) {
        this.empresa = empresa;
    }
    
    

    public Banner(byte[] arquivo, String legenda, String link, String tipo) {
        this.arquivo = arquivo;
        this.legenda = legenda;
        this.link = link;
        this.tipo = tipo;
    }

    public String getDiretorio() {
        return diretorio;
    }

    public void setDiretorio(String diretorio) {
        this.diretorio = diretorio;
    }
    
    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public byte[] getArquivo() {
        return arquivo;
    }

    public void setArquivo(byte[] arquivo) {
        this.arquivo = arquivo;
    }

    public String getLegenda() {
        return legenda;
    }

    public void setLegenda(String legenda) {
        this.legenda = legenda;
    }

    public int getLargura() {
        return largura;
    }

    public void setLargura(int largura) {
        this.largura = largura;
    }

    public int getAltura() {
        return altura;
    }

    public void setAltura(int altura) {
        this.altura = altura;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public int getQtdeCliques() {
        return qtdeCliques;
    }

    public void setQtdeCliques(int qtdeCliques) {
        this.qtdeCliques = qtdeCliques;
    }
    
    
    
}
