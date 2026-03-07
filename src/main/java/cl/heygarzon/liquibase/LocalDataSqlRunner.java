package cl.heygarzon.liquibase;

import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Component;

@Component
@org.springframework.context.annotation.Profile("local")
@Order(org.springframework.core.Ordered.LOWEST_PRECEDENCE)
public class LocalDataSqlRunner implements ApplicationRunner {

  private static final String DATA_SQL_PATH = "dbinit/data.sql";
  private static final Logger log = LoggerFactory.getLogger(LocalDataSqlRunner.class);

  private final DataSource dataSource;

  public LocalDataSqlRunner(DataSource dataSource) {
    this.dataSource = dataSource;
  }

  @Override
  public void run(ApplicationArguments args) {
    Resource resource = new ClassPathResource(DATA_SQL_PATH);
    if (!resource.exists()) {
      log.warn(
          "Profile 'local' active but resource '{}' not found; skipping data.sql execution.",
          DATA_SQL_PATH);
      return;
    }
    log.info("Executing local data script: {}", DATA_SQL_PATH);
    ResourceDatabasePopulator populator = new ResourceDatabasePopulator(resource);
    populator.setContinueOnError(false);
    populator.execute(dataSource);
    log.info("Local data script '{}' executed successfully.", DATA_SQL_PATH);
  }
}
