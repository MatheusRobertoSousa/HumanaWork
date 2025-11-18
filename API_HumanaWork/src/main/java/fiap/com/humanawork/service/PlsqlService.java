package fiap.com.humanawork.service;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;
import java.util.Date;

@Service
public class PlsqlService {

    private final JdbcTemplate jdbcTemplate;
    private final DataSource dataSource;

    public PlsqlService(JdbcTemplate jdbcTemplate, DataSource dataSource) {
        this.jdbcTemplate = jdbcTemplate;
        this.dataSource = dataSource;
    }

    // -------------------------------------------------------------------------
    // 1) Registrar Check-in
    // -------------------------------------------------------------------------
    public void registrarCheckin(Long idUsuario, Integer humor, Integer energia, String focoDia) {
        try {
            SimpleJdbcCall call = new SimpleJdbcCall(dataSource)
                    .withCatalogName("HUMANA_WORK_PKG")
                    .withProcedureName("REGISTRAR_CHECKIN");

            Map<String, Object> in = new HashMap<>();
            in.put("P_ID_USUARIO", idUsuario);
            in.put("P_HUMOR", humor);
            in.put("P_ENERGIA", energia);
            in.put("P_FOCO_DIA", focoDia);

            call.execute(in);
        } catch (DataAccessException e) {
            throw e;
        }
    }

    public Long buscarIdUsuarioPorEmail(String email) {
        String sql = "SELECT ID_USUARIO FROM USUARIOS WHERE EMAIL = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{email}, Long.class);
    }


    // -------------------------------------------------------------------------
    // 2) Iniciar sessão
    // -------------------------------------------------------------------------
    public Long iniciarSessaoFoco(Long idUsuario, Long idSala, String objetivo) {

        SimpleJdbcCall call = new SimpleJdbcCall(dataSource)
                .withCatalogName("HUMANA_WORK_PKG")
                .withProcedureName("INICIAR_SESSAO_FOCO")
                .declareParameters(
                        new SqlOutParameter("P_ID_SESSAO", Types.NUMERIC)
                );

        Map<String, Object> params = new HashMap<>();
        params.put("P_ID_USUARIO", idUsuario);
        params.put("P_ID_SALA", idSala);
        params.put("P_OBJETIVO", objetivo);

        Map<String, Object> result = call.execute(params);

        Number id = (Number) result.get("P_ID_SESSAO");
        return id != null ? id.longValue() : null;
    }

    // -------------------------------------------------------------------------
    // 3) Encerrar sessão
    // -------------------------------------------------------------------------
    public void encerrarSessaoFoco(Long idSessao) {
        SimpleJdbcCall call = new SimpleJdbcCall(dataSource)
                .withCatalogName("HUMANA_WORK_PKG")
                .withProcedureName("ENCERRAR_SESSAO_FOCO");

        Map<String, Object> in = new HashMap<>();
        in.put("P_ID_SESSAO", idSessao);

        call.execute(in);
    }


    // -------------------------------------------------------------------------
    // REF CURSOR GENÉRICO (USADO POR 2 PROCEDURES)
    // -------------------------------------------------------------------------
    private List<Map<String, Object>> executarCursor(String sqlCall, CallableStatementSetter setter, int outParamIndex) {
        return jdbcTemplate.execute(
                (Connection con) -> {
                    CallableStatement cs = con.prepareCall(sqlCall);
                    setter.setValues(cs);
                    return cs;
                },
                (CallableStatementCallback<List<Map<String, Object>>>) cs -> {

                    cs.execute();

                    ResultSet rs = (ResultSet) cs.getObject(outParamIndex);

                    List<Map<String, Object>> list = new ArrayList<>();
                    ResultSetMetaData md = rs.getMetaData();
                    int cols = md.getColumnCount();

                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        for (int i = 1; i <= cols; i++) {
                            row.put(md.getColumnLabel(i), rs.getObject(i));
                        }
                        list.add(row);
                    }

                    rs.close();
                    return list;
                }
        );
    }

    @FunctionalInterface
    interface CallableStatementSetter {
        void setValues(CallableStatement cs) throws SQLException;
    }


    // -------------------------------------------------------------------------
    // 4) Relatório Métricas
    // -------------------------------------------------------------------------
    public List<Map<String, Object>> gerarRelatorioMetricas(Long idUsuario, Date ini, Date fim) {

        return executarCursor(
                "{call HUMANA_WORK_PKG.GERAR_RELATORIO_METRICAS(?,?,?,?)}",
                cs -> {
                    cs.setLong(1, idUsuario);
                    cs.setTimestamp(2, ini != null ? new Timestamp(ini.getTime()) : null);
                    cs.setTimestamp(3, fim != null ? new Timestamp(fim.getTime()) : null);
                    cs.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
                },
                4
        );
    }

    // -------------------------------------------------------------------------
    // 5) Métricas dinâmicas
    // -------------------------------------------------------------------------
    public List<Map<String, Object>> buscarMetricasDinamico(Long idUsuario, String filtro) {

        return executarCursor(
                "{call HUMANA_WORK_PKG.BUSCAR_METRICAS_DINAMICO(?,?,?)}",
                cs -> {
                    cs.setLong(1, idUsuario);
                    cs.setString(2, filtro);
                    cs.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);
                },
                3
        );
    }
}
