package fiap.com.humanawork.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "membros_sala")
public class MembroSala {

    @Id
    @Column(name = "id_membro")
    private Long idMembro;

    @Column(name = "id_sala", nullable = false)
    private Long idSala;

    @Column(name = "id_usuario", nullable = false)
    private Long idUsuario;

    @Column(name = "papel")
    private String papel;

    @Column(name = "data_entrada")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dataEntrada;

    // getters / setters

    public Long getIdMembro() { return idMembro; }
    public void setIdMembro(Long idMembro) { this.idMembro = idMembro; }

    public Long getIdSala() { return idSala; }
    public void setIdSala(Long idSala) { this.idSala = idSala; }

    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }

    public String getPapel() { return papel; }
    public void setPapel(String papel) { this.papel = papel; }

    public Date getDataEntrada() { return dataEntrada; }
    public void setDataEntrada(Date dataEntrada) { this.dataEntrada = dataEntrada; }
}
