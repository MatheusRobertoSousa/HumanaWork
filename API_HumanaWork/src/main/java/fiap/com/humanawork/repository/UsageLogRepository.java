package fiap.com.humanawork.repository;

import fiap.com.humanawork.entity.UsageLog;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface UsageLogRepository extends JpaRepository<UsageLog, Long> {
    List<UsageLog> findByIdUsuario(Long idUsuario);
}
