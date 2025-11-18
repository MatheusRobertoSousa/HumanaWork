package fiap.com.humanawork.service;

import fiap.com.humanawork.entity.UsageLog;
import fiap.com.humanawork.repository.UsageLogRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsageLogService {

    private final UsageLogRepository repo;

    public UsageLogService(UsageLogRepository repo) {
        this.repo = repo;
    }

    public UsageLog registro(UsageLog log) {
        return repo.save(log);
    }

    public List<UsageLog> listarPorUsuario(Long idUsuario) {
        return repo.findByIdUsuario(idUsuario);
    }
}
