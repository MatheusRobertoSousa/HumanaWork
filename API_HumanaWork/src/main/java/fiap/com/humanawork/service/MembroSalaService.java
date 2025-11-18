package fiap.com.humanawork.service;

import fiap.com.humanawork.entity.MembroSala;
import fiap.com.humanawork.repository.MembroSalaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class MembroSalaService {

    private final MembroSalaRepository repo;

    public MembroSalaService(MembroSalaRepository repo) {
        this.repo = repo;
    }

    public List<MembroSala> listarPorSala(Long idSala) {
        return repo.findByIdSala(idSala);
    }

    @Transactional
    public MembroSala adicionar(MembroSala m) {
        // id is sequence-managed in DB; set it using sequence fetch in controller or via DB trigger.
        if (m.getDataEntrada() == null) m.setDataEntrada(new Date());
        return repo.save(m);
    }

    @Transactional
    public void remover(Long idMembro) {
        repo.deleteById(idMembro);
    }

    public MembroSala buscarPorSalaUsuario(Long idSala, Long idUsuario) {
        return repo.findByIdSalaAndIdUsuario(idSala, idUsuario).orElse(null);
    }
}
