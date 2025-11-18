package fiap.com.humanawork.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "usage_log")
public class UsageLog {
    @Id
    @Column(name = "id_log")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_usagelog_gen")
    @SequenceGenerator(name = "seq_usagelog_gen", sequenceName = "seq_usagelog", allocationSize = 1)
    private Long idLog;

    @Column(name = "id_usuario")
    private Long idUsuario;

    private String acao;

    private String detalhe;

    @Column(name = "data_registro")
    private Date dataRegistro;

    public UsageLog() {}

    // getters/setters
    public Long getIdLog() { return idLog; }
    public void setIdLog(Long idLog) { this.idLog = idLog; }
    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }
    public String getAcao() { return acao; }
    public void setAcao(String acao) { this.acao = acao; }
    public String getDetalhe() { return detalhe; }
    public void setDetalhe(String detalhe) { this.detalhe = detalhe; }
    public Date getDataRegistro() { return dataRegistro; }
    public void setDataRegistro(Date dataRegistro) { this.dataRegistro = dataRegistro; }
}
