package fiap.com.humanawork.dto;

public class AuthResponse {
    private String token;
    private Long userId;     // ✅ Novo: ID do usuário (tipo Long, conforme sua Entity)
    private String userName; // ✅ Novo: Nome completo do usuário

    public AuthResponse() {}

    public AuthResponse(String token, Long userId, String userName) {
        this.token = token;
        this.userId = userId;
        this.userName = userName;
    }

    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }

    // ✅ Getters e Setters para os novos campos
    public Long getUserId() {
        return userId;
    }
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }
}