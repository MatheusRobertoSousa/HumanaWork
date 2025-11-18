package fiap.com.humanawork.service;

import fiap.com.humanawork.entity.SalaFoco;
import fiap.com.humanawork.repository.SalaFocoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;

@Service
public class FocusRoomService {

    private final SalaFocoRepository salaRepo;
    private final PlsqlService plsqlService; // 1. Campo para PlsqlService

    @Autowired // Constructor Injection é preferível
    public FocusRoomService(SalaFocoRepository salaRepo, PlsqlService plsqlService) {
        this.salaRepo = salaRepo;
        this.plsqlService = plsqlService; // 2. Injeção
    }

    public List<SalaFoco> listar() { return salaRepo.findAll(); }
    public SalaFoco buscar(Long id) { return salaRepo.findById(id).orElse(null); }

    // Método 'criar' modificado
    public SalaFoco criar(SalaFoco s) {

        // --- 1. Preencher 'criadaPor' (Usuário Logado) ---
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.isAuthenticated()) {
            // Obtém o email/username do contexto de segurança (definido no JwtFilter)
            String email = authentication.getName();

            // Usa o PlsqlService para buscar o ID do usuário no banco
            Long idUsuario = plsqlService.buscarIdUsuarioPorEmail(email);

            if (idUsuario != null) {
                s.setCriadaPor(idUsuario);
            } else {
                // Se o usuário autenticado não for encontrado, você pode lançar uma exceção
                // ou simplesmente deixar o campo como null, dependendo da regra de negócio.
                // Recomenda-se lançar exceção (e.g., throw new UsernameNotFoundException("User ID not found for email: " + email);)
            }
        }

        // --- 2. Preencher 'dataCriacao' ---
        s.setDataCriacao(new Date());

        return salaRepo.save(s);
    }
}