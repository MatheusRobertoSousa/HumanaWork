package fiap.com.humanawork.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class MetricsService {
    @Autowired private PlsqlService plsqlService;

    public List<Map<String,Object>> relatorio(Long idUsuario, Date inicio, Date fim) {
        return plsqlService.gerarRelatorioMetricas(idUsuario, inicio, fim);
    }
}
