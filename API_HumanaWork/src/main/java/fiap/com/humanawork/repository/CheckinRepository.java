package fiap.com.humanawork.repository;

import fiap.com.humanawork.entity.Checkin;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CheckinRepository extends JpaRepository<Checkin, Long> { }
