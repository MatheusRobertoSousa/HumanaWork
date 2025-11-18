package fiap.com.humanawork.controller;

import fiap.com.humanawork.entity.MembroSala;
import fiap.com.humanawork.service.MembroSalaService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/salas/{salaId}/membros")
public class MembroSalaController {

    private final MembroSalaService service;

    public MembroSalaController(MembroSalaService service) {
        this.service = service;
    }

    @GetMapping
    public ResponseEntity<List<MembroSala>> listar(@PathVariable("salaId") Long salaId) {
        return ResponseEntity.ok(service.listarPorSala(salaId));
    }

    @PostMapping
    public ResponseEntity<MembroSala> adicionar(@PathVariable("salaId") Long salaId,
                                                @RequestBody MembroSala body) {
        body.setIdSala(salaId);
        MembroSala saved = service.adicionar(body);
        return ResponseEntity.ok(saved);
    }

    @DeleteMapping("/{membroId}")
    public ResponseEntity<Void> remover(@PathVariable("salaId") Long salaId,
                                        @PathVariable("membroId") Long membroId) {
        service.remover(membroId);
        return ResponseEntity.noContent().build();
    }
}
