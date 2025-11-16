package com.PTHTTM.nhom18.repository;

import com.PTHTTM.nhom18.model.DataSource;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DataSourceRepository extends JpaRepository<DataSource, Long> {
  List<DataSource> findAllByOrderByCreatedAtDesc();
  

}
