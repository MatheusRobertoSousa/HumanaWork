// AuthController.java (Atualizado)

package fiap.com.humanawork.controller;

import fiap.com.humanawork.dto.AuthRequest;
import fiap.com.humanawork.dto.AuthResponse; // Importar AuthResponse
import fiap.com.humanawork.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired private AuthService authService;

    @PostMapping("/login")
    // O retorno agora é AuthResponse
    public AuthResponse login(@RequestBody AuthRequest req) {
        // Chama o serviço, que agora retorna o objeto completo
        return authService.login(req.getEmail(), req.getSenha());
    }
}