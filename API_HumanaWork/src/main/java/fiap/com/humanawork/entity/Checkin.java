package fiap.com.humanawork.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "checkins")
public class Checkin {
    @Id
    @Column(name = "id_checkin")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_checkins_gen")
    @SequenceGenerator(name = "seq_checkins_gen", sequenceName = "seq_checkins", allocationSize = 1)
    private Long idCheckin;

    @Column(name = "id_usuario")
    private Long idUsuario;

    @Column(name = "data_checkin")
    private Date dataCheckin;

    private Integer humor;
    private Integer energia;

    @Column(name = "foco_dia")
    private String focoDia;

    public Checkin() {}

    // getters/setters
    public Long getIdCheckin() { return idCheckin; }
    public void setIdCheckin(Long idCheckin) { this.idCheckin = idCheckin; }
    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }
    public Date getDataCheckin() { return dataCheckin; }
    public void setDataCheckin(Date dataCheckin) { this.dataCheckin = dataCheckin; }
    public Integer getHumor() { return humor; }
    public void setHumor(Integer humor) { this.humor = humor; }
    public Integer getEnergia() { return energia; }
    public void setEnergia(Integer energia) { this.energia = energia; }
    public String getFocoDia() { return focoDia; }
    public void setFocoDia(String focoDia) { this.focoDia = focoDia; }
}
