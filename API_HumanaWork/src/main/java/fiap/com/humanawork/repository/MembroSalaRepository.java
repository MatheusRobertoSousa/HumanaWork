package fiap.com.humanawork.repository;

import fiap.com.humanawork.entity.MembroSala;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface MembroSalaRepository extends JpaRepository<MembroSala, Long> {
    List<MembroSala> findByIdSala(Long idSala);
    Optional<MembroSala> findByIdSalaAndIdUsuario(Long idSala, Long idUsuario);
}
