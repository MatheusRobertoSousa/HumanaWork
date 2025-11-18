package fiap.com.humanawork.controller;

import fiap.com.humanawork.service.MetricsService;
import fiap.com.humanawork.service.PlsqlService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/metrics")
public class MetricsController {

    @Autowired
    private MetricsService metricsService;

    @Autowired
    private PlsqlService plsqlService;

    @GetMapping("/minhas")
    public ResponseEntity<List<Map<String, Object>>> minhasMetricas(
            @RequestParam Long usuarioId,
            @RequestParam long dataIni,
            @RequestParam long dataFim) {

        Date ini = new Date(dataIni);
        Date fim = new Date(dataFim);

        List<Map<String, Object>> resultado =
                plsqlService.gerarRelatorioMetricas(usuarioId, ini, fim);

        return ResponseEntity.ok(resultado);
    }


    // =====================================================================
    // RELATÓRIO VIA MÉTRICAS SERVICE (SE EXISTIR)
    // =====================================================================
    @GetMapping("/relatorio/{idUsuario}")
    public List<Map<String,Object>> relatorioMetricsService(
            @PathVariable Long idUsuario,
            @RequestParam("dataIni") long dataIni,
            @RequestParam("dataFim") long dataFim) {

        return metricsService.relatorio(
                idUsuario,
                new Date(dataIni),
                new Date(dataFim)
        );
    }

    // =====================================================================
    // RELATÓRIO USANDO O PL/SQL - RECOMENDADO
    // =====================================================================
    @GetMapping("/report")
    public ResponseEntity<List<Map<String,Object>>> relatorioPLSQL(
            @RequestParam Long usuarioId,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
            Date from,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
            Date to) {

        return ResponseEntity.ok(plsqlService.gerarRelatorioMetricas(usuarioId, from, to));
    }

    // =====================================================================
    // MÉTRICAS DINÂMICAS
    // =====================================================================
    @GetMapping("/dynamic")
    public ResponseEntity<List<Map<String,Object>>> dinamico(
            @RequestParam Long usuarioId,
            @RequestParam String filtro) {

        return ResponseEntity.ok(plsqlService.buscarMetricasDinamico(usuarioId, filtro));
    }
}
