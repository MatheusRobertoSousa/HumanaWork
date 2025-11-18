package fiap.com.humanawork.controller;

import fiap.com.humanawork.dto.CheckinDTO;
import fiap.com.humanawork.service.PlsqlService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/api/checkins")
public class CheckinController {

    @Autowired
    private PlsqlService plsqlService;

    @PostMapping
    public ResponseEntity<Void> registrar(@RequestBody CheckinDTO dto,
                                          Principal principal) {
        // pega o email do usuário logado a partir do token JWT
        String email = principal.getName();

        // busca o ID do usuário no banco
        Long idUsuario = plsqlService.buscarIdUsuarioPorEmail(email);

        // registra o check-in
        plsqlService.registrarCheckin(idUsuario, dto.getHumor(), dto.getEnergia(), dto.getFocoDia());

        return ResponseEntity.ok().build();
    }
}
