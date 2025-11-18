package fiap.com.humanawork.controller;

import fiap.com.humanawork.entity.UsageLog;
import fiap.com.humanawork.service.UsageLogService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/logs")
public class UsageLogController {

    private final UsageLogService service;

    public UsageLogController(UsageLogService service) {
        this.service = service;
    }

    @GetMapping
    public ResponseEntity<List<UsageLog>> listar(@RequestParam(required = false) Long usuarioId) {
        if (usuarioId != null) {
            return ResponseEntity.ok(service.listarPorUsuario(usuarioId));
        }
        return ResponseEntity.ok(service.listarPorUsuario(null)); // or return all if implemented
    }
}
