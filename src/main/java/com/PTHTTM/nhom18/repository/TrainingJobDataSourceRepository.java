package com.PTHTTM.nhom18.repository;

import com.PTHTTM.nhom18.model.TrainingJobDataSource;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrainingJobDataSourceRepository extends JpaRepository<TrainingJobDataSource, Long> {
    List<TrainingJobDataSource> findByTrainingJobId(Long trainingJobId);
}





