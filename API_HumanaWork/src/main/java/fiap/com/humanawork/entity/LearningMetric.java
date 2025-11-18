package fiap.com.humanawork.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "learning_metrics")
public class LearningMetric {
    @Id
    @Column(name = "id_metric")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_metrics_gen")
    @SequenceGenerator(name = "seq_metrics_gen", sequenceName = "seq_metrics", allocationSize = 1)
    private Long idMetric;

    @Column(name = "id_usuario")
    private Long idUsuario;

    @Column(name = "periodo_inicio")
    private Date periodoInicio;

    @Column(name = "periodo_fim")
    private Date periodoFim;

    @Column(name = "total_sessoes")
    private Integer totalSessoes;

    @Column(name = "total_minutos_foco")
    private Long totalMinutosFoco;

    @Column(name = "media_humor")
    private Double mediaHumor;

    @Column(name = "objetivos_cumpridos")
    private Integer objetivosCumpridos;

    public LearningMetric() {}

    // getters/setters
    public Long getIdMetric() { return idMetric; }
    public void setIdMetric(Long idMetric) { this.idMetric = idMetric; }
    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }
    public Date getPeriodoInicio() { return periodoInicio; }
    public void setPeriodoInicio(Date periodoInicio) { this.periodoInicio = periodoInicio; }
    public Date getPeriodoFim() { return periodoFim; }
    public void setPeriodoFim(Date periodoFim) { this.periodoFim = periodoFim; }
    public Integer getTotalSessoes() { return totalSessoes; }
    public void setTotalSessoes(Integer totalSessoes) { this.totalSessoes = totalSessoes; }
    public Long getTotalMinutosFoco() { return totalMinutosFoco; }
    public void setTotalMinutosFoco(Long totalMinutosFoco) { this.totalMinutosFoco = totalMinutosFoco; }
    public Double getMediaHumor() { return mediaHumor; }
    public void setMediaHumor(Double mediaHumor) { this.mediaHumor = mediaHumor; }
    public Integer getObjetivosCumpridos() { return objetivosCumpridos; }
    public void setObjetivosCumpridos(Integer objetivosCumpridos) { this.objetivosCumpridos = objetivosCumpridos; }
}
