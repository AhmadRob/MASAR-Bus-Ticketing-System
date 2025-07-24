package listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import util.DatabaseInitializer;
import util.FareConfig;

@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        DatabaseInitializer.initDatabase();
        FareConfig.init(sce.getServletContext());
        System.out.println("FareConfig initialized successfully.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("App context destroyed.");
    }
}
