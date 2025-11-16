package com.PTHTTM.nhom18.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "tbl_data_source_sample")
@Getter
@Setter
public class DataSourceSample {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "data_source_id", nullable = false)
    private DataSource dataSource;

    @Column(name = "text", columnDefinition = "TEXT", nullable = false)
    private String text;

    @Column(name = "rating")
    private Integer rating;

    @Column(name = "label", length = 50)
    private String label;

    @Column(name = "row_index")
    private Integer rowIndex; // Thứ tự dòng trong file gốc

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}

