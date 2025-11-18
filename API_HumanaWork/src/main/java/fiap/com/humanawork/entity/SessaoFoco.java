package fiap.com.humanawork.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "sessoes_foco")
public class SessaoFoco {
    @Id
    @Column(name = "id_sessao")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_sessoes_gen")
    @SequenceGenerator(name = "seq_sessoes_gen", sequenceName = "seq_sessoes", allocationSize = 1)
    private Long idSessao;

    @Column(name = "id_sala")
    private Long idSala;

    @Column(name = "id_usuario")
    private Long idUsuario;

    @Column(name = "inicio_sessao")
    private Date inicioSessao;

    @Column(name = "fim_sessao")
    private Date fimSessao;

    @Column(name = "duracao_minutos")
    private Integer duracaoMinutos;

    @Column(name = "objetivo_resumido")
    private String objetivoResumido;

    private String status;

    public SessaoFoco() {}

    // getters/setters
    public Long getIdSessao() { return idSessao; }
    public void setIdSessao(Long idSessao) { this.idSessao = idSessao; }
    public Long getIdSala() { return idSala; }
    public void setIdSala(Long idSala) { this.idSala = idSala; }
    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }
    public Date getInicioSessao() { return inicioSessao; }
    public void setInicioSessao(Date inicioSessao) { this.inicioSessao = inicioSessao; }
    public Date getFimSessao() { return fimSessao; }
    public void setFimSessao(Date fimSessao) { this.fimSessao = fimSessao; }
    public Integer getDuracaoMinutos() { return duracaoMinutos; }
    public void setDuracaoMinutos(Integer duracaoMinutos) { this.duracaoMinutos = duracaoMinutos; }
    public String getObjetivoResumido() { return objetivoResumido; }
    public void setObjetivoResumido(String objetivoResumido) { this.objetivoResumido = objetivoResumido; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
