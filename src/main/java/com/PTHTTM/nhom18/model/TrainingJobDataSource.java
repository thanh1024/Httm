package com.PTHTTM.nhom18.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "tbl_training_job_data_source")
@Getter
@Setter
public class TrainingJobDataSource {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "training_job_id", nullable = false)
    private TrainingJob trainingJob;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "data_source_id", nullable = false)
    private DataSource dataSource;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
}





