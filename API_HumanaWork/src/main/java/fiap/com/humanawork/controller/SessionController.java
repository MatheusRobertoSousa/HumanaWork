package fiap.com.humanawork.controller;

import fiap.com.humanawork.dto.StartSessionDTO;
import fiap.com.humanawork.service.PlsqlService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sessoes")
public class SessionController {
    @Autowired private PlsqlService plsqlService;

    @PostMapping("/iniciar")
    public Long iniciar(@RequestBody StartSessionDTO dto) {
        return plsqlService.iniciarSessaoFoco(dto.getIdUsuario(), dto.getIdSala(), dto.getObjetivo());
    }

    @PostMapping("/encerrar/{idSessao}")
    public void encerrar(@PathVariable Long idSessao) {
        plsqlService.encerrarSessaoFoco(idSessao);
    }
}
