package fiap.com.humanawork.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "salas_foco")
public class SalaFoco {
    @Id
    @Column(name = "id_sala")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_salas_gen")
    @SequenceGenerator(name = "seq_salas_gen", sequenceName = "seq_salas", allocationSize = 1)
    private Long idSala;

    @Column(name = "nome_sala")
    private String nomeSala;

    private String descricao;

    private String tema;

    @Column(name = "criada_por")
    private Long criadaPor;

    @Column(name = "data_criacao")
    private Date dataCriacao;

    public SalaFoco() {}

    // getters/setters
    public Long getIdSala() { return idSala; }
    public void setIdSala(Long idSala) { this.idSala = idSala; }
    public String getNomeSala() { return nomeSala; }
    public void setNomeSala(String nomeSala) { this.nomeSala = nomeSala; }
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    public String getTema() { return tema; }
    public void setTema(String tema) { this.tema = tema; }
    public Long getCriadaPor() { return criadaPor; }
    public void setCriadaPor(Long criadaPor) { this.criadaPor = criadaPor; }
    public Date getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(Date dataCriacao) { this.dataCriacao = dataCriacao; }
}
