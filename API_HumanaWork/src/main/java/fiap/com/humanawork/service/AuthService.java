// AuthService.java (Atualizado)

package fiap.com.humanawork.service;

import fiap.com.humanawork.entity.Usuario;
import fiap.com.humanawork.repository.UsuarioRepository;
import fiap.com.humanawork.config.JwtUtil;
import fiap.com.humanawork.dto.AuthResponse; // Importar AuthResponse
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class AuthService {
    @Autowired private UsuarioRepository usuarioRepository;
    @Autowired private PasswordEncoder passwordEncoder;
    @Autowired private JwtUtil jwtUtil;

    // Altera o tipo de retorno de String para AuthResponse
    public AuthResponse login(String email, String senha) {
        Optional<Usuario> opt = usuarioRepository.findByEmail(email);
        if (opt.isEmpty()) {
            throw new RuntimeException("Credenciais inválidas");
        }
        Usuario u = opt.get();
        if (!passwordEncoder.matches(senha, u.getSenhaHash())) {
            throw new RuntimeException("Credenciais inválidas");
        }

        // 1. Gera o Token
        String token = jwtUtil.generateToken(u.getEmail());

        // 2. Retorna o AuthResponse com todos os dados
        return new AuthResponse(
                token,
                u.getIdUsuario(),   // Assumindo que getId() existe na sua Entity Usuario
                u.getNome()  // Assumindo que getNome() existe na sua Entity Usuario
        );
    }

    public Usuario criarUsuario(Usuario u, String senhaClaro) {
        u.setSenhaHash(passwordEncoder.encode(senhaClaro));
        return usuarioRepository.save(u);
    }
}