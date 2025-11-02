package com.PTHTTM.nhom18;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;

@SpringBootApplication
@EnableAsync
public class Nhom18Application {

	public static void main(String[] args) {
		SpringApplication.run(Nhom18Application.class, args);
	}

  @Bean
  public RestTemplate restTemplate() {
    RestTemplate restTemplate = new RestTemplate();
    // Thêm JSON message converter
    MappingJackson2HttpMessageConverter jsonConverter = new MappingJackson2HttpMessageConverter();
    restTemplate.setMessageConverters(Collections.singletonList(jsonConverter));
    return restTemplate;
  }

}
