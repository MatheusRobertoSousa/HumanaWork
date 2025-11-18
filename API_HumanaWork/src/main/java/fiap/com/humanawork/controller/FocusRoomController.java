package fiap.com.humanawork.controller;

import fiap.com.humanawork.entity.SalaFoco;
import fiap.com.humanawork.service.FocusRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/salas")
public class FocusRoomController {
    @Autowired private FocusRoomService service;

    @GetMapping
    public List<SalaFoco> listar() { return service.listar(); }

    @GetMapping("/{id}")
    public SalaFoco buscar(@PathVariable Long id) { return service.buscar(id); }

    @PostMapping
    public SalaFoco criar(@RequestBody SalaFoco s) { return service.criar(s); }
}
